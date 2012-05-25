{random,sqrt,min,max} = Math

extend = (obj, mixin) ->
  obj[name] = method for name, method of mixin        
  obj

include = (klass, mixin) ->
  extend klass.prototype, mixin

exports.randint = (from,to)->
  if not to?
    to = from
    from = 0
  ~~(random()*(to-from+1))+from
  
exports.IMessage = (dump,t,cnt=0)->
  -> console.log dump unless (cnt++)%t

cls2json = (cls)->
  return cls unless cls instanceof Object

  json = {}
  for k,v of cls
    if typeof v is 'function' or k[0] is '_'
    else if typeof v in ['string','number','boolean']
      json[k] = v
    else if v instanceof Array 
      json[k] = (cls2json(v[i]) for i in [0...v.length])
    else if v instanceof Object
      json[k] = cls2json(v)
  return json

# class Model 
#   _iparam_ : {}

#   constructor : (data={})->
#     for k,v of @_iparam_
#       @[k] = data[k] or @_iparam_[k] 

#   toJson : (cls)->
#     return @toJson(@) if cls is undefined 
#     return cls unless cls instanceof Object

#     json = {}
#     for k,v of cls
#       if typeof v is 'function' or k[0] is '_'
#       else if typeof v in ['string','number','boolean']
#         json[k] = v
#       else if v instanceof Array 
#         json[k] = (@toJson(v[i]) for i in [0...v.length])
#       else if v instanceof Object
#         json[k] = @toJson(v)
#     return json

# class A extends Model
#   _iparam_ :
#     x : 1
#     y : 2
#     _y : 5
#     z : [1,3,5]

#   constructor : (data={})->
#     super data

#   func : ->
#     @x+@y

# class Gather extends Model
#   _iparam_ :
#     name : 'gather'
#     items : []

#   constructor : (data={})->
#     super data
#     (@items.push new A) for i in [1..10]


# a = new A
# alt = new A {
#   x: 330
# }
# console.log alt
# console.log alt.toJson()
# g = new Gather
# console.log g.toJson()
