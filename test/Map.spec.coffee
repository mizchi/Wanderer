require 'sugar'
Object.extend()

Map = require './../server/map/Map'

describe 'MapTest',->
  map = null

  it "初期化",->
    map = new Map

  it "デフォルトマップの隅は壁",->
    map.cmap[0][0].should.equal 1 
    map.cmap[29][29].should.equal 1

  it "デフォルトマップの壁はハイト1 床は0",->
    map.hmap[0][0].should.equal 1 
    map.hmap[15][15].should.equal 0

  it "update",->
    map.update()
    map.cnt.should.equal 1

  describe "#search_path",->
    it "[5,5] to [6,6]",->
      path = map.search_path [5,5],[6,6]
      path.length.should.equal 1

    it "[5,5] to [8,8]",->
      path = map.search_path [5,5],[8,8]
      path.length.should.equal 3



