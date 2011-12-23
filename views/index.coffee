# def func
bind = (text,obj={})->
  if typeof text is "object"
    obj["data-bind"] = (k+":"+v for k,v of text).join(',')
  else
    obj["data-bind"] = text
  obj

$with = (ns,fn)->
  div (bind with:ns), -> fn()

Panes = 
  Char : ->
    $with 'char',->
      h4 bind text:'name'
      $with 'status',->
        p -> 
          span "class:"
          span bind text: 'status.class'
        p -> bind text: 'race'
        p -> bind text: 'lv'

#   jqtpl 'PlayerStatus', ->
#     $$ "{{if CharInfo()}}"
#     h4 -> "${CharInfo().name}"
#     a href : '/logout',-> "Logout"
#     p -> "${CharInfo().status.class} lv.${CharInfo().status.lv} [${CharInfo().status.race}]"
#     $$ "{{/if}}"

ObjectListPane = ->
#   jqtpl 'ObjecetList', ->
#     ul id:"side-menu",->
#       $$ "{{each(i,info) ObjectInfo}}"
#       $$ "{{if info.o[2] > 1000 }}"
#       li ->
#         p -> "${info.s.n} lv.${info.s.lv} HP:${info.s.hp}%"
#       $$ "{{/if}}"
#       $$ "{{/each}}"

SkillStatusPane = ->
#   jqtpl 'SkillInfo', ->
#     $$ "{{if CharInfo()}}"
#     div class:"row",->
#       $$ "{{each(k,v) keys}}"
#       div class:"span1",->
#         button (bind click:"wait_for_skill",{target:'${k}',class:'wait_skill_btn fill'}),->'${k}'
#         $$ "{{if CharInfo().skills.preset[k] }}"
#         span "${CharInfo().skills.preset[k] }"
#         $$ "{{/if}}"
#       $$ "{{/each}}"
#     $$ "{{/if}}"

#   jqtpl 'CTInfo', ->
#     $$ "{{if CharInfo()}}"
#     div class:"row" , ->
#       $$ "{{each(i,ct) CoolTime}}"
#       div class:'span1' ,->
#         p "${ct}%"
#       $$ "{{/each}}"
#     $$ "{{/if}}"

MainWindowPane = ->
  canvas id:"game",style:"float:left;background-color:black;"

SkillLevelPane = ->
#   jqtpl 'skill-chart', ->
#     $$ "{{if CharInfo()}}"
#     p -> "SP:${CharInfo().status.sp}p"
#     dl id:"skill-list",->
#       $$ "{{each(sname,lv) CharInfo().skills.learned}}"
#       dt ->  '${sname}'
#       dd ->
#         div class:'row',->
#           div class:'span1',->
#             span "${lv} &nbsp;"

#           $$ "{{if CharInfo().status.sp > 0}}"
#           div class:'span1',->
#             button bind(click:'use_skill_point',{target:'${sname}',class:"fill"}), -> '+'

#           div class:'span1',->
#             button bind(click:'set_skill',visible:'edit_skill_mode',{target:"${sname}"}),-> "set"

#         $$ "{{/if}}"
#       $$ "{{/each}}"
#       $$ "{{/if}}"

StatusLevelPane = ->
#   jqtpl 'StatusInfo', ->
#     $$ "{{if CharInfo()}}"
#     p -> "BP:${CharInfo().status.bp}p"
#     dl -> 
#       for i in ['str','int','dex']
#         dt -> i
#         dd -> 
#           span -> "${CharInfo().status.#{i}} &nbsp;"

#           $$ "{{if CharInfo().status.bp > 0}}"
#           button bind(click:'use_battle_point',{target:i,class:"use_bp_btn"}), ->  "+"
#           $$ "{{/if}}"
#     $$ "{{/if}}"


div class:"container-fluid row",->
  div class:'span3',->
    Panes.Char()
    ObjectListPane()

  div class:"span8",->
    # SkillStatusPanel()
    MainWindowPane()

  div class:"span5",->
    div class:"row",->
      ul class:"tabs",'data-tabs':"tabs",->
        li class:"active",-> a href:"#item",->'Item(i)'
        li -> a href:"#skill",-> 'Skill(k)'
        li -> a href:"#character",-> 'Character(c)'
        li -> a href:"#log",-> 'Log(l)'
        li -> a href:"#config",-> 'Config(c)'

      div class:"pill-content",->
        div class:"active",id:"item",->
          'Item(未実装)'

        div id:"skill",->
          SkillLevelPane()

        div id:'character',->
          StatusLevelPane()

        div id:'log',->
          'Message Log(未実装) '

        div id:'config',->

          p -> button onclick:'window.grr.scale++',-> '拡大'
          p -> button onclick:'window.grr.scale--',-> '縮小'
          p -> button onclick:'''
            grr.bgm.muted = grr.bgm.muted? false : true;
            localStorage.config.muted = grr.bgm.muted;
          ''',-> 'BGM再生 on/off'


coffeescript ->
  $('.tabs').tabs()

  canvas =  document.getElementById "game"
  x = 12
  y = 8
  cell = 38
  canvas.width = x * cell
  canvas.height = y * cell

  $ =>
    $.get '/api/id' , (name)=>
      window.name = name
      window.floor = 0
      window.login name , floor
      window.grr = new GameRenderer x,y,cell
      ko.applyBindings viewModel
