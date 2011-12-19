{ObjectId} = require('./ObjectId')
{Character} = require './Character'
{Status} = require './Status'
{Equipment} = require './Equipment'
{ItemBox} = require './ItemBox'

Skills = require './skills'
{SkillBox} = require './skills'

racial_data = require('./racialdata').RacialData
class_data = require('./classdata').ClassData
{random,sqrt,min,max,sin,cos} = Math

class Player extends Character
  # Controller Implement
  constructor: (@scene, data = {},@group=ObjectId.Player) ->
    @name = data.name
    @password = data.password
    @set_pos()
    super(@scene,@x,@y,@group)
    @status = new Status data.status
    @equipment = new Equipment data.equipment
    
    @skills = new SkillBox @, data.skills.learned, data.skills.preset

    @selected_skill = @skills.sets[1]
    @status.active_range = 4
    @status.trace_range = 4

  select_skill :()->
    for k,v of @keys
      if v and parseInt(k) in [1..5]
        if @skills.sets[k]
          return @selected_skill = @skills.sets[k]

  update:(objs)->
    enemies = @find_obj(ObjectId.get_enemy(@),objs,@status.active_range)

    if @keys.space is 1 and @_last_space_ is 0
      @shift_target(enemies)
    @_last_space_ = @keys.space

    range = @selected_skill.range
    @status.active_range = range
    @status.trace_range = range

    super objs,@scene

  set_destination:(x,y)->
    @target = x:x,y:y,is_dead:(->false),status:{get_param:->}

  wander : ->

  move: ->
    keys = @keys

    sum = 0
    for i in [keys.right , keys.left , keys.up , keys.down]
      sum++ if i

    if sum is 0
      if ++@_wait > 120
        return
      else
        super()
        return
    else if sum > 1
      move = @status.speed * 0.7
    else
      move = @status.speed
    @_on_going_destination = false
    @to = null
    @_wait = 0

    if keys.right
      if @scene.collide( @x+move , @y )
        @x = ~~(@x)+1-0.1
      else
        @x += move
    if keys.left
      if @scene.collide( @x-move , @y )
        @x = ~~(@x)+0.1
      else
        @x -= move
    if keys.down
      if @scene.collide( @x , @y-move )
        @y = ~~(@y)+0.1
      else
        @y -= move
    if keys.up
      if @scene.collide( @x , @y+move )
        @y = ~~(@y)+1-0.1
      else
        @y += move

exports.Player = Player

exports.create_new = (name,racial_name,cls_name)->
  #mock
  cls_data = class_data[cls_name]
  r = racial_data[racial_name]

  _status = 
    str : cls_data.status.str + r.str
    int : cls_data.status.int + r.int
    dex : cls_data.status.dex + r.dex

  status  = new Status _status
  status.race = racial_name
  # status.class = cls_name
  status.gold = 0
  status.exp = 0
  status.lv = 1
  status.sp = 3
  status.bp = 2

  equipment = new Equipment 
    main_hand : 'dagger'

  items = new ItemBox {}
  skills = new SkillBox p , cls_data.learned, cls_data.preset

  data = 
    name : name
    status : status.toData()
    equipment : equipment.toData()
    items : items.toData()
    skills: skills.toData()
  p = new Player null , data
  p.toData()
