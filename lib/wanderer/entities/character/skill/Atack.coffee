SingleHit = require './SingleHit'
class Atack extends SingleHit
  constructor: () ->
    @CT = 1
    super arguments[0],arguments[1]
    @name = "Atack"
    @range = 3
    @auto =  true
    @bg_charge = 0
    @fg_charge = 1
    @damage_rate = 1.0
    @random_rate = 0.2

  can_exec : ()->
    t = @actor.recog.target
    if !!t and @is_full()
      if (t.hp > 0 and @actor.get_distance(t) <@range)
        return true
    return false

  _calc : (target)->
    damage = ~~(@actor.status.str * @_calc_rate(target,'slash'))
    ~~(damage*@damage_rate*@_get_random())
module.exports = Atack
