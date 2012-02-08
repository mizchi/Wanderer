{random,sqrt,min,max,sin,cos} = Math
require 'sugar'
Object.extend()

Character = require './Character'

RacialData = require('./../shared/data/Race')
ClassData = require('./../shared/data/Class')

class Monster extends Character 
  constructor : (@stage,params) ->
    clsd = ClassData[params.class_name]
    raced = RacialData[params.racial_name]

    params.base_status = {}
    (params.base_status[i] = clsd.init_bonus[i]+raced.init_bonus[i])  for i in ['str','int','dex']
    @_build_status(params.base_status,params.lv)
    super @stage,params

  _build_status:(status,lv)->
    sum = status.values().sum()
    for i in ['str','int','dex']
      rate = status[i]/sum 
      status[i] += ~~(rate*lv*@potencial)

  __:->
    @set_pos()

    racial_status = RacialData[@race]
    class_data = ClassData[@class]
    sum = 0
    for i in ['str','int','dex']
      racial_status[i] += class_data.status[i]
      sum += racial_status[i]

    # 初期ステータスの比率に応じて成長率を設定
    for i in ['str','int','dex']
      racial_status[i] += ~~(@lv*racial_status[i]/sum/@per_rate)

    racial_status.lv = @lv
    @status = new Status racial_status
    super(@scene ,@x,@y,@group,@status)

    @skills = new SkillBox @,class_data.learned,class_data.preset
    @equipment = new Equipment equipment
    @selected_skill = @skills.sets[1]

  die : (actor)->
    super actor
    @drop_item(actor) if actor

  drop_item : (actor)->
module.exports = Monster


# class Goblin extends Monster
#   name : "Goblin"
#   constructor: (@scene ,@lv, @group) ->
#     @per_rate = 3 # 成長率 小さいほど強い プレーヤが 3
#     @exp_rate = 1.0 # lvに応じた成長率

#     super 'Norvice','goblin',
#       main_hand : 
#         name : 'dagger'
#         drate : 0.7

#     @status.trace_range = 13
#     @selected_skill = @skills.sets[1]

#   select_skill: ()->
#     return @selected_skill = @skills.sets[1]

# class HoundDog extends Monster
#   name : "HoundDog"
#   constructor: (@scene ,@lv, @group) ->
#     @per_rate = 3 # 成長率 小さいほど強い プレーヤが 3
#     @exp_rate = 1.0 # lvに応じた成長率

#     super 'Norvice','hound_dog',{}

#     @status.trace_range = 17

#   select_skill: ()->
#     return @selected_skill = @skills.sets[1]
#     # if @status.hp < 5

# exports.HoundDog = HoundDog
# exports.Goblin = Goblin