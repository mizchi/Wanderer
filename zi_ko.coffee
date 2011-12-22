@include = ->
  @client '/index.js': ->
    window.view =
      keys : 
        1:null
        2:null
        3:null
        4:null
        5:null
        6:null
        7:null
        8:null
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

