class Status
  constructor: (data = {}) ->
    @lv = data.lv or 1
    @exp = data.exp or 0
    @gold = data.gold or 10 

    @sp = data.sp or 0  
    @bp = data.bp or 0
    @class = data.class or null
    @race = data.race or null
    @str = data.str or 5
    @int = data.int or 5
    @dex = data.dex or 5

    @rebuild()

  rebuild:()->
    @HP = @str*10
    @MP = @int*10
    @hp = @HP
    @mp = @MP

    @atk = @str
    @mgc = @int
    @def = @str / 10
    @res = @int / 10

    @regenerate = ~~(@str/10)
    @active_range = 4
    @speed = @dex/40

    @next_lv = @lv * 50

  level_up: ()->
    @lv++
    @exp = 0
    @sp++
    @bp++ if @lv%3 is 0 
    @next_lv = @lv * 50
    @rebuild()
    @on_status_change()


  on_status_change :->
    

  get_exp:(point)->

  use_battle_point:(at)->
    if @bp>0 and at in ["str","int","dex"]
      @bp--
      @[at] +=1
      @rebuild()

      @on_status_change()
      true
    else
      null

  get_exp:(point)->
    @exp += point
    if @exp >= @next_lv
      @level_up()
      console.log 'level up! to lv.'+@lv

  set_next_exp:()->
    @next_lv = @lv * 30

  toData : ->
    class: @class
    race : @race
    exp  : @exp
    lv   : @lv
    sp   : @sp 
    bp   : @bp 
    hp   : @hp
    HP   : @HP
    mp   : @mp
    MP   : @MP
    str  : @str
    int  : @int
    dex  : @dex
    gold : @gold

 exports.Status = Status
