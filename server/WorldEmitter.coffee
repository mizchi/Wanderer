World = require './World'

conf = 
  '中央ダンジョン':
    name : 'CentralDungeon'
    connections : [
      {x:0,y:0}
    ]

class WorldEmitter extends World
  constructor :(socket,conf)->
    @stages = {}
    for name,val of conf
      stage = new Stage(val.name)
      @stages[k] = new StageEmitter name,socket,stage

  emit: ->
    for _ ,stage_emitter of @stages
      stage_emitter.emit() unless stage.is_freeze()
      
module.exports = WorldEmitter