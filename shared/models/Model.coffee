class Model
  _iparam_ : {}

  constructor : (data={})->
    for k,v of @_iparam_
      @[k] = data[k] or @_iparam_[k]

  toJson : (cls)->
    return @toJson(@) if cls is undefined
    return cls unless cls instanceof Object

    json = {}
    for k,v of cls
      if typeof v is 'function' or k[0] is '_'
      else if typeof v in ['string','number','boolean']
        json[k] = v
      else if v instanceof Array
        json[k] = (@toJson(v[i]) for i in [0...v.length])
      else if v instanceof Object
        json[k] = @toJson(v)
    return json

module?.exports = Model
