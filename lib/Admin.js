var Admin,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Admin = (function() {

  function Admin(options) {
    this.options = options;
    this.getStats = __bind(this.getStats, this);

    this.parseStats = __bind(this.parseStats, this);

    this.fetchStats = __bind(this.fetchStats, this);

    this.handleOptions = __bind(this.handleOptions, this);

    this.handleOptions();
    return this;
  }

  Admin.prototype.handleOptions = function() {
    var host, key, value, _base, _base1, _base2, _base3, _base4, _base5, _base6, _base7, _base8, _base9, _ref, _ref1, _ref10, _ref11, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
    if (this.options.url != null) {
      _ref = require('url').parse(this.options.url);
      for (key in _ref) {
        value = _ref[key];
        if ((_ref1 = (_base = this.options)[key]) == null) {
          _base[key] = value;
        }
      }
    }
    if (this.options.auth != null) {
      _ref2 = this.options.auth.split(':'), this.options.username = _ref2[0], this.options.password = _ref2[1];
    }
    if (this.options.ssl != null) {
      if ((_ref3 = (_base1 = this.options).protocol) == null) {
        _base1.protocol = 'https:';
      }
    }
    if ((_ref4 = (_base2 = this.options).host) == null) {
      _base2.host = this.options.hostname;
    }
    host = this.options.host.split(':');
    if ((_ref5 = (_base3 = this.options).hostname) == null) {
      _base3.hostname = host[0];
    }
    if ((_ref6 = (_base4 = this.options).port) == null) {
      _base4.port = host[1];
    }
    if ((_ref7 = (_base5 = this.options).username) == null) {
      _base5.username = 'admin';
    }
    if ((_ref8 = (_base6 = this.options).protocol) == null) {
      _base6.protocol = 'http:';
    }
    if ((_ref9 = (_base7 = this.options).port) == null) {
      _base7.port = this.options.protocol === 'https:' ? 443 : 80;
    }
    this.options.port = parseInt(this.options.port);
    if ((_ref10 = (_base8 = this.options).path) == null) {
      _base8.path = '/';
    }
    if ((_ref11 = (_base9 = this.options).pathname) == null) {
      _base9.pathname = this.options.path;
    }
    this.options.host = "" + this.options.hostname + ":" + this.options.port;
    delete this.options.href;
    delete this.options.url;
    delete this.options.slashes;
    return delete this.options.auth;
  };

  Admin.prototype.fetchStats = function(fn) {
    var client;
    if (fn == null) {
      fn = null;
    }
    client = require('http').request({
      host: this.options.hostname,
      port: this.options.port,
      method: 'GET',
      path: "" + this.options.path + "admin/stats.xml",
      headers: {
        'Host': this.options.hostname,
        'Authorization': 'Basic ' + new Buffer("" + this.options.username + ":" + this.options.password).toString('base64')
      }
    });
    client.end();
    return client.on('response', function(response) {
      var buffer;
      buffer = '';
      response.on('data', function(chunk) {
        return buffer += chunk;
      });
      return response.on('end', function() {
        return fn(buffer);
      });
    });
  };

  Admin.prototype.parseStats = function(buffer, fn) {
    var x2js;
    if (fn == null) {
      fn = null;
    }
    x2js = new (require('xml2js')).Parser({});
    x2js.addListener('end', function(result) {
      return fn(result);
    });
    return x2js.parseString(buffer);
  };

  Admin.prototype.getStats = function(fn) {
    var _this = this;
    if (fn == null) {
      fn = null;
    }
    return this.fetchStats(function(buffer) {
      return _this.parseStats(buffer, fn);
    });
  };

  return Admin;

})();

module.exports = Admin;
