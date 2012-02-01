DamageHit = require './DamageHit'

class ChainHit extends DamageHit
  effect : 'Slash'
  _get_targets:(objs)->
    depth = 1
    add = 1
    if @actor.target
      tar = []
      target = @actor.target
      map = @actor.scene._map
      if @actor.get_distance(@actor.target) < @range
        if brezenham_hit map, @actor.x,@actor.y,target.x,target.y
          tar.push (e = @actor.target )
          nobjs = e.find_obj(e.group,objs,@range/2)
          nobjs.splice nobjs.indexOf(e),1
          if nobjs.length is 0
            return tar
          if nobjs.length > 0
            tar.push nobjs[ ~~(nobjs.length*Math.random()) ]
            return tar
    return []

  _calc : (target)->
    damage = ~~(@actor.status.str * @_calc_rate(target,'slash'))
    ~~(damage*@damage_rate*@_get_random())

module.exports = ChainHit