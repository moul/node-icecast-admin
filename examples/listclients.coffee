#!/usr/bin/env coffee

# clear terminal
process.stdout.write '\u001B[2J\u001B[0;0f'

#Admin = require '../src/Admin' # force coffee
{Admin} = require 'icecast-admin'

servers = require(process.env[if process.platform == 'win32' then 'USERPROFILE' else 'HOME'] + '/.icecast-servers.json')

for server in servers
  do ->
    admin = new Admin
      url:     server
      verbose: true
    admin.listMounts (err, mountsRoot) ->
      return console.log 'Error:', err if err
      for entry in mountsRoot.icestats.source
        if parseInt(entry.listeners[0]) > 0
          do ->
            mountpoint = entry.$.mount
            admin.listClients mountpoint, (err, result) ->
              return console.log 'Error:', err if err
              source = result.icestats.source[0]
              if source.Listeners > 0
                for listener in source.listener
                  console.log "Server=#{server}, Mountpoint=#{mountpoint}, ID=#{listener.ID}, IP=#{listener.IP}, Connected=#{listener.Connected}, UserAgent=#{listener.UserAgent}"
