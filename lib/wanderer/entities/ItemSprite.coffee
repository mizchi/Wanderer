Sprite = require './Sprite'
class ItemSprite extends Sprite
  size : 10
  is_alive:()->
    @event_in
  is_dead:()->
    not @is_alive()

  constructor: (@x=0,@y=0) ->
    @cnt = 0
    @group = ObjectId.Item
    @event_in = true

  update:(objs,map)->
    @cnt++
      # if @event_in
      #   @event(objs,map,camera)
      #   @event_in = false
      #   @cnt=0

  event : (objs,map)->
    console.log "you got item"
module.exports = ItemSprite
