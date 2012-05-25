# {ObjectId} = require('./ObjectId')
Character = require './Character'

{random,sqrt,min,max,sin,cos} = Math

# class PlayerRecogEngine extends RecogEngine
#   constructor:()->
#     super()

class Player extends Character
  constructor: (@stage, data = {}) ->
    super(@stage,data)
    @input = {}
    # @status.active_range = @selected_skill[0]

  get_key : (key,val)->
    @input[key] = val

  update:(objs)->
    @selected_skill = @recog.get_skill()
    @status.active_range = range
    @status.trace_range = range
    super()

  move: ->
    keys = @input

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

module.exports = Player