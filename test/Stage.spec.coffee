require 'sugar'
Object.extend()

Stage = require './../server/stage/Stage'
Dungeon = require './../server/stage/Dungeon'
Map = require './../server/map/Map'

mock = require './mock'

describe 'StageTest',->
  stage = null
  char = null
  id = '58327894321491'

  it "初期化",->
    stage = new Stage
    char = mock.get_char()

  it "update",->
    stage.update()
    stage.cnt.should.equal 1
  
  it "join",->
    stage.join id,char
    stage.players[id].id.should.equal id

  it "leave",->
    stage.leave char.id
    stage.players.keys().length.should.equal 0

