# {pow,sqrt,abs,random,max,min} = Math
# {ObjectId} = require('./ObjectId')
# {Sprite,MoneyObject} = require('./sprites')

class Stage
  constructor: (@world) ->
    @players = {}
    @cnt = 0
    @connections = []

  update : ->
    @cnt++

  join : (id,player)->
    player.id = id
    @players[id] = player

  leave : (id)->
    delete @players[id].id
    delete @players[id]

  # create_map : (x,y,depth)->
  #   Room::cmap = blank(x,y)
  #   Room::hmap = blank(x,y)
  #   Room::search_path = @search_path
  #   root = new Room(null, depth ,[1,x-1],[1,y-1])
  #   root.draw_path()
  #   root

  # create_tworoom : (x,y,depth)->
  #   TwoRoom::cmap = blank(x,y)
  #   TwoRoom::hmap = blank(x,y)
  #   TwoRoom::seeds = []
  #   TwoRoom::search_path = @search_path
  #   root = new TwoRoom(null, depth ,[1,x-1],[1,y-1])

  #   # 最短ノードのネットワークを作成する
  #   seeds = TwoRoom::seeds
  #   to = seeds.shift() 
  #   path =[to]
  #   while seeds.length > 1
  #     [fx,fy] = to
  #     seeds = _u.reject seeds, (i)->
  #       _u.isEqual i,to
  #     to = null
  #     min_cost = pow(x,2) + pow(y,2)

  #     for [tx,ty] in seeds
  #       cost = pow(tx-fx,2) + pow(ty-fy,2)
  #       if cost < min_cost 
  #         min_cost = cost
  #         to = [tx,ty]
  #     path.push to

  #   # ノード間を中折れ一回でつなげる
  #   [fx,fy] = path.shift()
  #   while path.length > 0
  #     [nx,ny] = path.shift()
  #     [cx,cy] = [
  #       ~~((fx+nx)/2),
  #       ~~((fy+ny)/2) ]

  #     if abs(fx-nx) > abs(fy-ny)
  #       dig root.cmap , fx,fy,cx,fy
  #       dig root.cmap , cx,fy,cx,ny
  #       dig root.cmap , cx,ny,nx,ny
  #     else 
  #       dig root.cmap , fx,fy,fx,cy
  #       dig root.cmap , fx,cy,nx,cy
  #       dig root.cmap , nx,cy,nx,ny

  #     [fx,fy] = [nx,ny]
  #   root

module.exports = Stage