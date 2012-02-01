# manual backup
# {Weapons} = require('./equip')
# {ObjectId} = require('./ObjectId')
# {randint} = require('./Util')
# {SkillBox} = require './skill/skills'
# Skills = require './skill/skills'
# Skill = require('./skill/skills')
# {ItemBox} = require './ItemBox'

require 'sugar'
{Sprite} = require('./../sprite/Sprite')
ClassData = require('./../shared/data/Class.json')
RaceData = require('./../shared/data/Race.json')

{random,sqrt,min,max,sin,cos} = Math

class Character extends Sprite
  constructor: (@context , model) ->
    # @_load params
    @build(model)

    @x = 0 
    @y = 0
    @dir = 0
    @target = null
    @uid = ~~(random() * 1000)
    @cnt = ~~(random() * 60)

    # @items = new ItemBox
    @animation = []
    @_path = []

  build: (model)->
    @status = {}
    for i in ["str","int","dex"]
      @status[i] = model.base_status[i]

    @status.hp = @status.HP = ~~(
      ClassData[model.class_name].spec.HP_RATE*(
        @status.str*1.5+
        @status.dex*1.0+
        @status.int*0.5
      ))

    @status.mp = @status.MP = ~~(ClassData[model.class_name].spec.MP_RATE*(
        @status.str*0.5+
        @status.dex*1.0+
        @status.int*1.5
      ))
    @status.str = model.base_status.str*1.0
    @skillset = []
    for sk_name,i in model.skillset 
      S = require("./skill/#{sk_name}")
      @skillset[i] = new S(@)
    @selected_skill = @skillset[0]


  _merge : (obj1,obj2)->
    ret = {}
    for k,v of obj1
      ret[k] = v

    for k,v of obj2
      if ret[k]?
        ret[k] += v
      else 
        ret[k] = v
    return ret

  update:(objs)->
    @cnt++
    if @is_alive()
      @affected()
      target = @recognize(objs)
      @action(target)

  charge:()->
    @check(@status)


  # 状態をチェックし、更新する
  affected:()->
    @check(@status)
    @regenerate() if @cnt%30 == 0

  # 周囲の状態を認識・評価
  recognize: (objs)->
    @search objs
    @select_skill()
    return objs

  # アクションを行う
  action:(target)->
    @move()
    for i in [1..9]
      @skills.sets[i].charge(false) if @skills.sets[i]
    @selected_skill.charge(true) #update(target)
    @selected_skill.exec(target) #update(target)


  # affected
  check:(st)->
    st.hp = st.HP if st.hp > st.HP
    st.hp = 0 if st.hp < 0
    if @is_alive()
      if @target?.is_dead()
         @target = null
    else
      @target = null

  regenerate: ()->
    r = (if @target then 2 else 1)
    if @status.hp < @status.HP
      @status.hp += 1

  # recognize
  search : (objs)->
    range = (if @target then @status.trace_range else @status.active_range)
    enemies = @find_obj(ObjectId.get_enemy(@),objs,range)
    if @target
      if @target.is_dead() or @get_distance(@target) > @status.trace_range
        console.log "#{@name} lost track of #{@target.name}"
        @target = null
    else if enemies.length is 1
      @target = enemies[0]
      console.log "#{@name} find #{@target.name}"
    else if enemies.length > 1
      enemies.sort (a,b)=>
        @get_distance(a) - @get_distance(b)
      @target = enemies[0]
      console.log "#{@name} find #{@target.name}"

  select_skill: ()->
    @selected_skill = new Skill.Atack(@)

  onHealed : (amount)->

  update_path : (fp ,tp )->
    [fx ,fy] = fp
    from = [~~(fx),~~(fy)]
    [tx ,ty] = tp
    to = [~~(tx),~~(ty)]

    @_path = @scene.search_path( from ,to )
    @_path = @_path.map (i)=> @scene.get_point i[0],i[1]
    @to = @_path.shift()

  wander : ()->
    [tx,ty] = @scene.get_point(@x,@y)
    @to = [tx+randint(-1,1),ty+randint(-1,1)]

  step_forward: (to_x , to_y, wide)->
    @set_dir(to_x,to_y)
    [
      @x + wide * cos(@dir)
      @y + wide * sin(@dir)
    ]

  onDamaged : (amount)->

  is_waiting : ()->
    if @target
      @set_dir(@target.x,@target.y)
      return true if @get_distance(@target) < @selected_skill.range
    else if @group isnt ObjectId.Player
      return true if @cnt%60 < 15
    return false

  move: ()->
    if @_on_going_destination
      if @target
        @set_dir(@target.x,@target.y)
        return if @get_distance(@target) < @selected_skill.range
    else
      return if @is_waiting()

    if @destination
      @update_path( [~~(@x),~~(@y)],[~~(@destination.x),~~(@destination.y)] )
      @to = @_path.shift()
      @destination = null
      @_on_going_destination = true

    unless @to
      # 優先度 destination(人為設定) > target(ターゲット) > follow(リーダー)
      if @target
        @update_path( [~~(@x),~~(@y)],[~~(@target.x),~~(@target.y)] )
      else if @follow
        @update_path( [~~(@x),~~(@y)],[~~(@follow.x),~~(@follow.y)] )
      else
        @wander()

    else
      wide = @status.speed
      [dx,dy] = @to
      [nx,ny] = @step_forward( dx , dy ,wide)
      if dx-wide<nx<dx+wide and dy-wide<ny<dy+wide
        if @_path.length > 0
          @to = @_path.shift()
        else
          @to = null
          @_on_going_detination = false

    # 衝突判定
    unless @scene.collide( nx,ny )
      @x = nx if nx?
      @y = ny if ny?

    # 引っかかってる場合
    if @x is @_lx_ and @y is @_ly_
      @wander()
    @_lx_ = @x
    @_ly_ = @y

  die : (actor)->
    @cnt = 0
    actor.status.gold += ~~(random()*100)
    actor.status.get_exp(@status.lv*10)
    console.log "#{@name} is killed by #{actor.name}." if actor

  shift_target:(targets)->
    if @target and targets.length > 0
      if not @target in targets
        @target = targets[0]
        return
      else if targets.length == 1
        @target = targets[0]
        return
      if targets.length > 1
        cur = targets.indexOf @target
        if cur+1 >= targets.length
          cur = 0
        else
          cur += 1
        @target = targets[cur]


  equip_item : (item)->
    if item.at in (k for k,v of @equipment)
      @equipment[item.at] = item
    false

  get_item:(item)->
    null
    # @items.push(item)

  use_item:(item)->
    # @items.remove(item)

  get_param:(param)->
    0
    # (item?[param] or 0 for at,item of @equipment).reduce (x,y)-> x+y


  add_damage : (actor, amount)->
    before = @is_alive()
    @status.hp -= amount
    unless @target
      if @get_distance(actor) < @status.trace_range
        @target = actor
    @die(actor) if @is_dead() and before
    return @is_alive()

  is_alive:()-> @hp > 1
  is_dead:()-> ! @is_alive()

  set_pos : (@x=0,@y=0)->
  set_dir: (x,y)->
    rx = x - @x
    ry = y - @y
    if rx >= 0
      @dir = Math.atan( ry / rx  )
    else
      @dir = Math.PI - Math.atan( ry / - rx  )

  add_animation:(animation)->
    @animation.push(animation)

  toData :()->
    obj = 
      name  : @name
      pass  : @pass
      skills: @skills.toData()
      status: @status.toData()
      equipment : @equipment.toData() 
      items : @items.toData()

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

module.exports = Character