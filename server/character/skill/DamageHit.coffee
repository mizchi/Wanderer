Skill = require './Skill'
class DamageHit extends Skill
  range : 1
  auto: true
  BCT : 1
  bg_charge : 0.2
  fg_charge : 1
  damage_rate : 1.0
  random_rate : 0.2
  effect : 'Slash'

  _calc_rate:(target,e)->
    1
    # @actor.get_param("a_#{e}") * (1-target.get_param("r_#{e}"))

  _get_random:()->
    randint(100*(1-@random_rate),100*(1+@random_rate))/100

  affect :(target)->

  exec:(objs)->
    targets = @_get_targets(objs)
    if @ct >= @CT and targets.length > 0
      for t in targets
        amount = @_calc t
        t.add_damage(@actor,amount)
        @affect(t)
        # t.add_animation new Anim.prototype[@effect] amount
      @ct = 0
      return true
    return false
    
module.exports = DamageHit