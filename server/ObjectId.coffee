ObjectId =
  Player : 0
  Enemy  : 1
  Item   : 2
  is_battler : (oid)->
    oid in [@Player, @Enemy]
  get_enemy : (obj)->
    switch obj.group
      when @Player
        return @Enemy
      when @Enemy
        return @Player

GroupId = 
  Player : 0
  Enemy  : 1
  Item   : 2
  is_battler : (oid)->
    oid in [@Player, @Enemy]
  get_enemy : (obj)->
    switch obj.group
      when @Player
        return @Enemy
      when @Enemy
        return @Player

exports.ObjectId = ObjectId
exports.GroupId = GroupId

