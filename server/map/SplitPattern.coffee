dig = (map,fx,fy,tx,ty)->
  while abs(tx-fx) + abs(ty-fy) >0
    if fx>tx then fx--
    else if fx<tx then fx++
    else if fy>ty then fy--
    else if fy<ty then fy++
    map[fx][fy] = 0

# 初期化
blank = (x,y)->
  ( (1 for m in [1..y]) for n in [1..x] )
  
class SplitPattern
  cmap : null
  seeds : null
  constructor:(@prev,@depth, @ax,@ay)->
    @c = []
    if @depth > 0
      @split()
    else
      cx = ~~((@ax[0]+@ax[1])/2)
      cy = ~~((@ay[0]+@ay[1])/2)
      @draw_area()
      @seeds.push [cx,cy]

    max_size = 25
    min_size = 7
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

    [sx,ex] = @rx
    [sy,ey] = @ry

  _v : ->
    [sx , ex] = @ax
    cx = ~~((sx+ex)/2)
    @c = [
      new SplitPattern @,--@depth, [sx,cx],@ay
      new SplitPattern @,--@depth, [cx,ex],@ay
    ]
  _s : ->
    [sy , ey] = @ay
    cy = ~~((sy+ey)/2)
    @c = [
      new SplitPattern @,--@depth, @ax , [sy,cy]
      new SplitPattern @,--@depth, @ax , [cy,ey]
    ]

  split:->
    svrate = (@ax[1]-@ax[0]) / (@ay[1]-@ay[0])
    # 分割時に縦横比率が0.25~4 に収まるように調整
    if svrate > 4
      @_v()
    else if svrate < 0.25
      @_s()
    # 収まってる時はランダムに分割する
    else if Math.random() > 0.5
      @_s()
    else
      @_v()

  draw_area : ->
    [sx,ex] = @ax
    [sy,ey] = @ay

    for i in [sx ... ex]
      for j in [sy ... ey]
        if (i == sx or i == (ex-1) ) or (j == sy or j == (ey-1))
          @cmap[i][j] = 1
        else
          @cmap[i][j] = 0
          
module.exports = SplitPattern
