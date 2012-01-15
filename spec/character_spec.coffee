vows = require 'vows'
assert = require 'assert'
Character = require './../server/Character'
{ObjectId} = require('./../server/ObjectId')

ClassData = require('./../shared/data/Class.json')
RaceData = require('./../shared/data/Race.json')

mock_status = 
  Race : 'Dwarf'
  Class : 'Lord'
  lv : 2

saved_status = 
  Race : 'Human'
  Class : 'Lord'
  lv : 1
  oid : ObjectId.Player
  x : 0
  y : 0

  status:
    str: 0
    int: 0
    dex: 0

  learned: 
    Smash : ''

vows.describe('CharacterTest').addBatch
  'create character':
    topic: new Character null, mock_status
    # topic: Character::create null, mock_status
    'build status':
      '初期ステータス = クラスボーナス+ジョブボーナス  ':(topic)->
        assert.equal topic.status.str,ClassData[mock_status.Class].init_bonus.str+RaceData[mock_status.Race].init_bonus.str

      'HP = クラスのHP比率 * (STR*1.5+DEX*1.0+INT*0.5)':(topic)->
        assert.equal topic.HP, ~~(ClassData[mock_status.Class].spec.HP_RATE*(topic.status.str*1.5+topic.status.dex*1.0+topic.status.int*0.5))
        assert.notEqual topic.HP, 0 

      'MP = クラスのHP比率 * (STR*0.5+DEX*1.0+INT*1.5)':(topic)->
        assert.equal topic.MP, ~~(ClassData[mock_status.Class].spec.MP_RATE*(topic.status.str*0.5+topic.status.dex*1.0+topic.status.int*1.5))
        assert.notEqual topic.HP, 0 
      'teardown':(topic)->
        console.log topic

    'living or dead':(char)->
      assert.equal char.is_alive() , true
      char.hp = 0
      assert.equal char.is_dead() , true


.export module
console.log '====', new Date