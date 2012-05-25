require 'sugar'
Object.extend()
mock = require('./mock')

dump_map = (stage)->
  cmap = stage.map.cmap.clone()

  for i in stage.monsters
    cmap[i.x][i.y] = 'g'+i.group_id

  for k,i of stage.players
    cmap[i.x][i.y] = 'p'+i.group_id

  console.log 'show map'
  for arr , i in cmap
    console.log (arr.map (m)->
      if m is 1 then return '##'
      else if m is 0 then return '  '
      else 
        return m
    ).join('')
    # for n , j in arr


describe 'DungeonTest',->
  # dungeon = null
  char = null
  it '初期化',->
    Dungeon = require './../server/stage/Dungeon'
    dungeon = new Dungeon
    char = mock.get_char(dungeon)
    char.stage = dungeon

  it 'Player追加',->
    dungeon.join '3412341',char
    [char.x,char.y] = [15,15]

  it '規定値までモンスターをスポーン',->
    dungeon.max_spawn_count = 5
    dungeon.spawn_monster() for i in [1..30]
    dungeon.monsters.length.should.equal dungeon.max_spawn_count

  it '#update',->
    dump_map(dungeon)
    dungeon.update() for i in [1..100]
    dump_map(dungeon)
    for i in dungeon.monsters
      console.log """
      #{i.uid}(#{i.group_id}) watch #{i.recog.target?.uid}(#{i.recog.target?.group_id}) #{i.recog.target?.get_distance(i)}/#{i.recog.sight_range} #{i.hp/i.HP}
      """
