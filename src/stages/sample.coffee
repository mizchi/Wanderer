{Player} = require('./../Player')
{ObjectId} = require('./../ObjectId')
{MoneyObject} = require('./../sprites')
{pow,sqrt,abs,random,max,min} = Math
{Stage} = require "./../stage"
{HoundDog, Goblin} = require('./../Monster')

class RandomStage extends Stage
  constructor: (@context,@depth,@ns_socket,@db) ->
    ns_socket = @ns_socket
    super()
    root = @create_tworoom 60,60,5
    @_map = root.cmap
    @max_object_count = 10
    @cnt = 0
    @players = {}
    @sockets = {}
    @objects = []

    @events = 
      start : @get_random_point()
      goal : @get_random_point()

    # for ns
    $db = @db
    ns_socket.on "connection" ,(usoc)=>
      save = (char,fn=->)->
        return fn(true,null) unless char?.name
        $db.get char.name, (e,item)->
          $db.save char.name , char.toData() ,(e)->
            fn()
      id = usoc.id 
      player = null
      console.log 'player ',id,' logged in to ', @depth
      @sockets[id] = usoc

      usoc.emit 'connection',
        map: @_map
        events: @events
        uid: id

      usoc.on 'login',(data)=>
        name = data.name
        $db.get name, (e,savedata)=>
          console.log e or savedata
          player = @join id,name,savedata, usoc
          usoc.emit 'update_char',player.toData()

      usoc.on 'logout',(data)=>
        console.log @players[id]

      usoc.on "disconnect" ,(data)=>
        console.log @players[id]
        console.log "Disconnected: #{id}"
        @leave id

        save player , =>
          @leave(id)

      # player action
      usoc.on "keydown" ,(data)->
        console.log data
        player?.keys[data.code] = 1

      usoc.on "keyup" ,(data)->
        console.log data
        player?.keys[data.code] = 0

      usoc.on "click_map" ,(data)->
        player?._wait = 0
        player?.destination =
          x:data.x
          y:data.y

      usoc.on "use_battle_point" ,(data)->
        player?.status.use_battle_point(data.at)
        save player,-> console.log 'save done'
        usoc.emit 'update_char',  player?.toData()

      usoc.on "use_skill_point", (data)->
        player?.skills.use_skill_point(data.at)
        save player,-> console.log 'save done'
        usoc.emit 'update_char' , player?.toData()

      usoc.on "set_skill", (data)->
        at = data.at
        sname = data.sname
        player?.skills.set_key(at, sname)
        usoc.emit 'update_char' , player?.toData()

  emit : ->
    fix = (n)-> ~~(100*n)/100
    objs = @objects.concat (v for k,v of @players)
    ret = objs.map (i)->
      o:[
        fix(i.x)
        fix(i.y)
        i.id
        i.group]
      s:
        n : i.name
        hp :~~(100*i.status.hp/i.status.HP)
        lv: i.status.lv
      t:(unless i.target then null else [
          fix(i.target.x),fix(i.target.y),i.target.id, i.target.group
        ])
      a:[]

    @ns_socket.emit 'update',
      objs: ret

  get_objs:->
    (v for _,v of @players).concat(@objects)

  join : (id,name,data={},__socket)->
    @context.start() unless @context.active
    p = @players[id] = new Player(@,data)
    p.__socket = __socket

    p.status.on_status_change = ->
      p.__socket.emit 'update_char',p.toData()

    [rx,ry]  = @get_random_point()
    p.set_pos rx,ry

    p.id = id
    p.name = name if name?
    return p

  leave : (id)->
    delete @players[id]

  update:()->
    objs = @objects.concat (v for k,v of @players)
    for i in objs
      i.update(objs,@)
    @sweep()
    if @objects.length < @max_object_count and @cnt % 10 is 0
     @pop_monster()

    [gx,gy] = @events.goal
    for k,v of @players
      if v.get_distance(x:gx,y:gy) < 1
        console.log 'change the world from the goal'
        console.log k
        console.log @sockets
        console.log 'go prev floor'
        @sockets[k].emit 'next_floor',{}
        delete @players[k]
        console.log 'delete',k
        @leave k

    # if @depth > 0
    #   [sx,sy] = @events.start
    #   for k,v of @players
    #     if v.get_distance(x:sx,y:sy) < 1
    #       console.log 'go prev floor'
    #       @sockets[k].emit 'prev_floor',{}
    #       console.log @sockets
    #       console.log "logout ",k
    #       @leave k

    @cnt++

  sweep: ()->
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


exports.RandomStage = RandomStage
