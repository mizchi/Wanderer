SingleHit = require './SingleHit'
"""
あとで実装をSmashスキルと分離
"""
class KnockbackHit extends SingleHit
  constructor: ->
    @CT = 2
    super arguments[0],arguments[1]
    @name = "Smash"
    @range = 3
    @damage_rate = 2.2
    @random_rate = 0.5
    @bg_charge = 0.5
    @fg_charge = 1

  affect : (target)->
    map = @actor.scene._map
    rx = target.x - @actor.x
    ry = target.y - @actor.y
    if rx >= 0
      rad = Math.atan( ry / rx  )
    else
      rad = Math.PI - Math.atan( ry / - rx  )

    kd = 3
    nx = target.x + kd*cos(rad)
    ny = target.y + kd*sin(rad)
    if 0<= nx < map.length and 0<= ny < map[0].length
      if !@actor.scene._map[~~(nx)][~~(ny)]
        console.log 'knockback!'
        target.x = nx
        target.y = ny

    return ~~(@actor.status.atk * target.status.def*@damage_rate*randint(100*(1-@random_rate),100*(1+@random_rate))/100)

module.exports = KnockbackHit