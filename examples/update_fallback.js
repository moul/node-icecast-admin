// Generated by CoffeeScript 1.6.2
(function() {
  var Admin, admin, options;

  process.stdout.write('\u001B[2J\u001B[0;0f');

  Admin = require('icecast-admin').Admin;

  if (process.argv.length < 5) {
    console.log("usage: " + process.argv[1] + " 'http://username:password@hostname:port/' '/mountpoint.mp3' 'Song Title'");
    process.exit(1);
  }

  admin = new Admin({
    url: process.argv[2],
    verbose: true
  });

  options = {
    mount: process.argv[3],
    fallback: process.argv[4]
  };

  admin.updateFallback(options, function(err, result) {
    if (err) {
      return console.log('Error:', err);
    } else {
      return console.log('Result:', result);
    }
  });

}).call(this);
