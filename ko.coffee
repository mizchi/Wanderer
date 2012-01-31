@include = ->
  @client '/index.js': ->
    $p = ko.observable
    window.viewModel =
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

      CoolTime : ko.observable []
      selected_panel : ko.observable null

      edit_skill_mode : ko.observable false

      char :
        name : $p '[name]'
        status:
          race : $p '[race]'
          lv : $p '[class]'
          class : $p '[class]'

      set_char : (char)->
        @char.name char.name
        @char.status.class char.status.class
        @char.status.race char.status.race
        @char.status.lv char.status.lv

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
        viewModel.ObjectInfo data.objs
        grr.render data

      socket.on 'update_ct',(data)->
        # # view.ObjectInfo data.objs
        viewModel.CoolTime data.cooltime

      socket.on 'update_char' ,(data)->
        viewModel.set_char data
        # viewModel.char data

    # window.logout = ()=>
    #   socket.disconnet()

