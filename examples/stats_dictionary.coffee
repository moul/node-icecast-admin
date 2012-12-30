#!/usr/bin/env coffee

{Admin} = require 'icecast-admin'

admin = new Admin
  host: 'localhost'
  port: 8000
  password: 'hackme'

admin.stats (err, result) ->
  if err
    console.log 'Error:', err
  else
    console.log 'result', result
