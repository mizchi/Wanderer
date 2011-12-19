# for Client Develloper #
警告：以下の記事は予告なく仕様が変わることがあります。  
詳しい挙動は直接コードを読むか、データをダンプして確認してください。

## クライアントに関わるコード
* app.coffee 送信/受信の振り分け
* public/game.coffee(game.js) クライアントのゲームレンダラ
# views/index.coffee 

## WebSocketアップデートプロトコル
なお、以下のコードはJSONで送受信している。  
将来的には node-msgpackの採用も検討中

### on connection
ログイン時にマップデータを受け取る。マップデータは二次元のBinary Array。
HightMap , CollitionMap , ObjectMap の3つに分割することを検討中。(現行のものはCollitionMap)

### on update
毎秒15回(通信品質に依存)
ステージの更新を受け取る。パケットが多いので、可能な限りシリアライズする。

objsは以下のArray  


~~~~~
[
  {
    o:  # 対象の情報
        [ キャラクタのx座標 , y座標, ユニークID , 所属グループ]
    s:  # 対象の詳細情報
        {
            n  : 名前
            lv : レベル   
            hp : 残りHP(%)
        }

    t:  # 対象が目標しているオブジェクト。いないときはnull
      [ ターゲットのx座標, y座標 , ユニークID , 所属グループ ] 

    a:  # アニメーションイベントのArray 
    [
        [ アニメーションID ,アニメーションタイプ ] 
        ...    
    ]
  },
  ...
]
~~~~

#### アニメーションイベント
* args[0]/aid : 対応したアニメーションのID
* args[1]/type : 発火型/持続型

### on update_ct
セットされた技のクールタイムのArray

