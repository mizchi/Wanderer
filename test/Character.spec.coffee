vows = require 'vows'
assert = require 'assert'
Character = require './../server/character/Character'
# {ObjectId} = require('./../server/ObjectId')

ClassData = require('./../shared/data/Class.json')
RaceData = require('./../shared/data/Race.json')

# path.chdir './../server'
CharacterModel = require('./../server/model/CharacterModel')


mock_status = 
  racial_name : 'Dwarf'
  class_name : 'Lord'
  lv : 1

# saved_status = 
#   Race : 'Human'
#   Class : 'Lord'
#   lv : 1
#   oid : ObjectId.Player

#   status:
#     str: 0
#     int: 0
#     dex: 0

#   learned: 
#     Smash : ''

"""
  基本方針
  素のステータス+装備情報でアクティブステータスを構築
  Characterクラスはアクティブステータスの情報のみを持つ
  レベルアップ時にDBを呼び出してステータス再構築

"""


describe 'CharacterTest',->
  describe 'モデルの初期化',->
    char_model = null
    char_ins = null
    context = {}

    before ->
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

    describe 'インスタンスの初期化',->
      char_ins = null
      it "モデルからインスタンスを呼び出し",(done)->
        CharacterModel.getCharacterInstance 'nanashi',(ins)->
          char_ins = ins
          done() 

      it 'HP = クラスのHP比率 * (STR*1.5+DEX*1.0+INT*0.5)',->
        char_ins.status.HP.should.equal ~~(
          ClassData[mock_status.class_name].spec.HP_RATE*(
            char_model.base_status.str*1.5+
            char_model.base_status.dex*1.0+
            char_model.base_status.int*0.5))
      
      it 'MP = クラスのHP比率 * (STR*0.5+DEX*1.0+INT*1.5)',->
        char_ins.status.MP.should.equal ~~(
          ClassData[mock_status.class_name].spec.MP_RATE*(
            char_model.base_status.str*0.5+
            char_model.base_status.dex*1.0+
            char_model.base_status.int*1.5))

      it 'str = STR+装備の補正',->
        char_ins.status.str.should.equal char_model.base_status.str

      # it 'int = int*1.0',->
      #   char_ins.status.str.should.equal char_model.base_status.str

      it '初期スキルは0番目のAtack',->
        char_ins.skillset[0].name.should.equal 'Atack'
        char_ins.selected_skill.name.should.equal 'Atack'

      # describe 'スキル',->
      #   char = char_ins
      #   before ->

      #   it "スキルを設定",(done)->
      #     CharacterModel.getCharacterInstance 'nanashi',(ins)->
          
    

    # describe 'モデルの更新',(done)->
    #   b_str = char_model.base_status.str  
    #   CharacterModel.add_point(char_ins,str:1)
    #   CharacterModel.getCharacterInstance char_model.name,(ins)->
    #     char_ins = ins
    #     b_str.should.equal a_str-1
    #     done()
      # a_str = char_model.base_status.str  



  # describe 'アクション',->
  #   char1 = null
  #   char2 = null
  #   before ->
  #     char1 =  new Character null, mock_status
  #     char1.x = 0
  #     char1.y = 0
  #     char2 =  new Character null, mock_status
  #     char2.x = 0.5
  #     char2.y = 0.5

  #   it 'AからBに攻撃する',->
  #     char1.selected_skill = new Atack char1
  #     char1.target = char2
  #     while not char1.can_exec()
  #       char1.charge()
  #     char1.exec()
