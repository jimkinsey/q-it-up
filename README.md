Q it Up
=======

Magically* make functions which take callbacks instead return promises as provided by the magnificent Q library!

\* not magically

    qItUp = require('q-it-up');
    request = qItUp(require('request'));
    
    request('http://tfwiki.net').then(function(response) {
      return 'Got a ' + response.statusCode;
    });

Installation
------------

    npm install q-it-up --save

Usage
-----

Q-it-up provides a function which takes a CPS (continuation passing style) function and fills in the callback with one which resolves (or rejects) using a Q  promise.

That is, any function which works by taking a callback with a signature where an error is passed as the first argument and results passed as the remaining arguments:

    mult = function(a, b, callback) {
      return callback(null, a * b);
    };
    
    mult(7, 6, function(err, res) {
      return console.log(res);
    });
    
This can be "Q'd up" to instead return a promise:

    mult = qItUp(function(a, b, callback) {
      return callback(null, a * b); 
    });
    
    mult(7,6).then(console.log); // 42
    
If an error is passed to the callback, this will be rejected with Q:

    fail = qItUp(function(message, callback) {
      return callback(message);
    });
    
    fail("An error occurred!").then(null, console.warn); // An error occurred!

If multiple values are passed to the callback on success these will be resolved as an array:

    split = qItUp(function(str, separator, callback)) {
      return callback.apply(this, [ null ].concat(str.split(separator)));
    });
    
    split('1:2:3', ':').then(function(results) {
       return console.log(results);
    }); // [ 1, 2, 3 ]
    
A method on an object may be q'd up by specifying the object and the name of the method:

    client = new ApiClient();
    
    get = qItUp(client, 'get');
  
This ensures that the method is executed in the correct scope (that of the owning object). A proxy object with q'd up functions can be created like so:

    client = qItUp(new ApiClient(), [ 'get', 'post', 'delete' ]);

Only the named functions will be q'd up and available on the proxy. If other methods on the original need to be accessed, then a reference it will need to be maintained.

TODO
----

Widen support to other patterns of CPS - separate error and success callbacks, callbacks where error and success parameters are at different positions, callbacks just for success.
