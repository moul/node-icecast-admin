#!/usr/bin/env coffee

# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'

#Admin = require '../src/Admin' # force coffee
{Admin} = require 'icecast-admin'

if process.argv.length < 3
  console.log "usage: #{process.argv[1]} 'http://username:password@hostname:port/'"
  process.exit 1

admin = new Admin
  url: process.argv[2]

admin.listMounts (err, mountsRoot) ->
  return console.log 'Error:', err if err
  for entry in mountsRoot.icestats.source
    do ->
      mountpoint = entry.$.mount
      admin.listClients mountpoint, (err, result) ->
        return console.log 'Error:', err if err
        source = result.icestats.source[0]
        if source.Listeners > 0
          for listener in source.listener
            console.log "Mountpoint=#{mountpoint}, ID=#{listener.ID}, IP=#{listener.IP}, Connected=#{listener.Connected}, UserAgent=#{listener.UserAgent}"
