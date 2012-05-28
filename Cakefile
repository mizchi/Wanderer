{ spawn, exec } = require 'child_process'
config = require './config/config.json'

run = (cmd, args) ->
  proc = spawn cmd, args
  proc.stderr.pipe process.stderr, end: false
  proc.stdout.pipe process.stdout, end: false
  proc.on 'exit', (status) ->
    process.kill(1) if status != 0

task 'run', 'Start the app', ->
  run 'coffee', ['app.coffee', port]

task 'dev', 'hot reload starting', ->
  run 'node-dev', ['app.coffee', port]

task 'test', 'Run mocha tests', ->
  run 'node', ['node_modules/mocha/bin/mocha',
               '--colors'
               '--require', 'should'
               '--reporter', 'spec'
               '--compilers', 'coffee:coffee-script']

task 'doc', 'Createe Docs', ->
  run 'docco', []
