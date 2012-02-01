Character = require './../server/character/Character'

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


describe 'CharacterTest',->
  char = null
  context = {}
  class_data = ClassData[char_model.class_name]

  it "初期化",->
    char = new Character null ,char_model

  it 'HP = クラスのHP比率 * (STR*1.5+DEX*1.0+INT*0.5)',->
    char.status.HP.should.equal ~~(
      class_data.spec.HP_RATE*(
        char_model.base_status.str*1.5+
        char_model.base_status.dex*1.0+
        char_model.base_status.int*0.5))
  
  it 'MP = クラスのHP比率 * (STR*0.5+DEX*1.0+INT*1.5)',->
    char.status.MP.should.equal ~~(
      class_data.spec.MP_RATE*(
        char_model.base_status.str*0.5+
        char_model.base_status.dex*1.0+
        char_model.base_status.int*1.5))

  it 'str = STR+装備の補正',->
    char.status.str.should.equal char_model.base_status.str


  it '初期スキルは0番目のAtack',->
    char.skillset[0].name.should.equal 'Atack'
    char.selected_skill.name.should.equal 'Atack'