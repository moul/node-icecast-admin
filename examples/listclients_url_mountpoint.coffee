#!/usr/bin/env coffee

# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'

#Admin = require '../src/Admin' # force coffee
{Admin} = require 'icecast-admin'

if process.argv.length < 4
  console.log "usage: #{process.argv[1]} 'http://username:password@hostname:port/' '/mountpoint'"
  process.exit 1

admin = new Admin
  url: process.argv[2]

admin.listClients process.argv[3], (err, result) ->
  if err
    console.log 'Error:', err
  else
    source = result.icestats.source[0]
    console.log "Listeners: #{source.Listeners}"
    for listener in source.listener
      console.log "ID=#{listener.ID}, IP=#{listener.IP}, Connected=#{listener.Connected}, UserAgent=#{listener.UserAgent}"
