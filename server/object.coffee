#===== String =====
String::replaceAll = (org, dest) ->
  return @split(org).join(dest)

#===== Array =====
# Rubinize
Array::remove = (obj)-> @splice(@indexOf(obj),1)
Array::size = ()-> @.length
Array::first = ()-> @[0]
Array::last = ()-> @[@.length-1]
Array::each = Array::forEach

#===== UtilClass =====
Util = {}
Util.prototype =
  extend : (obj, mixin) ->
    obj[name] = method for name, method of mixin
    obj

  include : (klass, mixin) ->
    Util::extend klass.prototype, mixin

  dup : (obj)->
    f = ()->
    f.prototype = obj
    new f

include = Util::include
