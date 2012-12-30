class Admin
  constructor: (@options) ->
    do @handleOptions
    @http = require 'http'
    return @

  handleOptions: =>
    if @options.url?
      @options[key] ?= value for key, value of require('url').parse @options.url
    [@options.username, @options.password] = @options.auth.split ':' if @options.auth?
    @options.protocol ?=   'https:' if @options.ssl?
    @options.host ?=       @options.hostname
    host =                 @options.host.split ':'
    @options.hostname ?=   host[0]
    @options.port ?=       host[1]
    @options.username ?=   'admin'
    @options.protocol ?=   'http:'
    @options.port ?=       if @options.protocol is 'https:' then 443 else 80
    @options.port =        parseInt @options.port
    @options.path ?=       '/'
    @options.pathname ?=   @options.path
    @options.host =        "#{@options.hostname}:#{@options.port}"
    @options.verbose ?=    false
    delete @options.href
    delete @options.url
    delete @options.slashes
    delete @options.auth

  fetchXml: (path, fn = null) =>
    fullpath = "#{@options.path}#{path}"
    if @options.verbose
      console.info "Fetching #{fullpath}"
    client = @http.request
      host:   @options.hostname
      port:   @options.port
      method: 'GET'
      path:   fullpath
      headers:
        'Host':          @options.hostname
        'Authorization': 'Basic ' + new Buffer("#{@options.username}:#{@options.password}").toString('base64')
    client.on 'error', (err) -> fn err, {}
    client.end()
    client.on 'response', (response) ->
      if response.statusCode != 200
        return fn {"code": "BADSTATUSCODE", "message": response.statusCode}, {}
      buffer = ''
      response.on 'data', (chunk) ->
        buffer += chunk
      response.on 'end', ->
        fn null, buffer if fn

  parseXml: (buffer, fn = null) =>
    x2js = new (require('xml2js')).Parser {}
    x2js.on 'end', (result) -> fn null, result
    x2js.parseString buffer

  fetchAndParse: (path, fn = null) =>
    @fetchXml path, (err, buffer) =>
      return fn err, {} if err
      @parseXml buffer, (err, object) =>
        return fn err, object if err
        return fn null, object

  stats: (fn = null) =>
    @fetchAndParse "admin/stats", (err, object) =>
      return fn {"code": 'INVALID XML'}, object if not object.icestats?.source?[0]?
      return fn null, object

  listMounts: (fn = null) =>
    @fetchAndParse "admin/listmounts", (err, object) =>
      return fn {"code": 'INVALID XML'}, object if not object.icestats?.source?[0]?
      return fn null, object

  listClients: (mountpoint, fn = null) =>
    @fetchAndParse "admin/listclients?mount=#{mountpoint}", (err, object) =>
      return fn {"code": 'INVALID XML'}, object if not object.icestats?.source?[0]?
      return fn null, object

module.exports = Admin
