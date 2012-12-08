#!/usr/bin/env coffee

servers = require(process.env[if process.platform == 'win32' then 'USERPROFILE' else 'HOME'] + '/.icecast-servers.json')
Admin = require('icecast-admin').Admin
Table = require 'cli-table'

total =
    client_connections:   0
    clients:              0
    connections:          0
    listener_connections: 0
    listeners:            0

table = new Table
    head: ["", "Client Connections", "Clients", "Connections", "Listener Connections", "Listeners"]
lines = []

counter = 0
for server in servers
    do ->
        counter++
        admin = new Admin
            url: server
        admin.getStats (data) ->
            line = {}
            row = line[admin.options.hostname.toString()] = []
            for key, value of total
                val = parseInt data.icestats[key][0]
                total[key] += val
                row.push val
            table.push line
            if not --counter
                line = {}
                row = line['Total'] = []
                for key, value of total
                    row.push value
                table.push line
                console.log table.toString()
