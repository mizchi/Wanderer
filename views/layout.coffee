doctype 5
html ->
  head lang:'ja',->
    title 'Wanderer'
    script(src: src) for src in [
      '/socket.io/socket.io.js'
      '/zappa/zappa.js'
      '/zappa/jquery.js'
      '/exlib/knockout-2.0.0.js'
      '/exlib/bootstrap-tabs.js'
      '/all.js'
      '/index.js'
    ]
    
    (link rel:"stylesheet",type:"text/css",href:i) for i in [
      "/css/bootstrap.min.css"
      "/css/style.css"
    ]
  body @body