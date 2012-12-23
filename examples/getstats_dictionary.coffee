#!/usr/bin/env coffee

{Admin} = require('..')

admin = new Admin
    host: 'ted.onouo.com'
    port: 8000
    password: 'ia6MuiCh'

admin.getStats (result) ->
    console.log 'result', result
