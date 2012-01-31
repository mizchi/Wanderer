{pow,sqrt,abs,random,max,min} = Math
{ObjectId} = require('./ObjectId')
{Sprite,MoneyObject} = require('./sprites')
# require './Util'
_u = require 'underscore'

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
  
# 部屋を2つずつに分割していくパターン
# 部屋のサイズが綺麗に調整できる

class TwoRoom
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
      new TwoRoom @,--@depth, [sx,cx],@ay
      new TwoRoom @,--@depth, [cx,ex],@ay
    ]
  _s : ->
    [sy , ey] = @ay
    cy = ~~((sy+ey)/2)
    @c = [
      new TwoRoom @,--@depth, @ax , [sy,cy]
      new TwoRoom @,--@depth, @ax , [cy,ey]
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



# Room 親子関係で道をつないでいくパターン
class Room
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

class StageLoader 
  constructor: () ->
    super 0, 0
    @_map = blank(30,30,1) #@load(maps.debug)


  _rotate90:(map)->
    res = []
    for i in [0...map[0].length]
      res[i] = ( j[i] for j in map)
    res

  _set_wall:(map)->
    x = map.length
    y = map[0].length
    map[0] = (1 for i in [0...map[0].length])
    map[map.length-1] = (1 for i in [0...map[0].length])
    for i in map
      i[0]=1
      i[i.length-1]=1
    map

  load : (text)->
    tmap = text.replaceAll(".","0").replaceAll(" ","1").split("\n")
    max = Math.max.apply null,(row.length for row in tmap)
    map = []
    for y in [0...tmap.length]
      map[y]= ((if i < tmap[y].length then parseInt tmap[y][i] else 1) for i in [0 ... max])

    map = @_rotate90(map)
    map = @_set_wall(map)
    return map

class Stage extends Sprite
  constructor: () ->
    super 0, 0
    @_map = blank(30,30) #@load(maps.debug)


  get_point: (x,y)->
    return [~~(x)+1/2,~~(y)+1/2]

  get_random_point: ()->
    rx = ~~(Math.random()*@_map.length)
    ry = ~~(Math.random()*@_map[0].length)
    if @_map[rx][ry]
      return @get_random_point()
    return [rx+1/2,ry+1/2]

  collide: (x,y)->
    return @_map[~~(x)][~~(y)]


  find:(arr,pos)->
    for i in arr
      if i.pos[0] == pos[0] and i.pos[1] == pos[1]
        return i
    return null

  search_path: (start,goal,depth=50)->
    class Node
      start: start
      goal: goal
      constructor:(@pos)->
        @owner_list  = null
        @parent = null
        @hs     = pow(pos[0]-@goal[0],2)+pow(pos[1]-@goal[1],2)
        @fs     = 0

    search_path =[
      [-1,-1], [ 0,-1], [ 1,-1]
      [-1, 0]         , [ 1, 0]
      [-1, 1], [ 0, 1], [ 1, 1]
    ]

    path = []
    open_list = []
    close_list = []
    start_node = new Node(Node::start)
    start_node.fs = start_node.hs
    open_list.push(start_node)


    for _ in [1..depth]
      return [] if open_list.length < 1 #探索失敗

      # ゴールまでの直線距離順にソート
      open_list.sort (a,b)->a.fs-b.fs
      min_node = open_list[0] # 最小ノードを選択
      close_list.push open_list.shift()
      [ mx ,my ] = min_node.pos

      # 到着
      if mx is min_node.goal[0] and my is min_node.goal[1]
        path = []
        n = min_node
        # 親を辿る
        path.push(n.pos) while n = n.parent
        return path.reverse()

      n_gs = min_node.fs - min_node.hs

      for [x,y] in search_path
        # 斜めの判定が可能か
        if abs(x)+abs(y) > 1
          unless !@_map[x+mx][my] and !@_map[mx][y+my]
            continue

        [nx,ny] = [x+mx,y+my]
        unless @_map[nx][ny]
          dist = pow(mx-nx,2) + pow(my-ny,2)

          if obj = @find(open_list,[nx,ny])
            if obj.fs > n_gs+obj.hs+dist
              obj.fs = n_gs+obj.hs+dist
              obj.parent = min_node
          else if obj = @find(close_list,[nx,ny])
            if obj.fs > n_gs+obj.hs+dist
                obj.fs = n_gs+obj.hs+dist
                obj.parent = min_node
                open_list.push(obj)
                # close_list.remove(obj)
                close_list.splice( close_list.indexOf(obj) , 1)
          else
            n = new Node([nx,ny])
            n.fs = n_gs+n.hs+dist
            n.parent = min_node
            open_list.push(n)
    return []

  create_map : (x,y,depth)->
    Room::cmap = blank(x,y)
    Room::hmap = blank(x,y)
    Room::search_path = @search_path
    root = new Room(null, depth ,[1,x-1],[1,y-1])
    root.draw_path()
    root
    

  create_tworoom : (x,y,depth)->
    TwoRoom::cmap = blank(x,y)
    TwoRoom::hmap = blank(x,y)
    TwoRoom::seeds = []
    TwoRoom::search_path = @search_path
    root = new TwoRoom(null, depth ,[1,x-1],[1,y-1])

    # 最短ノードのネットワークを作成する
    seeds = TwoRoom::seeds
    to = seeds.shift() 
    path =[to]
    while seeds.length > 1
      [fx,fy] = to
      seeds = _u.reject seeds, (i)->
        _u.isEqual i,to
      to = null
      min_cost = pow(x,2) + pow(y,2)

      for [tx,ty] in seeds
        cost = pow(tx-fx,2) + pow(ty-fy,2)
        if cost < min_cost 
          min_cost = cost
          to = [tx,ty]
      path.push to

    # ノード間を中折れ一回でつなげる
    [fx,fy] = path.shift()
    while path.length > 0
      [nx,ny] = path.shift()
      [cx,cy] = [
        ~~((fx+nx)/2),
        ~~((fy+ny)/2) ]

      if abs(fx-nx) > abs(fy-ny)
        dig root.cmap , fx,fy,cx,fy
        dig root.cmap , cx,fy,cx,ny
        dig root.cmap , cx,ny,nx,ny
      else 
        dig root.cmap , fx,fy,fx,cy
        dig root.cmap , fx,cy,nx,cy
        dig root.cmap , nx,cy,nx,ny

      [fx,fy] = [nx,ny]
    root

exports.Stage = Stage