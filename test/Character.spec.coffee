ClassData = require('./../shared/data/Class.json')
RaceData = require('./../shared/data/Race.json')

char_model = 
  name: 'nanashi'
  racial_name: 'Dwarf'
  class_name: 'Lord'
  lv: 1
  base_status: 
    str: 13
    int: 8
    dex: 10
  learned: 
    WeaponMastery: 1
    Atack: 1
    Heal: 1
    Lightning: 0 
  skillset: [ 'Atack', 'Heal' ]

Character = null

describe 'CharacterTest',->
  char = null
  context = {}
  class_data = ClassData[char_model.class_name]

  it "初期化",->
    Map = require './../server/map/Map'
    Character = require './../server/character/Character'

    char = new Character {map:new Map} ,char_model

  it 'HP = クラスのHP比率 * (STR*1.5+DEX*1.0+INT*0.5)',->
    char.HP.should.equal ~~(
      class_data.spec.HP_RATE*(
        char_model.base_status.str*1.5+
        char_model.base_status.dex*1.0+
        char_model.base_status.int*0.5))
  
  it 'MP = クラスのHP比率 * (STR*0.5+DEX*1.0+INT*1.5)',->
    char.MP.should.equal ~~(
      class_data.spec.MP_RATE*(
        char_model.base_status.str*0.5+
        char_model.base_status.dex*1.0+
        char_model.base_status.int*1.5))

  it 'str = STR+装備の補正',->
    char.status.str.should.equal char_model.base_status.str

  it '生存or死亡',->
    char.is_alive().should.equal true
    char.hp = 0 
    char.is_dead().should.equal true

  it '初期スキルは0番目のAtack',->
    char.selected_skill.name.should.equal 'Atack'

  describe '影響フェイズ - 状態に応じた状態変化の影響を受ける',->
    # it '選択スキルをチャージする'
    # it 'ヘイスト状態ならチャージ量が増える'
    # it '毒状態なら毒の影響を受ける'
    # it 'スタン状態ならチャージしない'

  describe '認識フェイズ - 状況から認識モデルを作る',->
    # it 'recog',->
    # it '自分しか存在しない状態を認識する',->
    #   char.recognize([char])

  describe '行動フェイズ - 認識モデルに応じて行動を起こす',->
    it 'action',->
      char.action()
