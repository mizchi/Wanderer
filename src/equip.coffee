class Item
class EquipItem extends Item
  weight : 1
  a_slash : 0
  a_thrust : 0
  a_blow : 0
  a_fire : 0
  a_flost : 0
  a_magic : 0
  a_thunder : 0
  a_holy : 0
  a_darkness : 0
  r_slash : 0
  r_thrust : 0
  r_blow : 0
  r_fire : 0
  r_flost : 0
  r_magic : 0
  r_thunder : 0
  r_holy : 0
  r_darkness : 0



class Weapon extends EquipItem
  type : 'weapon'

class Armor extends EquipItem
  type : 'armor'

(Weapons={}).prototype =
  Dagger : class Dagger extends Weapon
    name : 'Dagger'
    at : "main_hand"
    a_slash:0.7
    weight : 0.2

  Blade : class Blade extends Weapon
    name : 'Blade'
    at : "main_hand"
    a_slash : 1.1
    weight : 2.9

  SmallShield : class SmallShield extends Weapon
    name : 'SmallShiled'
    at : "sub_hand"
    r_slash : 0.1

  ClothArmor : class ClothArmor extends Armor
    name : 'ClothArmor'
    at : "body"
    r_slash : 0.2

class UseItem extends Item
  type : 'use'
  effect : (actor)->


class ItemBox
  items : []
  serialize : ()->
    buf = []
    for i in @items
      buf.push for [k,v] in ([k,v] for k,v of i)
    if localStorage?
      localStorage.set JSON.stringify buf
    else
      @_storage_ = JSON.stringify buf

  load : (str)->
    console.log eval @_storage_

  add_item : (item)->

    @items.push item

  remove_item : (item)->
    @items.remove item

exports.Weapon = Weapon
exports.Weapons = Weapons
exports.Armor = Armor
exports.ItemBox = ItemBox

