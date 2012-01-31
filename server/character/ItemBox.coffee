class ItemBox
  constructor : (data)->
    @items = data or []
  toData :->
    @items

exports.ItemBox = ItemBox
