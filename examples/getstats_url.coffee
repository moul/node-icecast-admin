#!/usr/bin/env coffee

# usage: getstats_url.coffee 'http://username:password@hostname:port/'

# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'

Admin = require('..').Admin

admin = new Admin
    url: process.argv[2]

admin.getStats (result) ->
    console.log 'result', result
    console.log "#{result.icestats.source.length} sources"
    for source in result.icestats.source
        console.log source
