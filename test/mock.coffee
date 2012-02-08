Character = require './../server/character/Character'
Map = require './../server/map/Map'

exports.get_char = (stage=null)->
  new Character stage, {
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
  }

exports.get_map = ->
  char = exports.get_char()
  new Map 
