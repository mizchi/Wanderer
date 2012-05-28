express = require('express')
app = express.createServer()
app.use express.static(__dirname)

app.use (require "connect-assets")()
app.listen(8000)
console.log('http://localhost:8000/')

dnode = require('dnode')
server = dnode
  zing : (n, cb) -> cb(n * 100)

app.get '/', (req, res) -> res.send 'hello'

# server.listen(app)
#   io.configure ->
#   io.enable 'browser client minification'  # JSを圧縮する
#   io.enable 'browser client etag'  # etagによるキャッシュを有効にする
#   io.enable 'browser client gzip'  # gzipして転送する
#   io.set 'log level', 1   # ログ出力を減らす
#   io.set 'transports', [  # すべての通信手段を有効にする
#            'websocket'
#            'flashsocket'
#            'htmlfile'
#            'xhr-polling'
#            'jsonp-polling'
#      ]
