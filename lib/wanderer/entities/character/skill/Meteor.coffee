class Meteor extends AreaHit
  constructor: () ->
    @CT = 4
    super arguments[0],arguments[1]
    @name = "Meteor"
    @range = 8
    @auto = true
    @damage_rate = 5
    @random_rate = 0.1

    @bg_charge = 0.5
    @fg_charge = 1
    @effect = 'Burn'

  _calc : (target)->
    return ~~(@actor.status.atk * target.status.def*@damage_rate*randint(100*(1-@random_rate),100*(1+@random_rate))/100)
module.exports = Meteor 
