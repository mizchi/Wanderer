require 'sugar'
Object.extend()
{ObjectId} = require './../../shared/data/ObjectId'

class RecogEngine
  constructor:(@actor)->
    @stage = @actor.stage 
    @target = null
    @near = []
    @objects = []
    @target_type = 0

    @sight_range = 8
    @active_range = 3

  guess :->
    @search_around()
    @get_target()

  get_skill:->
  get_distination:->

  get_target:->
    if @target
      if @actor.get_distance(@target) < @sight_range
        return @target
    @_enemies = @get_enemies()
    @_enemies.sort (a,b)=>
      @actor.get_distance(a)-@actor.get_distance(b)
    @target = @_enemies[0] or null

  get_enemies : ()->
    @near.filter (t)=>
      t.group_id isnt @actor.group_id and t.is_alive()

  get_allies : ()->
    @near.filter (t)=>
      t.group_id is @actor.group_id

  search_around : ()->
    chars = @stage.monsters.concat(@stage.players.values())
    @near = chars.filter (t)=>
      @actor.get_distance(t) < @sight_range and t isnt @actor

    # range = @actor.sight_range

    # targets.filter (t)=>
    #   t.group is group_id and @get_distance(t) < range

    # enemies = @find_obj(ObjectId.get_enemy(@),objs,range)
    # if @target
    #   if @target.is_dead() or @get_distance(@target) > @status.trace_range
    #     @target = null
    # else if enemies.length is 1
    #   @target = enemies[0]
    # else if enemies.length > 1
    #   enemies.sort (a,b)=>
    #     @get_distance(a) - @get_distance(b)
    #   @target = enemies[0]

module.exports = RecogEngine