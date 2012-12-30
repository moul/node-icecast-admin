#!/usr/bin/env coffee

# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'

{Admin} = require 'icecast-admin'

if process.argv.length < 3
  console.log "usage: stats_url.coffee 'http://username:password@hostname:port/'"
  process.exit 1

admin = new Admin
  url: process.argv[2]

admin.stats (err, result) ->
  if err
    console.log 'Error:', err
  else
    console.log 'result', result
    console.log "#{result.icestats.source.length} sources"
    for source in result.icestats.source
      console.log source
