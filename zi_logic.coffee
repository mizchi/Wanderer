Users = require('./models').Users
config = require './config'
{GameCore} = require './src/core'

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

  @client '/bootstrap.js': ->
    window.view =
      ObjectInfo : ko.observable []
      CharInfo : ko.observable null
      CoolTime : ko.observable []
      edit_skill_mode : ko.observable false
      selected_panel : ko.observable null

      use_battle_point: (e)->
        at = $(e.target).attr('target')
        socket.emit 'use_battle_point', at:at

      use_skill_point: (e)->
        at = $(e.target).attr('target')
        socket.emit 'use_skill_point', at:at

      wait_for_skill : (e)->
        at = $(e.target).attr('target')
        @selected_panel at
        @edit_skill_mode true

      set_skill : (e)->
        at = @selected_panel()
        sname = $(e.target).attr('target')
        socket.emit 'set_skill',
          at: at
          sname : sname
        @CharInfo().skills.preset[at] = sname

        @selected_panel null
        @edit_skill_mode false

  # ==== clinet wewbsocket ====
  @client '/index.js': ->
    # fid = 0
    window.login = (name , fid)=>
      window.socket?.disconnect()
      delete window.socket
      window.socket = @connect("http://"+location.host+"/f"+fid)
      socket.emit 'login', name:name
      
      socket.on 'connection',(data)->
        grr.create_map data.map
        grr.events = data.events
        grr.uid = data.uid

      socket.on 'next_floor',(data)->
        socket.disconnect()
        window.floor++
        window.login name , window.floor

      socket.on 'prev_floor',(data)->
        socket.disconnect()
        window.floor--
        window.login name , window.floor

      socket.on 'update',(data)->
        view.ObjectInfo data.objs
        grr.render data

      socket.on 'update_ct',(data)->
        # # view.ObjectInfo data.objs
        view.CoolTime data.cooltime

      socket.on 'update_char' ,(data)->
        view.CharInfo data

    # window.logout = ()=>
    #   socket.disconnet()

