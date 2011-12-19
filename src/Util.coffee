{random,sqrt,min,max} = Math

exports.randint = (from,to)->
  if not to?
    to = from
    from = 0
  ~~(random()*(to-from+1))+from
  
exports.IntervalMessage = (dump,t,cnt=0)->
  -> console.log dump unless (cnt++)%t

