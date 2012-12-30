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

  # This admin function provides the ability to query the internal statistics kept by the icecast server. Almost all information about the internal workings of the server such as the mountpoints connected, how many client requests have been served, how many listeners for each mountpoint, etc, are available via this admin function.
  # Note that this admin function can also be invoked via the http://server:port/admin/stats.xml syntax, however this syntax should not be used and will eventually become deprecated.
  stats: (fn = null) =>
    @fetchAndParse "admin/stats", (err, object) =>
      return fn {"code": 'INVALID XML'}, object unless object.icestats?.source?[0]?
      return fn null, object

  # This admin function provides the ability to view all the currently connected mountpoints.
  listMounts: (fn = null) =>
    @fetchAndParse "admin/listmounts", (err, object) =>
      return fn {"code": 'INVALID XML'}, object unless object.icestats?.source?[0]?
      return fn null, object

  # This function lists all the clients currently connected to a specific mountpoint. The results are sent back in XML form.
  listClients: (mountpoint, fn = null) =>
    @fetchAndParse "admin/listclients?mount=#{mountpoint}", (err, object) =>
      return fn {"code": 'INVALID XML'}, object unless object.icestats?.source?[0]?
      return fn null, object

  # This function provides the ability for either a source client or any external program to update the metadata information for a particular mountpoint.
  updateMetadata: (options, fn = null) =>
    return fn {"BADPARAMS"}, {} unless options.mount?
    return fn {"BADPARAMS"}, {} unless options.song?
    @fetchAndParse "admin/metadata?mount=#{options.mount}&mode=updinfo&song=#{encodeURI(options.song)}", (err, object) =>
      return fn {"code": "INVALID XML"}, object unless object.iceresponse?.message?[0]?
      return fn err, object

  # This function provides the ability for either a source client or any external program to update the "fallback mountpoint" for a particular mountpoint. Fallback mounts are those that are used in the even of a source client disconnection. If a source client disconnects for some reason that all currently connected clients are sent immediately to the fallback mountpoint.
  updateFallback: (options, fn = null) =>
    return fn {"BADPARAMS"}, {} unless options.mount?
    return fn {"BADPARAMS"}, {} unless options.fallback?
    @fetchAndParse "admin/fallbacks?mount=#{options.mount}&fallback=#{options.fallback}", (err, object) =>
      return fn {"code": "FAILED"}, object unless object.html?.head?
      return fn err, object

  # This function provides the ability to migrate currently connected listeners from one mountpoint to another. This function requires 2 mountpoints to be passed in: mount (the *from* mountpoint) and destination (the *to* mountpoint). After processing this function all currently connected listeners on mount will be connected to destination. Note that the destination mountpoint must exist and have a sounce client already feeding it a stream.
  # http://192.168.1.10:8000/admin/moveclients?mount=/mystream.ogg&destination=/mynewstream.ogg
  moveCLients: => console.log "TODO"

  # This function provides the ability to disconnect a specific listener of a currently connected mountpoint. Listeners are identified by a unique id that can be retrieved by via the "List Clients" admin function. This id must be passed in to the request. After processing this request, the listener will no longer be connected to the mountpoint.
  # http://192.168.1.10:8000/admin/killclient?mount=/mystream.ogg&id=21
  killClient: => console.log "TODO"

  # This function will provide the ability to disconnect a specific mountpoint from the server. The mountpoint to be disconnected is specified via the variable "mount".
  # http://192.168.1.10:8000/admin/killsource?mount=/mystream.ogg
  killSource: => console.log "TODO"


module.exports = Admin
