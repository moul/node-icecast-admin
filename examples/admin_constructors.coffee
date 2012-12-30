#!/usr/bin/env coffee

# clear terminal
#process.stdout.write '\u001B[2J\u001B[0;0f'

{Admin} = require 'icecast-admin'

admins = []

admins.push new Admin
  url: 'http://username:password@hostname:port/'

admins.push new Admin
  hostname: 'hostname'
  port:     'port'
  username: 'username'
  password: 'port'

admins.push new Admin
  host:     'hostname'
  password: 'password'

admins.push new Admin
  hostname: 'hostname'
  password: 'password'

admins.push new Admin
  host:     'hostname:port'
  password: 'password'

for admin in admins
  console.log ''
  console.log admin.options
