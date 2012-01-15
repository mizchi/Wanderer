# 

クラス：キャラクター

BaseStatus 
 - str 筋力
 - int 知力
 - dex 器用
キャラクターごとのベースステータス
レベルアップでステータスを伸ばせる


Class : (static) キャラクターが属するクラス
 - hp_rate
 - mp_rate
 - 
 - 

Race : (static)キャラクターが属する種族
 - 
 - 
 - 

BattleStatus
 - HP = BaseStatus#str * Class#hp_rate
 - MP = BaseStatus#int * Class#mp_rate
 

Class
# 

HP: 
