nstore = require 'nstore'
exports.Users = nstore.new("savedata/users.db")

save = (char,fn=->)->
  return fn(true,null) unless char?.name
  Users.get char.name, (e,item)->
    console.log "save : ", char.name
    Users.save char.name , char.toData() ,(e)->
      console.log e if e
