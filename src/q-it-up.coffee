q = require 'q'

arrayFrom = (argumentsObject) ->
  arg for arg in argumentsObject

module.exports = (fn) -> ->
  deferred = q.defer()
  fn.apply this, arrayFrom(arguments).concat [
    (err, res) -> if err then deferred.reject err else deferred.resolve res
  ]
  deferred.promise