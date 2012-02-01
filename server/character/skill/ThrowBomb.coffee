TargetAreaHit = require './TargetAreaHit'
class ThrowBomb extends TargetAreaHit
  name : "Throw Bomb"
  range : 12
  auto: true
  BCT : 4
  bg_charge : 0.5
  fg_charge : 1
  constructor: (@lv=1) ->
    super(@lv)
    @range = 120
    @effect_range = 30

  exec:(objs,mouse)->
    if @ct >= @CT
      targets = mouse.find_obj(ObjectId.get_enemy(@actor), objs ,@range)
      if targets.size()>0
        for t in targets
          t.status.hp -= 20
        @ct = 0
module.exports = ThrowBomb
