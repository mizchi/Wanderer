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

 exports.Status = Status
