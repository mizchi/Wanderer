{ObjectId} = require './ObjectId'
{randint} = require './Util'
{abs,random,sin,cos} = Math
_u = require 'underscore'

straight = (map,fx,fy,tx,ty)->
  while abs(tx-fx) + abs(ty-fy) >0
    if fx>tx then fx--
    else if fx<tx then fx++
    else if fy>ty then fy--
    else if fy<ty then fy++
    return false if map[fx][fy] > 0
  true

brezenham_hit = (map,fx,fy,tx,ty)->
  fx = ~~fx
  fy = ~~fy
  tx = ~~tx
  ty = ~~ty

  # 直線の場合
  if ty is fy or ty is fy
    return straight map,fx,fy,tx,ty
  # 必ずスタート地点を左側に
  if tx < fx
    [tx,ty,fx,fy] = [fx,fy,tx,ty] 
  a = (ty-fy)/(tx-fy)
  # x軸のほうが距離がある場合
  if a<1
    while tx > fx
      fx++
      fy+= a  
      if fy%1 >0.5
        return false if map[fx][~~(fy+1)]
      else 
        return false if map[fx][~~(fy)]
  # y軸のほうが距離がある場合
  else 
    a = 1/a
    while ty > fy
      fx+=a
      fy+=1  
      if fx%1 >0.5
        return false if map[~~fx+1][fy]
      else 
        return false if map[~~fx][fy]
  true

class Skill
  constructor: (@actor,@lv=1) ->
    @CT *= 15
    @ct = 0

  charge:(is_selected)->
    if @ct < @CT
      if is_selected
        @ct += @fg_charge
      else
        @ct += @bg_charge

  update: (objs,keys)->
    # for name,skill of @actor.skills
    #   skill.charge skill is @
    @exec objs

  toData : ->
    name: @name
    lv: @lv

  exec:(objs)->
  _calc:(target)-> return 1
  _get_targets:(objs)-> return []

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
    # console.log @actor.name+":"+@name+":"+@ct/@MAX_CT
    if @ct >= @CT and targets.length > 0
      for t in targets
        amount = @_calc t
        t.add_damage(@actor,amount)
        @affect(t)
        # t.add_animation new Anim.prototype[@effect] amount
      @ct = 0
      return true
    return false

class SingleHit extends DamageHit
  effect : 'Slash'
  _get_targets:(objs)->
    if @actor.target
      if @actor.get_distance(@actor.target) < @range
        return [ @actor.target ]
    return []

  _calc : (target)->
    damage = ~~(@actor.status.str * @_calc_rate(target,'slash'))
    ~~(damage*@damage_rate*@_get_random())

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

class AreaHit extends DamageHit
  effect : 'Burn'
  _get_targets:(objs)->
    return @actor.find_obj ObjectId.get_enemy(@actor), objs , @range
  _calc : (target)->
    return ~~(@actor.status.atk * target.status.def*@damage_rate*randint(100*(1-@random_rate),100*(1+@random_rate))/100)

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

  _calc : (target)->
    damage = ~~(@actor.status.str * @_calc_rate(target,'slash'))
    ~~(damage*@damage_rate*@_get_random())


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


class Smash extends SingleHit
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

class Heal extends Skill
  constructor: () ->
    @CT = 3
    super arguments[0],arguments[1]
    @name = "Heal"
    @range = 0
    @auto= false
    @bg_charge = 0.5
    @fg_charge =  1

  exec:()->
    target = @actor
    if @ct >= @CT
      target.status.hp += 30
      @ct = 0
      console.log "do healing"

class ThrowBomb extends Skill
  name : "Throw Bomb"
  range : 12
  auto: true
  BCT : 4
  bg_charge : 0.5
  fg_charge : 1
  constructor: (@lv=1) ->
    super(@lv)
    @range = 120
    @effect_range = 30

  exec:(objs,mouse)->
    if @ct >= @CT
      targets = mouse.find_obj(ObjectId.get_enemy(@actor), objs ,@range)
      if targets.size()>0
        for t in targets
          t.status.hp -= 20
        @ct = 0

exports.Atack = Atack
exports.Heal = Heal
exports.Smash = Smash
exports.Meteor = Meteor
exports.Lightning = Lightning

class SkillBox
  constructor:(@actor , @learned={},@preset={})->
    @sets = #(i:null for i in [1..9])
      1:null
      2:null
      3:null
      4:null
      5:null
      6:null
      7:null
      8:null
    @build(@preset)

  set_key : (key,skill_name)->
    lv = @learned[skill_name] or 0
    if exports[skill_name] and not (_u.any @sets,(k,v)-> v.name is skill_name) and @learned[skill_name] > 0
      @sets[key] = new exports[skill_name](@actor,lv)
      @preset[key] = skill_name 

  build : (preset)->
    for key,skill_name of preset
      @set_key key, skill_name

  use_skill_point:(sname)->
    if @actor.status.sp>0 and @learned[sname]?
      @learned[sname] +=1
      @actor.status.sp--
      @build()
      true
    else
      false

  toData:->
    learned : @learned
    preset : @preset

exports.SkillBox = SkillBox
