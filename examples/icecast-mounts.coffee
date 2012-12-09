#!/usr/bin/env coffee

servers = require(process.env[if process.platform == 'win32' then 'USERPROFILE' else 'HOME'] + '/.icecast-servers.json')
Admin = require('icecast-admin').Admin
Table = require 'cli-table'

keys = [
    'bitrate'
    'channels'
    'listener_peak'
    'listeners'
    'samplerate'
    'slow_listeners'
    'source_ip'
    'total_bytes_read'
    'total_bytes_sent'
]

verbose_keys = [
    'audio_info'
    'public'
    'genre'
    'listenurl'
    'max_listeners'
    'title'
    'server_description'
    'server_name'
    'server_type'
    'server_url'
    'stream_start'
    'user_agent'
]

if process.argv[2] #verbose
    keys = keys.concat verbose_keys

table = new Table
    head: [""].concat keys
lines = []

counter = 0
for server in servers
    do ->
        counter++
        admin = new Admin
            url: server
        admin.getStats (data) ->
            for source in data.icestats.source
                line = {}
                row = line["#{admin.options.hostname.toString()} - #{source.server_name[0]}"] = []
                for key in keys
                    val = source[key][0]
                    row.push val
                lines.push line
            if not --counter
                lines = lines.sort (a, b) ->
                    for own a_key, a_value of a
                        for own b_key, b_value of b
                            return a_key.localeCompare b_key
                for line in lines
                    table.push line
                console.log table.toString()
