Skill = require './../server/character/skill/Skill'

Atack = require './../server/character/skill/Atack'


describe 'SkillTest',->
  describe 'モデルの初期化',->
    skill = null
    # before ->
    # after ->

    it '初期化',->
      skill = new Skill
      new Atack
    it '初期CTは0',->
      skill.ct.should.equal 0
    

