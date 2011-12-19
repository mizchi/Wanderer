vows = require 'vows'
assert = require 'assert'
# nstore = require('nstore')
{ Stage }  = require './src/stage'

vows.describe('GameTest').addBatch
  StageGenerator:
    topic: new Stage
    init_and_kill:(stage)->
      map = stage.create_tworoom 45,90,4
      {cmap,hmap} = map
      n = cmap.length 
      m = cmap[0].length 
      # canvas = ((0 for __ in [0...m]) for _ in [0...n])

      # for i in [0...n]
      #   for j in [0...m]
      #     if cmap[i][j] is 0
      #       canvas[i][j] = hmap[i][j]
      #     else 
      #       canvas[i][j] = -1

      # for i in canvas
      #   console.log i.join('')
      #     .split('-1').join('/')

      for i in cmap
        console.log i.join('')
          .split('0').join(' ')
          .split('1').join('/')

      # console.log i.join '' for i in canvas

  # Map:
  # Equip:
  #   topic:
  #     player : new Player null,100,100,ObjectGroup.Player
  #     goblin:new Goblin null,100,100,ObjectGroup.Enemy
  #   'Set Status':(topic)->
  #     p = topic.player
  #     g = topic.goblin
  #     p.equip new Blade
  #     p.equip new SmallShield
  #     p.equip new ClothArmor
  #     g.equip new Dagger

.export module


