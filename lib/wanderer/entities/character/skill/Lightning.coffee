Lightning = require './ChainHit'
class Lightning extends ChainHit
  constructor: () ->
    @CT = 2
    super arguments[0],arguments[1]
    @name = "Lightning"
    @range = 12
    @auto =  true
    @bg_charge = 0
    @fg_charge = 1
    @damage_rate = 1.0
    @random_rate = 0.2

  _calc : (target)->
    damage = ~~(@actor.status.int * @_calc_rate(target,'slash'))
    ~~(damage*@damage_rate*@_get_random())
module.exports = Lightning
