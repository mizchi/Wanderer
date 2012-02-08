World = require './../server/World'

describe 'WorldTest',->
  world = null
  it "初期化",->
    world = new World

  it "1000フレーム持続",->
    world.enter() while world.cnt > 1000