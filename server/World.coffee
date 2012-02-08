class World
  constructor: (conf,max_depth,io,db) ->
    @stages = []

    for area_name in ['Dungeon']
      Stage = require("./stage/#{area_name}")
      @stages[area_name] = new Stage

    @cnt = 0
    @active = true
    @fps = 15

  enter: ->
    @cnt++
    for floor , stage of @stages
      ps = (v for _,v of stage.players)
      stage.update() if ps.length > 0

  start: () ->
    console.log("GameEngine started...")
    @active = true
    mainloop = =>
      @enter()
      @ws()
      if @active
        setTimeout mainloop
        , 1000/@fps
    mainloop()

  stop :->
    console.log 'Game stopped'
    @active = false

module.exports = World
