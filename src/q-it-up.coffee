q = require 'q'

arrayFrom = (argumentsObject) ->
  arg for arg in argumentsObject

qItUp = (target, method) -> 
  if method? and method.constructor.name == 'Array'
    obj = {}
    method.forEach (m) -> obj[m] = qItUp target, m
    obj
  else
    ->
      deferred = q.defer()
      [scope, fn] = if method? then [target, target[method]] else [this, target]
      fn.apply scope, arrayFrom(arguments).concat [
        (err, res) -> 
          if err?
            deferred.reject err
          else 
            deferred.resolve if arguments.length == 2 then arguments[1] else arrayFrom(arguments)[1..]
      ]
      deferred.promise
    
module.exports = qItUp