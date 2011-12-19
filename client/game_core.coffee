class Sprite
  constructor: (@x=0,@y=0,@scale=10) ->
  render: (g)->
    g.beginPath()
    g.arc(@x,@y, 15 ,0,Math.PI*2,true)
    g.stroke()

  get_distance: (target)->
    xd = Math.pow (@x-target.x) ,2
    yd = Math.pow (@y-target.y) ,2
    return Math.sqrt xd+yd

  find_obj:(group_id,targets, range)->
    targets.filter (t)=>
      t.group is group_id and @get_distance(t) < range

class ImageSprite
  constructor:(src,@size)->
    @img = new Image
    @img.src = src
  draw:(context)->
    context.g.drawImage(@img, x,y)

class CanvasSprite
  constructor:(@size=32)->
    buffer = document.createElement('canvas')
    buffer.width = buffer.height = @size
    @shape buffer.getContext('2d')
    @img = new Image
    @img.src = buffer.toDataURL()

  p2ism : (x,y)->
    [(x+y)/2
     (x-y)/4
    ]

  draw:(context,x,y)->
    dx = dy = ~~(context.scale/2)
    context.g.drawImage(@img, x-dx,y-dy)

class CharSprite extends CanvasSprite
  shape: (g)->
    cx = cy = 16 
    g.init Color.i(64,255,64)
    g.arc( cx , cy-7 ,3 ,0 , 2*Math.PI )
    g.fill()

    g.beginPath()
    g.moveTo cx,cy
    g.lineTo(xx,yy) for [xx,yy] in [
      [cx-4  , cy-3 ]
      [cx+4  , cy-3 ]
    ]
    g.lineTo cx,cy
    g.fill()

class PlayerSprite extends CanvasSprite
  shape: (g)->
    cx = cy = 16 
    g.init Color.i(64,64,255)
    g.arc( cx , cy-7 ,3 ,0 , 2*Math.PI )
    g.fill()

    g.beginPath()
    g.moveTo cx,cy
    g.lineTo(xx,yy) for [xx,yy] in [
      [cx-4  , cy-3 ]
      [cx+4  , cy-3 ]
    ]
    g.lineTo cx,cy
    g.fill()

class MonsterSprite extends CanvasSprite
  shape: (g,color)->
    cx = cy = 16 
    g.init color or Color.i(255,64,64)
    g.arc( cx , cy-7 ,3 ,0 , 2*Math.PI )
    g.fill()

    g.beginPath()
    g.moveTo cx,cy
    g.lineTo(xx,yy) for [xx,yy] in [
      [cx-4  , cy-3 ]
      [cx+4  , cy-3 ]
    ]
    g.lineTo cx,cy
    g.fill()

class TileSprite extends CanvasSprite
  shape: (g)->
    g.init(Color.Black)
    g.moveTo 0,16
    g.lineTo(x,y) for [x,y] in [
      [16,24] , [32,16], [16,8]
    ]
    g.lineTo 0,16
    g.fill()

  draw:(g,x,y)->
    g.drawImage(@img, x,y)

class GroundSprite extends CanvasSprite
  constructor:(@map , @scale=32)->
    @i_scale = 18
    @ip = [500,2000]
    [x,y] = [@map.length , @map[0].length]
    gr = document.createElement('canvas')
    gr.width  = @scale*x*2+@ip[0]
    gr.height = @scale*y+@ip[1]
    @gr = gr

    # up = document.createElement('canvas')
    # up.width = @scale*100
    # up.height = @scale*100

    @shape gr.getContext('2d') #,up.getContext('2d')
    @ground = new Image
    @ground.src = gr.toDataURL 'image/gif'
    # mini = document.getElementById('map')
    # mini.src = gr.toDataURL()

    # @upper = new Image
    # @upper.src = up.toDataURL()

  p2ism : (x,y)->
    [ix,iy]= @ip
    [(x+y)/2+ix
     (x-y)/4+iy
    ]

  shape: (g,u)->
    for i in [0 ... @map.length]
      for _j in [0 ... @map[i].length]
        j = @map[i].length - _j - 1 
        [vx,vy] = @p2ism i*@i_scale ,j*@i_scale

        unless @map[i][j] # 通路
          g.init Color.i(128,128,128)
          g.moveTo vx,vy
          g.lineTo(x,y) for [x,y] in [
            [vx+@i_scale/2,vy+@i_scale/4],[vx+@i_scale,vy],[vx+@i_scale/2,vy-@i_scale/4]
          ]
          g.lineTo vx,vy
          g.fill()
        else # 壁
          # u.init Color.i(64,64,64)
          # 動的なハイト生成パターン
          # h = ~~(3+Math.random()*2)*16
          # h = ~~(j/@map[0].length*20)*8
          # 上の壁
          # uy = vy - h
          # u.moveTo vx,uy
          # u.lineTo(x,y) for [x,y] in [
          #   [vx+16,uy+8],[vx+32,uy],[vx+16,uy-8]
          # ]
          # u.lineTo vx,uy
          # u.fill()

          # # 左柱
          # g.init Color.i(62,62,62)
          # g.moveTo vx,vy
          # g.lineTo(x,y) for [x,y] in [
          #   [vx,vy-h],[vx+16,vy-h],[vx+16,vy+8]
          # ]
          # g.lineTo vx,vy
          # g.fill()

          # # 右柱
          # g.init Color.i(48,48,48)
          # g.moveTo vx+16,vy+8
          # g.lineTo(x,y) for [x,y] in [
          #   [vx+16,vy+8-h],[vx+32,vy-h],[vx+32,vy]
          # ]
          # g.lineTo vx+16,vy+8
          # g.fill()


# g.drawImage(@ground, cx-320+ix, cy+iy-240, 640, 480, 0 , 0 , 640, 480)
  draw:(context,cx,cy)->
    [ix,iy]= @ip
    size_x = context.scale * context.x
    size_y = context.scale * context.y

    internal_x = @i_scale * context.x
    internal_y = @i_scale * context.y

    fx =  (cx-size_x/2) * @i_scale / context.scale  
    fy =  (cy-size_y/2) * @i_scale / context.scale

    try
      context.g.drawImage(
        @ground, 
        fx+ix, fy+iy, 
        internal_x, internal_y, 
        0 , 0 , size_x, size_y
      )
    catch e
      console.log 'from', fx+ix , fy+iy
      console.log 'to', fx+ix+internal_x , fy+iy+internal_y
      console.log 'size', @gr.width , @gr.height

  # draw_upper:(g,cx,cy)->
  #   [ix,iy]= @ip
  #   size_x = @scale*@x
  #   size_y = @scale*@y
    # g.drawImage(@upper, cx-ix, cy+iy-240, 640, 480, 0 , 0 , 640, 480)



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

