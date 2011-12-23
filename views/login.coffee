doctype 5
html ->
  head lang:'ja',->
  title 'Wanderer'
  (link rel:"stylesheet",type:"text/css",href:i) for i in [
    "/css/bootstrap.min.css"
  ]

body ->
  div class:"container-fluid",->
    h1 -> "Wanderer"
    div class:"content",->
      p -> "キャラクターを作成"
      form action:'/register',method:"POST",->
        p ->
          input name:'name'
          input type:'password', name:'pass'
        p ->
          span "種族" 
          fieldset ->
            input type:"radio",name:"race",value:"human",checked:true,-> "human"
            span "human"
            br ''

            input type:"radio",name:"race",value:"elf",-> "elf"
            span "elf"
            br ''

            input type:"radio",name:"race",value:"dwarf",->"dwarf"
            span "dwarf"
            br ''
        p ->
          span "クラス" 
          fieldset ->
            input type:"radio",name:"class",value:"Lord",checked:true,->"Lord"
            span -> "Lord"
            br()

            input type:"radio",name:"class",value:"Warrior",->"Warrior"
            span -> "Warrior"
            br()

            input type:"radio",name:"class",value:"Sorcerer",->"Sorcerer"
            span -> "Sorcerer"
            br()
          
        p -> input type:'submit',value:'キャラクターを作成'
        
      hr "clear"
      
      p -> "ログイン"
      form action:'/login',method:"POST",->
        input name:'name'
        input type:'password', name:'pass'
        input type:'submit',value:'ログイン'

    div class:'guide',->
      p -> '数字キーで技セット'
      p -> 'スペースでターゲット切り替え'
      dl ->
        dt 'Atack'
        dd '攻撃'

        dt 'Smash'
        dd 'ノックバック付き強攻撃 '

        dt 'Heal'
        dd '回復'

        dt 'Meteor'
        dd 'ターゲット周辺を巻き込む魔法攻撃'

        dt 'Lightning'
        dd '周辺にチェインする魔法の雷'


