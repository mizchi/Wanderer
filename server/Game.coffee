{RandomStage} = require('./stages/sample')

class GameCore
  constructor: (conf,max_depth,io,db) ->
    @stages = []
    @stages[i] = new RandomStage(@,i,io.of('/f'+i),db) for i in [0...max_depth]

    @cnt = 0
    @active = true
    @fps = 15

  login : (name,to)->


  enter: ->
    @cnt++
    for floor , stage of @stages
      ps = (v for _,v of stage.players)
      if ps.length > 0
        stage.update()

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

  ws :->

exports.GameCore = GameCore
