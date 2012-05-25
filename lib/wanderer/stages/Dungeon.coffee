Map = require './../map/Map'
Stage = require './Stage'
Goblin = require './../character/monster/Goblin'

class Dungeon extends Stage
  constructor: (@context)->
    super()
    @monsters = []
    @events = []
    @map = new Map @
    @max_spawn_count = 30

  update:()->
    super()
    @map.update()
    player.update() for id,player of @players
    monster.update() for monster in @monsters
    @spawn_monster()


  sweep_corpses: ()->
    for mon , i in @monsters
      if @monsters[i].is_dead() and @monsters[i].cnt > 5
        @monsters.splice(i,1)
        break

  spawn_monster: () ->
    if @monsters.length < @max_spawn_count
      g = new Goblin(@)
      g.group_id = Number.random 0, 1

      g.x = Number.random 1,@map.cmap.length-2
      g.y = Number.random 1,@map.cmap[0].length-2
      @monsters.push g


module.exports = Dungeon
