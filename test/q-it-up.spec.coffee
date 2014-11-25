qItUp = require '../src/q-it-up'

describe 'Q it up', ->

  it 'takes a cps function and resolves the result in a promise', (done) ->
    cpsMult = (a, b, callback) -> callback null, a * b
    qdCpsMult = qItUp(cpsMult)
    qdCpsMult(10, 10)
    .fail (err) ->
      expect(err).not.toBeDefined()
    .then (res) -> 
      expect(res).toBe 100
    .fin done

  it 'takes a cps function and rejects errors', (done) ->
    cpsDiv = (a, b, callback) -> callback 'Division by zero!', null
    qdCpsDiv = qItUp(cpsDiv)
    qdCpsDiv(1, 0)
    .then (res) -> 
      expect(res).not.toBeDefined()
    .fail (error) ->
      expect(error).toBe 'Division by zero!'
    .fin done

  it 'only rejects errors when the error is null or undefined, not based on truthiness', (done) ->
    returnZero = qItUp (callback) -> callback 0, 'Success'
    returnZero()
    .then (res) ->
      expect(res).not.toBeDefined()
    .fail (error) ->
      expect(error).toBe 0
    .fin done
    
  it 'resolves all arguments after the error on success', (done) ->
    returnMany = qItUp (callback) -> callback null, 1, 2, 3
    returnMany()
    .then (res) ->
      expect(res).toEqual [1, 2, 3]
    .fail (error) ->
      expect(error).not.toBeDefined()
    .fin done 
    
  it 'can be invoked on a named function of an object such that it executes in the correct scope', (done) ->
    class Thing
      constructor: (@n) ->    
      outer: (callback) -> 
        callback null, @n
    outer = qItUp new Thing(42), 'outer'
    outer()
    .then (res) ->
      expect(res).toEqual 42
    .fail (error) ->
      expect(error).not.toBeDefined()
    .fin done
    
  it 'can be used to produce a new object with functions from a given one', (done) ->
    math =
      add: (a, b, callback) -> callback null, a + b
      multiply: (a, b, callback) -> callback null, a * b
    qMath = qItUp math, [ 'add', 'multiply' ]
    qMath.add(2, 2) 
    .then (res) -> 
      expect(res).toBe 4
    .then ->
      qMath.multiply(6, 7)
    .then (res) -> 
      expect(res).toBe 42
    .fin done
    