# {Player} = require('./../Player')
# {ObjectId} = require('./../ObjectId')
# {MoneyObject} = require('./../sprites')
# {pow,sqrt,abs,random,max,min} = Math
# {Stage} = require "./../stage"
# {HoundDog, Goblin} = require('./../Monster')
Map = require './../map/Map'
Stage = require './Stage'

class CentralDungeon extends Stage
  constructor: (@context)->
    super()
    @monsters = []
    @events = []
    @map = new Map
    @max_object_count = 10


  build:->
    ns_socket = @ns_socket
    super()
    root = @create_tworoom 60,60,5
    @_map = root.cmap

    @events = 
      start : @get_random_point()
      goal : @get_random_point()


  update:()->
    super()
    @map.update()
    player.update for id,player of @players
    monster.update for monster in @monsters

    # if @objects.length < @max_object_count and @cnt % 10 is 0
    #  @pop_monster()


  sweep_monster: ()->
    for i in [0 ... @objects.length]
      if @objects[i].is_dead() and @objects[i].cnt > 5
        @objects.splice(i,1)
        break

    for id,p of @players
      if p.is_dead() and p.cnt > 60
        console.log 'dead:',p.id,p.name
        console.log  p.toData()
        p.status.hp = p.status.HP
        [rx,ry]  = @get_random_point()
        p.set_pos rx,ry
        # @join id,p.name, p.toData(),p.__socket

  pop_monster: () ->
    [rx,ry]  = @get_random_point()
    if random() < 0.8
      @objects.push( monster = new Goblin(@, 
        ~~(@depth*3+3*Math.random()) ,
        ObjectId.Enemy)
      )
    else
      @objects.push( monster = new HoundDog(@, 
        ~~(1+@depth*2+3*Math.random()) ,
        ObjectId.Enemy)
      )
    monster.set_pos rx,ry


module.exports = CentralDungeon
