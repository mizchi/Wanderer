{create_new} = require './server/Player'
config = require './config'
models = require './models'

@include = ->
  @get '/logout': ->
    @session.destroy ()=>
      @redirect '/'

  @get '/api/id': ->
    @send @session.name or ''

  @get '/': ->
    console.log @session.name
    # @session.name = "test"  # for debug
    if @session.name
      @render index:
        id : @session.name
    else
      @render login:
        layout:false

  @post '/register': ->
    console.log 'create account', @body
    name = @body.name
    pass = @body.pass
    race = @body.race
    cls = @body.class

    models.Users.get name,(e,doc)=>
      if doc
        @send 'already exist.'
        return

      savedata = create_new(name,race,cls)
      savedata.pass = pass
      models.Users.save @body.name , savedata, (e)=>
        console.log e or 'save success'
        @session.name = name
        console.log 'create new character'
        @redirect '/'

  @post '/login': ->
    console.log @body
    name = @body.name
    pass = @body.pass

    models.Users.get name,(e,doc)=>
      console.log e or doc
      console.log 'login get ', e 
      if pass is doc.pass
        @session.name = doc.name
        @redirect '/'
      else 
        @send 'no such a user'

