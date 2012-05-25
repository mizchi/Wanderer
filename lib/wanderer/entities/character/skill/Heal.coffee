Skill = require './Skill'
class Heal extends Skill
  constructor: () ->
    @CT = 3
    super arguments[0],arguments[1]
    @name = "Heal"
    @range = 0
    @auto= false
    @bg_charge = 0.5
    @fg_charge =  1

  exec:()->
    target = @actor
    if @ct >= @CT
      target.status.hp += 30
      @ct = 0
      console.log "do healing"
module.exports = Heal
