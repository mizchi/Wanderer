DamageHit = require './DamageHit'
class SingleHit extends DamageHit
  effect : 'Slash'
  _get_targets:()->
    if @actor.target()
      if @actor.get_distance(@actor.target()) < @range
        return [ @actor.target()]
    return []

  _calc : (target)->
    damage = ~~(@actor.status.str * @_calc_rate(target,'slash'))
    ~~(damage*@damage_rate*@_get_random())
    
module.exports = DamageHit