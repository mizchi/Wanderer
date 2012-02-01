vows = require 'vows'
assert = require 'assert'

ClassData = require('./../shared/data/Class.json')
RaceData = require('./../shared/data/Race.json')

CharacterModel = require('./../server/model/CharacterModel')

mock_status = 
  racial_name : 'Dwarf'
  class_name : 'Lord'
  lv : 1


describe 'CharacterModelTest',->

  char_model = null
  char_ins = null
  context = {}

  it '初期化', ->
    char_model =  new CharacterModel mock_status
    char_model.name = 'nanashi'

  # after ->
  #   CharacterModel.remove(char_model)

  it 'CharacterModel.name = nanashi',->
    char_model.toJson().name.should.equal 'nanashi'

  it "モデルを保存",(done)->
    CharacterModel.save char_model,(e)->
      throw 'save failed' if e
      done()

  it '初期ステータス = クラスボーナス+ジョブボーナス',->
    char_model.base_status.str.should.equal(
      ClassData[mock_status.class_name].init_bonus.str+RaceData[mock_status.racial_name].init_bonus.str
      )
    char_model.base_status.int.should.equal(
      ClassData[mock_status.class_name].init_bonus.int+RaceData[mock_status.racial_name].init_bonus.int
      )

    char_model.base_status.dex.should.equal(
      ClassData[mock_status.class_name].init_bonus.dex+RaceData[mock_status.racial_name].init_bonus.dex
      )
    char_model.toJson().base_status.should.have.property 'int'

  it '初期スキルはClass.learnedに依存',->
    char_model.learned['Atack'].should.equal(1)
    char_model.toJson().learned['Atack'].should.equal(1)

  it '初期選択スキルはクラス依存 ',->
    char_model.skillset[0].should.equal 'Atack'

