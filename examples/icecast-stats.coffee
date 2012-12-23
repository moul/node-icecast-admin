#!/usr/bin/env coffee

servers = require(process.env[if process.platform == 'win32' then 'USERPROFILE' else 'HOME'] + '/.icecast-servers.json')
{Admin} = require('icecast-admin')
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
            lines.push line
            if not --counter
                lines = lines.sort (a, b) ->
                    for own a_key, a_value of a
                        for own b_key, b_value of b
                            return a_key.localeCompare b_key
                table.push line for line in lines
                line = {}
                row = line['Total'] = []
                row.push value for key, value of total
                table.push line
                console.log table.toString()
