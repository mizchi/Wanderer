Monster = require './../Monster'

class Goblin extends Monster
  constructor : (stage,lv=1,@potencial=0.4) ->
    params = 
      name: 'Goblin'
      lv : lv
      racial_name: 'Goblin'
      class_name: 'Norvice'
      learned : {Atack:1}
      skillset : ['Atack']
    super(stage , params)


module.exports = Goblin