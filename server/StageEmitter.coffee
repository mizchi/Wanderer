Stage = require './Stage'

class StageEmitter 
  constructor :(@name, @ns_socket,@stage)->
    ns_socket.on "connection" ,(usoc)=>
      save = (char,fn=->)->
        return fn(true,null) unless char?.name
        $db.get char.name, (e,item)->
          $db.save char.name , char.toData() ,(e)->
            fn()
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
    
  serialize:->
    fix = (n)-> ~~(100*n)/100
    objs = @stage.objects.concat (v for k,v of @stage.players)
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

  is_freeze:()->
    not !!('' for k,v of @stage.players).length

  emit : ->
    @ns_socket.emit 'update', @serialize()

module.exports = StageEmitter
