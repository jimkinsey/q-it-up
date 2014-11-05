(function() {
  var arrayFrom, q;

  q = require('q');

  arrayFrom = function(argumentsObject) {
    var arg, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = argumentsObject.length; _i < _len; _i++) {
      arg = argumentsObject[_i];
      _results.push(arg);
    }
    return _results;
  };

  module.exports = function(fn) {
    return function() {
      var deferred;
      deferred = q.defer();
      fn.apply(this, arrayFrom(arguments).concat([
        function(err, res) {
          if (err) {
            return deferred.reject(err);
          } else {
            return deferred.resolve(res);
          }
        }
      ]));
      return deferred.promise;
    };
  };

}).call(this);
