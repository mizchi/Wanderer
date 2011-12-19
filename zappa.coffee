config = require './config'
require('zappa') config.port, ->
  @io.configure =>
    @io.set( "log level", 1 )
    @io.set "authorization", (handshake, callback) ->
      cookie = handshake.headers.cookie;
      handshake.foo = cookie
      callback(null, true)

  @app.use @express.bodyParser()
  @app.use @express.methodOverride()
  @app.use @express.cookieParser()
  @app.use @express.session
    secret: config.session_secret
    cookie: { maxAge: 86400 * 1000 }
  @app.use @app.router
  @app.use @express.static __dirname+'/client'
  @app.set 'views', __dirname + '/views'
  @app.use @express.favicon()
  @set 'views', __dirname + '/views'
  @enable 'serve jquery'
  @include 'zi_web'
  @include 'zi_logic'