Array::remove = (obj)-> @splice(@indexOf(obj),1)
Array::size = ()-> @length
Array::first = ()-> @[0]
Array::last = ()-> @[@length-1]
Array::each = Array::forEach
{cos,sin,sqrt,abs} = Math

Color =
  Red : "rgb(255,0,0)"
  Blue : "rgb(0,0,255)"
  Green : "rgb(0,255,0)"
  White : "rgb(255,255,255)"
  Black : "rgb(0,0,0)"
  i : (r,g,b)->
    "rgb(#{r},#{g},#{b})"

#===== CanvasRenderingContext2D =====
Canvas = CanvasRenderingContext2D
Canvas::init = (color=Color.i(255,255,255),alpha=1)->
  @beginPath()
  @strokeStyle = color
  @fillStyle = color
  @globalAlpha = alpha

Canvas::initText = (size=10,font='Arial')->
  @font = "#{size}pt #{font}"

Canvas::drawLine = (x,y,dx,dy)->
  @moveTo x,y
  @lineTo x+dx,y+dy
  @stroke()
Canvas::drawPath = (fill,path)->
  [sx,sy] = path.shift()
  @moveTo sx,sy
  while path.size() > 0
    [px,py] = path.shift()
    @lineTo px,py
  @lineTo sx,sy
  if fill then @fill() else @stroke()

Canvas::drawDiffPath = (fill,path)->
  [sx,sy] = path.shift()
  @moveTo sx,sy
  [px,py] = [sx,sy]
  while path.size() > 0
    [dx,dy] = path.shift()
    [px,py] = [px+dx,py+dy]
    @lineTo px,py
  @lineTo sx,sy
  if fill then @fill() else @stroke()

Canvas::drawLine = (x,y,dx,dy)->
  @moveTo x,y
  @lineTo x+dx,y+dy
  @stroke()

Canvas::drawDLine = (x1,y1,x2,y2)->
  @moveTo x1,y1
  @lineTo x2,y2
  @stroke()

Canvas::drawArc = (fill , x,y,size,from=0, to=Math.PI*2,reverse=false)->
  @arc( x, y, size ,from ,to ,reverse)
  if fill then @fill() else @stroke()
#===== UtilClass =====
Util = {}
Util.prototype =
  extend : (obj, mixin) ->
    obj[name] = method for name, method of mixin
    obj

  include : (klass, mixin) ->
    Util::extend klass.prototype, mixin

  dup : (obj)->
    f = ()->
    f.prototype = obj
    new f
include = Util::include
