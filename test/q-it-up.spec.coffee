qItUp = require '../src/q-it-up'

describe 'Q it up', ->

  it 'takes a cps function and resolves the result in a promise', (done) ->
    cpsMult = (a, b, callback) -> callback null, a * b
    qdCpsMult = qItUp(cpsMult)
    qdCpsMult(10, 10)
    .fail (err) ->
      expect(err).not.toBeDefined
    .then (res) -> 
      expect(res).toBe 100
    .fin done

  it 'takes a cps function and rejects errors', (done) ->
    cpsDiv = (a, b, callback) -> callback 'Division by zero!', null
    qdCpsDiv = qItUp(cpsDiv)
    qdCpsDiv(1, 0)
    .then (res) -> 
      expect(res).not.toBeDefined
    .fail (error) ->
      expect(error).toBe 'Division by zero!'
    .fin done
