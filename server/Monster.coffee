{random,sqrt,min,max,sin,cos} = Math

{Character} = require './Character'
{Status} = require './Status'
{Equipment} = require './Equipment'
{SkillBox} = require './skills'

RacialData = require('./shared/data/Race')
ClassData = require('./shared/data/Class')

{Weapons} = require('./equip')

#TODO : Equip Autogeneration

class Monster extends Character 
  constructor : (@class ,@race,equipment) ->
    @set_pos()
    @dir = 0
    # @id = ObjectId.Monster

    racial_status = RacialData[@race]
    class_data = ClassData[@class]
    sum = 0
    console.log @class
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

class Goblin extends Monster
  name : "Goblin"
  constructor: (@scene ,@lv, @group) ->
    @per_rate = 3 # 成長率 小さいほど強い プレーヤが 3
    @exp_rate = 1.0 # lvに応じた成長率

    super 'Norvice','goblin',
      main_hand : 
        name : 'dagger'
        drate : 0.7

    @status.trace_range = 13
    @selected_skill = @skills.sets[1]

  select_skill: ()->
    return @selected_skill = @skills.sets[1]

class HoundDog extends Monster
  name : "HoundDog"
  constructor: (@scene ,@lv, @group) ->
    @per_rate = 3 # 成長率 小さいほど強い プレーヤが 3
    @exp_rate = 1.0 # lvに応じた成長率

    super 'Norvice','hound_dog',{}

    @status.trace_range = 17

  select_skill: ()->
    return @selected_skill = @skills.sets[1]
    # if @status.hp < 5

exports.HoundDog = HoundDog
exports.Goblin = Goblin