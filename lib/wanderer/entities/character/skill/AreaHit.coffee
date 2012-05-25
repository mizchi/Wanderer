DamageHit = require './DamageHit'
class AreaHit extends DamageHit
  effect : 'Burn'
  _get_targets:(objs)->
    return @actor.find_obj ObjectId.get_enemy(@actor), objs , @range

  _calc : (target)->
    return ~~(@actor.status.atk * target.status.def*@damage_rate*randint(100*(1-@random_rate),100*(1+@random_rate))/100)

module.exports = AreaHit