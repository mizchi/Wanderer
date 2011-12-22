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
    g.moveTo 0,32
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
