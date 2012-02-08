Skill = require './../server/character/skill/Skill'

Atack = require './../server/character/skill/Atack'

Character = require('./../server/character/Character')

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


describe 'SkillTest',->
  describe 'Atack',->
    atack = null

    char = new Character null, char_model

    it '初期化',->
      atack = new Atack null
      char.selected_skill = atack

    it '初期CTは0',->
      atack.ct.should.equal 0

    it '選択スキルとしてチャージする',->
      atack.charge(true)
      atack.ct.should.equal atack.fg_charge

    it '非選択スキルとしてチャージする',->
      atack.ct = 0
      atack.charge(false)
      atack.ct.should.equal atack.bg_charge

    it '限界までチャージする',->
      atack.charge(true) for _ in [1..500]
      atack.get_charge_rate().should.equal 1

    it '敵がいないので発動できない',->
      atack.actor = char
      atack.can_exec().should.equal false

    it '敵が死んでいるので発動できない',->
      atack.actor.recog.target = new Character null,char_model
      atack.actor.recog.target.is_alive().should.equal true
      atack.actor.update()
      atack.actor.recog.target.hp = 0 
      atack.actor.recog.target.is_dead().should.equal false
      atack.can_exec().should.equal false

    it '敵が遠く発動できない',->
      atack.actor.recog.target.x = 10
      atack.actor.recog.target.y = 10
      atack.can_exec().should.equal false

    it 'ターゲットが近くにいてチャージされている',->
      atack.actor.recog.target.x = 0
      atack.actor.recog.target.y = 0
      atack.actor.x = 0
      atack.actor.y = 0
      atack.can_exec().should.equal true


    

