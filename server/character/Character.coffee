# manual backup
# Skills = require './skill/skills'
# Skill = require('./skill/skills')
# {ItemBox} = require './ItemBox'
require 'sugar'
# Object.extend()
# 
Sprite = require('./../sprite/Sprite')

ClassData = require('./../shared/data/Class.json')
RaceData = require('./../shared/data/Race.json')

{ObjectId} = require './../shared/data/ObjectId'

{random,sqrt,min,max,sin,cos} = Math

# class RecogEngine
#   constructor:(@actor)->
#   guess :->
#   get_skill:->
#   get_target:->
#   get_distination:->


class Character extends Sprite
  constructor: (@context , model) ->
    # @_load params
    @build(model)

    @x = 0 
    @y = 0
    @dir = 0
    @target = null
    @uid = Number.random(0,1000)
    @cnt = Number.random(0,60)

    @animation = []
    @_path = []

  """  ビルド系メソッド

  build
    modelクラスから渡された変数からステータスを作る

  build_by_initial_rate 
    lvに応じて自動的に

  _merge 
    複数のステータス群から任意のステータスを足し合わせるヘルパ関数

  """
  build: (model)->
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
    @status.str = model.base_status.str*1.0
    @skillset = []
    for sk_name,i in model.skillset 
      S = require("./skill/#{sk_name}")
      @skillset[i] = new S(@)
    @selected_skill = @skillset[0]

  build_by_initial_rate:->
    # 初期ステータスの比率に応じて成長率を設定
    sum = 0
    for i in ['str','int','dex']
      racial_status[i] += class_data.status[i]
      sum += racial_status[i]

    for i in ['str','int','dex']
      racial_status[i] += ~~(@lv*racial_status[i]/sum/@per_rate)

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


  """  update系メソッド

  #affected 
    状態を更新

  #recognize 
    状態を認識

  #action
    認識状態に応じて行動

  """

  update:(objs)->
    @cnt++
    if @is_alive()
      @affected()
      @recognize(objs)
      @action()


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
    for s in @skillset
      s.charge(s is @selected_skill)
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

  """
  #search
    周囲を探索し、ターゲット候補を搾り出す

  #shift_target
    ターゲット候補の中から次のターゲットに移る
  """

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

    @_path = @scene.search_path( from ,to )
    @_path = @_path.map (i)=> @scene.get_point i[0],i[1]
    @to = @_path.shift()

  is_waiting : ()->
    if @target
      @set_dir(@target.x,@target.y)
      return true if @get_distance(@target) < @selected_skill.range
    else if @group isnt ObjectId.Player
      return true if @cnt%60 < 15
    return false

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
  onHealed : (amount)->
  die : (actor)->
    @cnt = 0
    actor.status.gold += ~~(random()*100)
    actor.status.get_exp(@status.lv*10)
    console.log "#{@name} is killed by #{actor.name}." if actor
  add_damage : (actor, amount)->
    before = @is_alive()
    @status.hp -= amount
    unless @target
      if @get_distance(actor) < @status.trace_range
        @target = actor
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