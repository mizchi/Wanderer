# Room 親子関係で道をつないでいくパターン
class RoomPattern
  cmap : null
  hmap : null
  constructor:(@prev, @depth, @ax,@ay)->
    if @ax[1] > @cmap.length 
      console.log @ax 

    if @ay[1] > @cmap[0].length 
      console.log @ay
    @height = ~~(random()*10)
    @max_size = 4
    @next = null
    if @depth > 0
      @next = @split()

    max_size = 99
    r = ~~(max_size/2)
    if @ax[1]-@ax[0] < max_size
      @rx = @ax
    else
      cx = ~~((@ax[0]+@ax[1])/2)
      @rx = [cx-r, cx+r]
    if @ay[1]-@ay[0] < 13
      @ry = @ay
    else
      cy = ~~((@ay[0]+@ay[1])/2)
      @ry = [cy-r, cy+r]

    @center = [
      ~~((@rx[1]+@rx[0])/2)
      ~~((@ry[1]+@ry[0])/2)
    ]

    @draw_area()

  _v : ->
    [sx,ex] = @ax
    cx = ~~((ex-sx)*(1-random()/@depth)+sx)
    @ax = [cx,ex]
    @next = new Room @ , --@depth, [sx,cx ],@ay

  _s : ->
    [sy , ey] = @ay
    cy = ~~( (ey-sy)*(1-random()/@depth)+sy  )
    @ay = [cy,ey]
    @next = new Room @, --@depth, @ax , [sy,cy]

  split:->
    if Math.random() > 0.5
      @_s()
    else
      @_v()

  draw_area : ->
    [sx,ex] = @rx
    [sy,ey] = @ry
    for i in [sx ... ex]
      for j in [sy ... ey]
        if (i == sx or i == (ex-1) ) or (j == sy or j == (ey-1))
          @cmap[i][j] = 1
        else
          @cmap[i][j] = 0
          @hmap[i][j] = @height

  draw_path : ->
    if @next
      [cx,cy] = @center
      [nx,ny] = @next.center
      while abs(cx-nx)+abs(cy-ny) > 0
        if cx>nx then cx--
        else if cx<nx then cx++
        else if cy>ny then cy--
        else if cy<ny then cy++
        @cmap[cx][cy] = 0
      @next.draw_path()

module.exports = RoomPattern
