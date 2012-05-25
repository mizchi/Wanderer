Model = require "./Model"
Character = require './../character/Character'

nstore = require 'nstore'
# db = nstore.new("../savedata/char.db")
db = nstore.new("character.db")

ClassData = require('./../shared/data/Class.json')
RaceData = require('./../shared/data/Race.json')

proxy = {}
class CharacterModel extends Model
  _init_ : 
    name : String
    racial_name : String
    class_name : String
    lv : Number
    base_status : 
      str : Number
      int : Number
      dex : Number
    learned: {}
    skillset:[]

  _ignore_: 
    proxy: ""

 
  constructor:(params)->
    super params
    @build(params)

  build : (params)->
    #base_statusが未定義ならば初期化する
    return @create_new(params) unless params.base_status
    @base_status = params.base_status 

  create_new : (params)->
    @lv = params.lv or 1

    @base_status = {}
    (@base_status[i] = ClassData[@class_name].init_bonus[i]+
      RaceData[@racial_name].init_bonus[i]) for i in ['str','int','dex']
    @learned = ClassData[@class_name].learned
    @skillset = ClassData[@class_name].skillset

  @getCharacterInstance: (name, cb)->
    if proxy[name]?
      cb(proxy[name])
    else 
      db.get name,(e,doc)->
        throw e if e
        proxy[name] = new Character(null,doc)
        cb proxy[name]

  @save:(ins,cb)->
    unless ins instanceof CharacterModel
      throw 'ClassError'
    db.save ins.name, ins.toJson() , (e,doc)->
      cb(false)

  @remove:(ins)->
    unless ins instanceof CharacterModel
      throw 'arg is not ClassError'
    db.remove ins.name,->
      console.log ins.name , " remove done!"

  level_up: ()->
    @lv++
    @exp = 0
    @sp++
    @bp++ if @lv%3 is 0 
    @next_lv = @lv * 50
    @rebuild()
    @on_status_change()

  get_exp:(point)->
    @exp += point
    if @exp >= @next_lv
      @level_up()
      console.log 'level up! to lv.'+@lv

  set_next_exp:()->
    @next_lv = @lv * 30

  use_battle_point:(at)->
    if @bp>0 and at in ["str","int","dex"]
      @bp--
      @[at] +=1
      @rebuild()

      @on_status_change()
      true
    else
      null
    
module.exports = CharacterModel