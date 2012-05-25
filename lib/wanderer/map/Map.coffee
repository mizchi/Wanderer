require 'sugar'
Object.extend()

class Map 

  constructor: (@stage)->
    @cmap = []
    @hmap = []
    @gen_map()
    @cnt = 0 

  update : ->
    @cnt++

  gen_map:->
    for i in [0...30]
      @cmap[i] = []
      @hmap[i] = []
      for j in [0...30]
        if i is 0 or j is 0 or i is 29 or j is 29
          @cmap[i][j] = 1
          @hmap[i][j] = 1
        else 
          @cmap[i][j] = 0
          @hmap[i][j] = 0

  get_point: (x,y)->
    return [~~(x),~~(y)]

  get_random_point: ()->
    rx = Number.random 0 ,@cmap.length
    ry = Number.random 0, @cmap[0].length
    if @_map[rx][ry]
      return @get_random_point()
    return [rx,ry]

  collide: (x,y)->
    return @cmap[~~(x)][~~(y)]

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
        @hs     = (@pos[0]-@goal[0]).pow(2)+
          (@pos[1]-@goal[1]).pow(2)
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
        if x.abs()+y.abs() > 1
          unless !@cmap[x+mx][my] and !@cmap[mx][y+my]
            continue

        [nx,ny] = [x+mx,y+my]

        unless @cmap[nx]
          console.log 'DungeonTest#update'
          console.log @cmap[nx]


        unless @cmap[nx][ny]
          dist = (mx-nx).pow(2) + (my-ny).pow(2)

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

module.exports = Map