Model = require('model') if require

class Character extends Model
  _iparam_ : 
    name : 'test'
    race : 'human'
    owner : null
    class: 'Warrior'
    
    data : 
      lv : 1
      exp : 0
      next_exp : 100
      sp : 0
      bp : 0
      gold : 0

    pos : 
      floor : 1
      x : 0
      y : 0

    status : 
      hp : 100
      HP : 100
      mp : 100
      MP : 100

    equip : 
      primary_hand: null
      off_hand : null

    skills : 
      preset : 
        1 : 'atack'
      learned : 
        atack : 
          lv:1
          spec : [1,0,0]

    items : [
      {
        name: "health potion"
        type: 'consume' 
        stack : 1
      }
    ]
module?.exports = Character