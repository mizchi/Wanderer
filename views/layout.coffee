doctype 5
html ->
  head lang:'ja',->
    title 'Wanderer'
    script(src: src) for src in [
      '/socket.io/socket.io.js'
      '/zappa/zappa.js'
      '/zappa/jquery.js'
      '/exlib/jquery.tmpl.js'
      '/exlib/knockout-1.3.0beta.js'
      '/exlib/bootstrap-tabs.js'

      '/all.js'
      '/bootstrap.js'
      '/index.js'
    ]
    (link rel:"stylesheet",type:"text/css",href:i) for i in [
      "/bootstrap.min.css"
      "/style.css"
    ]
  body @body