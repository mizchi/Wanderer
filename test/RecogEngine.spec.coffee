mock = require './mock'

describe 'RecogEngine',->
  recog = null
  char = null
  map = null
  stage = null
  c1 = c2 = c3 = c4 = null


  it '初期化',->
    RecogEngine = require './../server/character/RecogEngine'
    char = mock.get_char()
    char.group_id = 0
    recog = new RecogEngine char
    c1 = mock.get_char()
    c1.group_id = 0

    c2 = mock.get_char()
    c2.group_id = 1
    [ c2.x,c2.y ] = [1,1]

    c3 = mock.get_char()
    c3.group_id = 1
    [ c3.x,c3.y ] = [2,2]

    c4 = mock.get_char()
    c4.group_id = 1
    [ c4.x,c4.y ] = [100,100]

    recog.stage = 
      players : {self:char, p1: c1}
      monsters :[c2,c3,c4]

  it '周辺を探索し候補を探索する',->
    recog.search_around()
    recog.near.length.should.equal 3

  it '候補から敵を返す',->
    recog.get_enemies().length.should.equal 2

  it '候補から味方を返す',->
    recog.get_allies().length.should.equal 1

  it '候補からターゲットを返す',->
    t = recog.get_target()
    t.uid.should.equal c2.uid

  it 'ターゲットが視界にいる場合、引き続きターゲットを更新する',->
    recog.target = c3
    recog.search_around()
    t = recog.get_target() 
    t.uid.should.equal c3.uid

  it '視界からターゲットが逃れた場合、最も近いターゲットを設定する',->
    recog.target = c4
    recog.search_around()
    t = recog.get_target() 
    t.uid.should.equal c2.uid
