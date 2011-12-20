# def func
$$ = text
bind = (text,obj={})->
  if typeof text is "object"
    obj["data-bind"] = (k+":"+v for k,v of text).join(',')
  else
    obj["data-bind"] = text
  obj

jqtpl = (tpname,fn)->
  div bind template:"'#{tpname}'",{class:"#{tpname}"}
  script id:tpname,type:"text/html",-> fn()

PlayerStatusPanel = ->
  jqtpl 'PlayerStatus', ->
    $$ "{{if CharInfo()}}"
    h4 -> "${CharInfo().name}"
    a href : '/logout',-> "Logout"
    p -> "${CharInfo().status.class} lv.${CharInfo().status.lv} [${CharInfo().status.race}]"
    $$ "{{/if}}"

ObjectListPanel = ->
  jqtpl 'ObjecetList', ->
    ul id:"side-menu",->
      $$ "{{each(i,info) ObjectInfo}}"
      $$ "{{if info.o[2] > 1000 }}"
      li ->
        p -> "${info.s.n} lv.${info.s.lv} HP:${info.s.hp}%"
      $$ "{{/if}}"
      $$ "{{/each}}"

SkillStatusPanel = ->
  jqtpl 'SkillInfo', ->
    $$ "{{if CharInfo()}}"
    div class:"row",->
      $$ "{{each(k,v) keys}}"
      div class:"span1",->
        button (bind click:"wait_for_skill",{target:'${k}',class:'wait_skill_btn'}),->'${k}'
        $$ "{{if CharInfo().skills.preset[k] }}"
        span "${CharInfo().skills.preset[k] }"
        $$ "{{/if}}"
      $$ "{{/each}}"
    $$ "{{/if}}"

  jqtpl 'CTInfo', ->
    $$ "{{if CharInfo()}}"
    div class:"row" , ->
      $$ "{{each(i,ct) CoolTime}}"
      div class:'span1' ,->
        p "${ct}%"
      $$ "{{/each}}"
    $$ "{{/if}}"

MainWindowPanel = ->
  canvas id:"game",style:"float:left;background-color:black;"

SkillLevelPanel = ->
  jqtpl 'skill-chart', ->
    $$ "{{if CharInfo()}}"
    p -> "SP:${CharInfo().status.sp}p"
    dl id:"skill-list",->
      $$ "{{each(sname,lv) CharInfo().skills.learned}}"
      dt ->  '${sname}'
      dd ->
        div class:'row',->
          div class:'span1',->
            span "${lv} &nbsp;"

          $$ "{{if CharInfo().status.sp > 0}}"
          div class:'span1',->
            button bind(click:'use_skill_point',{target:'${sname}',class:""}), -> '+'

          div class:'span1',->
            button bind(click:'set_skill',visible:'edit_skill_mode',{target:"${sname}"}),-> "set"

        $$ "{{/if}}"
      $$ "{{/each}}"
      $$ "{{/if}}"

StatusLevelPanel = ->
  jqtpl 'StatusInfo', ->
    $$ "{{if CharInfo()}}"
    p -> "BP:${CharInfo().status.bp}p"
    dl -> 
      for i in ['str','int','dex']
        dt -> i
        dd -> 
          span -> "${CharInfo().status.#{i}} &nbsp;"

          $$ "{{if CharInfo().status.bp > 0}}"
          button bind(click:'use_battle_point',{target:i,class:"use_bp_btn"}), ->  "+"
          $$ "{{/if}}"
    $$ "{{/if}}"


div class:"container-fluid row",->
  div class:'span3',->
    PlayerStatusPanel()
    ObjectListPanel()

  div class:"span8",->
    SkillStatusPanel()
    MainWindowPanel()

  div class:"span5",->
    div class:"row",->
      ul class:"tabs",'data-tabs':"tabs",->
        li class:"active",-> a href:"#item",->'Item(i)'
        li -> a href:"#skill",-> 'Skill(k)'
        li -> a href:"#character",-> 'Character(c)'

      div class:"pill-content",->
        div class:"active",id:"item",->
          'Item'
        div id:"skill",->
          SkillLevelPanel()
        div id:'character',->
          StatusLevelPanel()


coffeescript ->
  $('.tabs').tabs()

  canvas =  document.getElementById "game"
  x = 16
  y = 12
  cell = 25
  canvas.width = x * cell
  canvas.height = y * cell

  view.keys = 
    1:null
    2:null
    3:null
    4:null
    5:null

  $ =>
    $.get '/api/id' , (name)=>
      window.name = name
      window.floor = 0
      window.login name , floor
      window.grr = new GameRenderer x,y,cell
      ko.applyBindings view
