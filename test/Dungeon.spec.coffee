require 'sugar'
Object.extend()
mock = require('./mock')

describe 'DungeonTest',->
  dungeon = null
  char = null
  it '初期化',->
    Dungeon = require './../server/stage/Dungeon'
    dungeon = new Dungeon
    char = mock.get_char(dungeon)
    char.stage = dungeon

  it 'Player追加',->
    dungeon.join '3412341',char

  it '規定値までモンスターをスポーン',->
    # while dungeon.monsters.length < dungeon.max_spawn_count
    dungeon.spawn_monster() for i in [1..1000]
    dungeon.monsters.length.should.equal dungeon.max_spawn_count

  it '#update',->
    dungeon.update()
  


