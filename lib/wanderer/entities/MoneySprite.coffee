ItemSprite = require './Sprite'
class MoneySprite extends ItemObject
  constructor:(x,y)->
    super(x,y)
    @amount = randint(0,100)
  event : (objs,map, player)->
    GameData.gold += @amount
    console.log "You got #{@amount}G / #{GameData.gold} "
module.exports = MoneySprite
