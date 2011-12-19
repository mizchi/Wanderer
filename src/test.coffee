vows = require 'vows'
assert = require 'assert'

keys =
   left : 0
   right : 0
   up : 0
   down : 0
mouse =
  x : 320
  y : 240

p = console.log

vows.describe('Game Test').addBatch
  Item:
    topic: new ItemBox
    'get item':(t)->
      t.add_item new Dagger
      t.add_item new Blade
      console.log t.serialize()
  Equip:
    topic:
      player : new Player null,100,100,ObjectGroup.Player
      goblin:new Goblin null,100,100,ObjectGroup.Enemy
    'Set Status':(topic)->
      p = topic.player
      g = topic.goblin
      p.equip new Blade
      p.equip new SmallShield
      p.equip new ClothArmor
      g.equip new Dagger

  Combat:
    topic:
      player:new Player null,100,100,ObjectGroup.Player
      goblin:new Goblin null,100,100,ObjectGroup.Enemy
      map : new SampleMap()
    # 'Attack until Dead':(topic)->
    #   player = topic.player
    #   goblin = topic.goblin
    #   m = topic.map
    #   # while player.is_alive() and goblin.is_alive()
    #   player.update([player,goblin],m,keys,mouse)
    #   goblin.update([player,goblin],m)
    #   assert.isTrue( player.is_dead() or goblin.is_dead())

    # 'Exec Attack Skill':(topic)->
    #   player = topic.player
    #   goblin = topic.goblin
    #   m = topic.map
    #   while player.is_alive() and goblin.is_alive()
    #     player.update([player,goblin],m,keys,mouse)
    #     goblin.update([player,goblin],m)
    #   player.targeting_obj = goblin
    #   player.selected_skill = new Skill_Atack(player,4)
    #   player.selected_skill.exec(player,[goblin])
    #   assert.isTrue( goblin.status.MAX_HP > goblin.status.hp )
    #   assert.isTrue( player.selected_skill.lv is 4 )

  #   'TargetChange':(topic)->
  #     goblin2 = new Goblin 100,100,ObjectGroup.Enemy
  #     goblin2.name += 2
  #     objs = [topic.player,topic.goblin,goblin2]
  #     i.update(objs,topic.map,keys,mouse) for i in objs

  #     before = topic.player.targeting_obj.name
  #     topic.player.shift_target [topic.goblin,goblin2]
  #     after = topic.player.targeting_obj.name
  #     topic.player.shift_target [topic.goblin,goblin2]
  #     after2 = topic.player.targeting_obj.name
  #     assert.isTrue before isnt after
  #     assert.isTrue before is after2

  #   'Equiptment':(topic)->
  #     player = topic.player
  #     player._equips_ =
  #       main_hand: new Blade
  #       sub_hand: new SmallShield
  #       body: new ClothArmor
  #     player.equip new Blade

  #   ' - Use Skill':
  #     topic : (parent)->
  #       parent.player.targeting_obj = parent.goblin
  #       return {
  #         player : parent.player
  #         gen_targets :()->
  #           new Goblin parent.player.x,parent.player.y,ObjectGroup.get_against(parent.player) for _ in [1..3]
  #       }
  #     'Atack':(topic)->
  #       topic.player.selected_skill = new Skill_Atack topic.player
  #       topic.player.selected_skill.exec topic.gen_targets()
  #     'Meteor':(topic)->
  #       topic.player.selected_skill = new Skill_Meteor topic.player
  #       topic.player.selected_skill.exec topic.gen_targets()
  #     'Smash':(topic)->
  #       topic.player.selected_skill = new Skill_Smash topic.player
  #       topic.player.selected_skill.exec topic.gen_targets()


.export module


