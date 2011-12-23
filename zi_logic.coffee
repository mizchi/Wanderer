Users = require('./models').Users
config = require './config'
{GameCore} = require './server/core'

dungeon_depth = 50

@include = ->
  game = new GameCore {},dungeon_depth,@io,Users
  game.start()

  game.ws = =>
    c = 0
    for stage in game.stages
      c++
      pnames = (v.name for k,v of stage.players)
      if pnames.length
        stage.emit()
        for k,p of stage.players
          buff = []
          for i in [1..9]
            if s = p.skills.sets[i]
              buff.push ~~(100*s.ct/s.CT)
          stage.sockets[k].emit 'update_ct',cooltime:buff
        #   if game.cnt%(15*120) is 0
        #     @io.sockets.socket(id).emit 'update_char',player.toData()

