Monster = require './../server/character/Monster'
Goblin = require './../server/character/monster/Goblin'

char = 
  racial_name: 'Dwarf'
  class_name: 'Lord'
  lv: 1

  learned: 
    WeaponMastery: 1
    Atack: 1
    Heal: 1
    Lightning: 0 

  skillset: [ 'Atack', 'Heal' ]

describe 'MonsterTest',->
  monster = null

  it '#init',->
    monster = new Goblin {map:null}

  it '#build_by lv',->
    monster = new Goblin null,15
    console.log monster.status