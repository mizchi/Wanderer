class GameRenderer
  getkey : (keyCode) ->
    switch keyCode
      when 68,39 then return 'right'
      when 65,37 then return 'left'
      when 87,38 then return 'up'
      when 83,40 then return 'down'
      when 32 then return 'space'
      when 17 then return 'ctrl'
      when 48 then return '0'
      when 49 then return '1'
      when 50 then return '2'
      when 51 then return '3'
      when 52 then return '4'
      when 53 then return '5'
      when 54 then return '6'
      when 55 then return '7'
      when 56 then return '8'
      when 57 then return '9'
    return String.fromCharCode(keyCode).toLowerCase()

  constructor : (@x,@y,@scale)->
    # @map = null
    @uid = null
    @cam = [0,0]
    @_camn = [0,0]
    @mouse = [0,0]
    @canvas =  document.getElementById "game"
    @g = @canvas.getContext '2d'

    @canvas.width = @x*@scale
    @canvas.height = @y*@scale

    @player_sp = new PlayerSprite @scale
    @char_sp = new CharSprite @scale
    @monster_sp = new MonsterSprite @scale
    @tile_sp = new TileSprite @scale

    window.onkeydown = (e)=>
      console.log e.keyCode
      e.preventDefault()
      key = @getkey(e.keyCode)
      socket.emit "keydown",code:key

    window.onkeyup = (e)=>
      e.preventDefault()
      key = @getkey(e.keyCode)
      if key is 'c' then $('#config').click()
      else
        socket.emit "keyup", code:key

    @canvas.onmousedown = (e)=>
      [dx,dy] = [e.offsetX-@scale*@x/2,e.offsetY-@scale*@y/2]
      [rx,ry] = [
        dx+2*dy
        dx-2*dy
      ]

      [cx,cy] =  @_camn
      console.log cx + rx/@scale, cy + ry/@scale
      socket.emit "click_map", x: ~~(cx+rx/@scale) ,y: ~~(cy + ry/@scale)

    unless (config = localStorage.config)
      config = 
        src : '/audio/kouya.mp3'
        volume : 0.5
      localStorage.config = JSON.stringify config
    else 
      config = JSON.parse localStorage.config

    @bgm = new Audio '/audio/kouya.mp3'
    @bgm.volume = config.volume
    @bgm.loop = true
    @bgm.play() if config.volume > 0 

  change_scale : (scale)->
    @scale = scale
    @canvas.width = @x*@scale
    @canvas.height = @y*@scale

  create_map:(map)->
    @gr_sp = new GroundSprite map ,@scale

  to_ism_native : (x,y)->
    [(x+y)/2
     (x-y)/4
    ]

  to_ism : (x,y)->
    [cx,cy] = @cam
    [
     @scale*@x/2-cx+(x+y)/2
     @scale*@y/2-cy+(x-y)/4
    ]

  ism2pos : (x,y)->
    [dx,dy] = [x-@scale*@x/2,y-@scale*@y/2]
    [cx,cy] = @cam
    [
      dx+2*dy
      dx-2*dy
    ]

  render : (data={})->
    # 扱うオブジェクト
    objs = data.objs
    for i in objs
      [x,y,id,oid] = i.o
      if id is @uid
        @_camn = [x,y]
        @cam = @to_ism_native(x*@scale,y*@scale)
        break
    [cx,cy] = @cam
    # 初期化
    @g.clearRect(0,0,640,480)

    @gr_sp?.draw(@,cx,cy)
    for i in objs
      [x,y,id, oid] = i.o
      {n,hp,lv} = i.s
      [vx,vy] = @to_ism( x*@scale,y*@scale)
      if -64 < vx < 706 and -48 < vy < 528
        if id is @uid 
          @player_sp.draw(@,vx,vy)
          @g.init Color.Blue
        if id > 1000
          @char_sp.draw(@,vx,vy)
          @g.init Color.Green
        else 
          @monster_sp.draw(@,vx,vy)
          @g.init Color.Red
        # drawInfo
        if i.t
          [tx,ty,tid,toid] = i.t
          [tvx,tvy] = @to_ism( tx*@scale,ty*@scale)

          # ターゲット線
          @g.globalAlpha = 0.7
          @g.beginPath()
          @g.moveTo vx,vy
          @g.lineTo tvx,tvy
          @g.stroke()

          #ロックオンカーソル
          {PI} = Math
          # @g.init Color.i(0,0,0)
          @g.beginPath()
          @g.arc(tvx+@scale/8,tvy, ~~(@scale/2) ,-PI/6,PI/6,false)
          @g.stroke()
          @g.beginPath()
          @g.arc(tvx+@scale/8,tvy, ~~(@scale/2) ,5*PI/6,7*PI/6,false)
          @g.stroke()
          # @g.moveTo tvx-@size/2-3,tvy-@size/2
          # @g.lineTo tvx-@size-3,tvy
          # @g.lineTo tvx-@size/2-3,tvy+@size/2
          @g.stroke()

        @g.init Color.White
        @g.initText @scale/10, 'Georgia'
        @g.fillText ''+~~(hp) , vx-6,vy-@scale/4
        @g.fillText n+".Lv"+lv , vx-10,vy+6
    # @gr_sp?.draw_upper(@g,cx,cy)

    # start 
    # [sx,sy] = @events.start
    # [vx,vy] = @to_ism( sx*@scale,sy*@scale)
    # @g.init Color.i(255,64,64),0.8
    # @g.arc( vx , vy ,@scale/2 ,0 , 2*Math.PI )
    # @g.fill()

    # goal 
    [gx,gy] = @events.goal
    [vx,vy] = @to_ism( gx*@scale,gy*@scale)
    @g.init Color.i(64,64,255),0.8
    @g.arc( vx , vy ,@scale/2 ,0 , 2*Math.PI )
    @g.fill()

    # goal 

