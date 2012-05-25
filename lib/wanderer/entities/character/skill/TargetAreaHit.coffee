DamageHit = require './DamageHit'
class TargetAreaHit extends DamageHit
  effect : 'Burn'
  _get_targets:(objs)->
    if @actor.target
      if @actor.get_distance(@actor.targeting_obj) < @range
        return @actor.targeting_obj.find_obj ObjectId.get_enemy(@actor), objs , @range
    []
  _calc : (target)->
    return ~~(@actor.status.atk * target.status.def*@damage_rate*randint(100*(1-@random_rate),100*(1+@random_rate))/100)

  exec:(objs)->
    res = super objs
    # if res
    #   @actor.targeting_obj.add_animation new Anim.prototype[@effect] null, @range*1.5

module.exports = TargetAreaHit