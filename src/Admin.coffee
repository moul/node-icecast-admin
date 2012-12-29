class Admin
  constructor: (@options) ->
    do @handleOptions
    return @

  handleOptions: =>
    if @options.url?
      for key, value of require('url').parse @options.url
        @options[key] ?= value
    if @options.auth?
      [@options.username, @options.password] = @options.auth.split ':'
    if @options.ssl?
      @options.protocol ?= 'https:'
    @options.host ?= @options.hostname
    host = @options.host.split ':'
    @options.hostname ?= host[0]
    @options.port ?= host[1]
    @options.username ?= 'admin'
    @options.protocol ?= 'http:'
    @options.port ?= if @options.protocol is 'https:' then 443 else 80
    @options.port = parseInt @options.port
    @options.path ?= '/'
    @options.pathname ?= @options.path
    @options.host = "#{@options.hostname}:#{@options.port}"
    delete @options.href
    delete @options.url
    delete @options.slashes
    delete @options.auth

  fetchStats: (fn = null) =>
    client = require('http').request
      host: @options.hostname
      port: @options.port
      method: 'GET'
      path: "#{@options.path}admin/stats.xml"
      headers:
        'Host': @options.hostname
        'Authorization': 'Basic ' + new Buffer("#{@options.username}:#{@options.password}").toString('base64')
    client.on 'error', (err) -> fn err, {}
    client.end()
    client.on 'response', (response) ->
      buffer = ''
      response.on 'data', (chunk) ->
        buffer += chunk
      response.on 'end', ->
        fn null, buffer if fn

  parseXml: (buffer, fn = null) =>
    x2js = new (require('xml2js')).Parser {}
    #x2js.on 'error', ->
    x2js.on 'end', (result) ->
      fn null, result
    x2js.parseString buffer

  getStats: (fn = null) =>
    @fetchStats (err, buffer) =>
      if err
        return fn err, {}
      @parseXml buffer, (err, object) =>
        if err
          return fn err, object
        if not object.icestats?.source?[0]?
          return fn {"code": 'INVALID XML'}, object
        return fn null, object

module.exports = Admin
