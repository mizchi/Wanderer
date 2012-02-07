require 'sugar'
Object.extend()

ClassData = require('./../shared/data/Class.json')
RaceData = require('./../shared/data/Race.json')

{ObjectId} = require './../shared/data/ObjectId'

{random,sqrt,min,max,sin,cos} = Math
Sprite = require('./../sprite/Sprite')

RecogEngine = require './RecogEngine' 
class Character extends Sprite
  constructor: (@stage , model) ->
    @map = @stage.map
    @build(model)

    @x = 0 
    @y = 0
    @dir = 0
    # @target = null

    @uid = Number.random(0,1000)
    @cnt = Number.random(0,60)

    @animation = []
    @recog = new RecogEngine @
    group_id = 0


  build: (model)->
    @lv = model.lv or 1
    @status = {}
    for i in ["str","int","dex"]
      @status[i] = model.base_status[i]

    @hp = @HP = ~~(
      ClassData[model.class_name].spec.HP_RATE*(
        @status.str*1.5+
        @status.dex*1.0+
        @status.int*0.5
      ))

    @mp = @MP = ~~(ClassData[model.class_name].spec.MP_RATE*(
        @status.str*0.5+
        @status.dex*1.0+
        @status.int*1.5
      ))

    @skillset = []
    for sk_name,i in model.skillset 
      S = require("./skill/#{sk_name}")
      @skillset[i] = new S(@)
    @selected_skill = @skillset[0]

  update:(objs)->
    @cnt++
    if @is_alive()
      @affected()
      @recog.guess()
      @action()

  # 状態をチェックし、更新する
  affected:()->
    @check(@status)
    @_regenerate() unless @cnt%15

  _regenerate:->
    r = (if @recog.target then 2 else 1)
    if @status.hp < @status.HP
      @status.hp += 1

  # 周囲の状態を認識・評価

  # アクションを行う
  action:()->
    @move()
    for s in @skillset
      s.charge(s is @selected_skill)
    if @selected_skill.can_exec()
      @selected_skill.exec()

  # affected
  check:(st)->
    st.hp = st.HP if st.hp > st.HP
    st.hp = 0 if st.hp < 0
    if @is_alive()
      if @recog.target?.is_dead()
         @recog.target = null
    else
      @recog.target = null


  move: ->
    if @_on_going_destination
      if @recog.target
        @set_dir(@recog.target.x,@recog.target.y)
        return if @get_distance(@recog.target) < @selected_skill.range
    else
      return if @is_waiting()

    if @destination
      @update_path( [~~(@x),~~(@y)],[~~(@destination.x),~~(@destination.y)] )
      @to = @_path.shift()
      @destination = null
      @_on_going_destination = true

    unless @to
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
    unless @stage.map.collide( nx,ny )
      @x = nx if nx?
      @y = ny if ny?

    # 引っかかってる場合
    if @x is @_lx_ and @y is @_ly_
      @wander()
    @_lx_ = @x
    @_ly_ = @y

  set_dir: (x,y)->
    rx = x - @x
    ry = y - @y
    if rx >= 0
      @dir = Math.atan( ry / rx  )
    else
      @dir = Math.PI - Math.atan( ry / - rx  )

  update_path : (fp ,tp )->
    [fx ,fy] = fp
    from = [~~(fx),~~(fy)]
    [tx ,ty] = tp
    to = [~~(tx),~~(ty)]

    @_path = @stage.map.search_path( from ,to )
    # @_path = @_path.map (i)=> @stage.get_point i[0],i[1]
    @to = @_path.shift()

  is_waiting : ()->
    t = @target()
    if t
      @set_dir(t.x,t.y)
      return true if @get_distance(t) < @selected_skill.range
    else if @group isnt ObjectId.Player
      return true if @cnt%60 < 15
    return false

  wander : ()->
    # [tx,ty] = @stage.get_point(@x,@y)
    # @to = [tx+randint(-1,1),ty+randint(-1,1)]

  step_forward: (to_x , to_y, wide)->
    @set_dir(to_x,to_y)
    [
      @x + wide * cos(@dir)
      @y + wide * sin(@dir)
    ]
  target:->@recog.target

  onDamaged : (amount)->

  onHealed : (amount)->

  die : (actor)->
    @cnt = 0
    actor.status.gold += ~~(random()*100)
    actor.status.get_exp(@status.lv*10)
  add_damage : (actor, amount)->
    before = @is_alive()
    @status.hp -= amount

    unless @recog.target
      if @get_distance(actor) < @status.trace_range
        @recog.target = actor
    @die(actor) if @is_dead() and before
    return @is_alive()
  is_alive:()-> @hp > 0
  is_dead:()-> ! @is_alive()

  equip : (item)->
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

  add_animation:(animation)->
    @animation.push(animation)


module.exports = Character