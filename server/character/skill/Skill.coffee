require 'sugar'
{ObjectId} = require './../../shared/data/ObjectId'
{abs,random,sin,cos} = Math

straight_hit = (map,fx,fy,tx,ty)->
  while abs(tx-fx) + abs(ty-fy) >0
    if fx>tx then fx--
    else if fx<tx then fx++
    else if fy>ty then fy--
    else if fy<ty then fy++
    return false if map[fx][fy] > 0
  true

class Skill
  constructor: (@actor,@lv=1) ->
    @CT *= 15
    @ct = 0

  charge:(is_selected)->
    if @ct < @CT
      if is_selected
        @ct += @fg_charge
      else
        @ct += @bg_charge

  update: (objs,keys)->
    # for name,skill of @actor.skills
    #   skill.charge skill is @
    @exec objs

  toData : ->
    name: @name
    lv: @lv

  exec:(objs)->
  _calc:(target)-> return 1
  _get_targets:(objs)-> return []

  is_hit : (map,fx,fy,tx,ty)->
    #brezenham
    fx = ~~fx
    fy = ~~fy
    tx = ~~tx
    ty = ~~ty

    # 直線の場合
    if ty is fy or ty is fy
      return straight map,fx,fy,tx,ty
    # 必ずスタート地点を左側に
    if tx < fx
      [tx,ty,fx,fy] = [fx,fy,tx,ty]
    a = (ty-fy)/(tx-fy)
    # x軸のほうが距離がある場合
    if a<1
      while tx > fx
        fx++
        fy+= a
        if fy%1 >0.5
          return false if map[fx][~~(fy+1)]
        else
          return false if map[fx][~~(fy)]
    # y軸のほうが距離がある場合
    else
      a = 1/a
      while ty > fy
        fx+=a
        fy+=1
        if fx%1 >0.5
          return false if map[~~fx+1][fy]
        else
          return false if map[~~fx][fy]
    true
module.exports = Skill