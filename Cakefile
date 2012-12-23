{spawn, exec} = require 'child_process'

call = (command, args = [], fn = null) ->
  exec "#{command} #{args.join(' ')}", (err, stdout, stderr) ->
    if err?
      console.error "Error :"
      return console.dir   err
    fn err if fn

system = (command, args) ->
  spawn command, args, stdio: "inherit"

task 'build', 'continually build the JavaScript code', ->
  call 'coffee',     ['-c', '-o', 'lib', 'src']
  call 'coffee',     ['-c', '-o', 'examples', 'examples']
  call 'browserify', ['src/BrowserEntry.coffee', '-o', 'browser/icecast-admin.js']

task 'doc', 'rebuild the Docco documentation', ->
    exec([
        'docco src/*.coffee'
    ].join(' && '), (err) ->
        throw err if err
    )
