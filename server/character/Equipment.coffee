class Equipment
  constructor:(data={})->
    @main_hand = data.main_hand or null
    @sub_hand = data.sub_hand or null
    @body = data.body or null
    @arm = data.arm or null
    @leg = data.leg or null
    @ring1 = data.ring1 or null
    @ring2 = data.ring2 or null

  toData : ->
    main_hand: @main_hand
    sub_hand : @sub_hand
    body : @body
    arm : @arm
    leg : @leg
    ring1 : @ring1
    ring2 : @ring2

exports.Equipment = Equipment