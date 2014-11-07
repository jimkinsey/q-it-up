q = require 'q'

arrayFrom = (argumentsObject) ->
  arg for arg in argumentsObject

module.exports = (fn) -> ->
  deferred = q.defer()
  fn.apply this, arrayFrom(arguments).concat [
    (err, res) -> 
      if err?
        deferred.reject err
      else 
        deferred.resolve if arguments.length == 2 then arguments[1] else arrayFrom(arguments)[1..]
  ]
  deferred.promise