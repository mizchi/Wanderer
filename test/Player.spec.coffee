ClassData = require('./../shared/data/Class.json')
RaceData = require('./../shared/data/Race.json')
Player = require './../server/character/Player'

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

describe 'PlayerTest',->
  it "初期化"
