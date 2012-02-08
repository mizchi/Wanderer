Sprite = require './Sprite'
class HealSprite extends ItemObject
  event : (objs,map , keys ,mouse,player)->
    player.hp += 30
    player.check()
module.exports = HealSprite
