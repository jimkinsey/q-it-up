(function() {
  var arrayFrom, q, qItUp;

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

  qItUp = function(target, method) {
    var obj;
    if ((method != null) && method.constructor.name === 'Array') {
      obj = {};
      method.forEach(function(m) {
        return obj[m] = qItUp(target, m);
      });
      return obj;
    } else {
      return function() {
        var deferred, fn, scope, _ref;
        deferred = q.defer();
        _ref = method != null ? [target, target[method]] : [this, target], scope = _ref[0], fn = _ref[1];
        fn.apply(scope, arrayFrom(arguments).concat([
          function(err, res) {
            if (err != null) {
              return deferred.reject(err);
            } else {
              return deferred.resolve(arguments.length === 2 ? arguments[1] : arrayFrom(arguments).slice(1));
            }
          }
        ]));
        return deferred.promise;
      };
    }
  };

  module.exports = qItUp;

}).call(this);
