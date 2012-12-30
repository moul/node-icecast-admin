#!/usr/bin/env coffee

# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'

#Admin = require '../src/Admin' # force coffee
{Admin} = require 'icecast-admin'

if process.argv.length < 5
  console.log "usage: #{process.argv[1]} 'http://username:password@hostname:port/' '/mountpoint.mp3' 'Song Title'"
  process.exit 1

admin = new Admin
  url: process.argv[2]
  verbose: true

options =
  mount:    process.argv[3]
  fallback: process.argv[4]
admin.updateFallback options, (err, result) ->
  if err
    console.log 'Error:', err
  else
    console.log 'Result:', result

