package 
{
	import flash.utils.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.display.NativeWindow;
	
	/**
	 * ...
	 * @author furaibo
	 */
	public class Main extends Sprite
	{
		
		// 埋め込み画像
		[Embed(source = "../img/back.png")]
		public var back:Class;
		[Embed(source = "../img/retry.png")]
		public var retry:Class;
		[Embed(source = "../img/easy1.gif")]
		public var easy1:Class;
		[Embed(source = "../img/easy2.gif")]
		public var easy2:Class;
		[Embed(source = "../img/normal1.gif")]
		public var normal1:Class;
		[Embed(source = "../img/normal2.gif")]
		public var normal2:Class;
		[Embed(source = "../img/hard1.gif")]
		public var hard1:Class;
		[Embed(source = "../img/hard2.gif")]
		public var hard2:Class;
		
		// メンバ変数
		public var bm_title:Bitmap;
		public var bm_easy1:Bitmap;
		public var bm_easy2:Bitmap;
		public var bm_normal1:Bitmap;
		public var bm_normal2:Bitmap;
		public var bm_hard1:Bitmap;
		public var bm_hard2:Bitmap;
		public var bm_back:Bitmap;
		public var bm_retry:Bitmap;
		public var tf_time:TextField;
		public var tf_rem:TextField;
		public var sp_title:Sprite;
		public var sp_easy:Sprite;
		public var sp_normal:Sprite;
		public var sp_hard:Sprite;
		public var sp_back:Sprite;
		public var sp_retry:Sprite;
		public var o:Option;
		public var d:Draw;
		public var selected_mode:String;
		
		
		// Main関数
		public function Main()
		{
			init();
		}
		
		// 初期化用の関数
		public function init():void
		{
			
			// スケールに関しての設定
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// ネイティブウィンドウのサイズを設定する
			var window:NativeWindow = stage.nativeWindow;
			window.width = 600;
			window.height = 550;
			
			// TextFieldインスタンス
			var tf:TextField = new TextField;
			tf.defaultTextFormat = new TextFormat("ＭＳ ゴシック", 40, 0x000000); 
			tf.autoSize = TextFieldAutoSize.LEFT; 
			tf.text = "マインスイーパ";
			
			// BitmapDataインスタンス
			var canvas:BitmapData = new BitmapData(tf.textWidth, tf.textHeight, false, 0xFFFFFF); 
			canvas.draw(tf); 
			var bm_title:Bitmap = new Bitmap(canvas);
			
			// Bitmapインスタンス
			bm_easy1 = new easy1() as Bitmap;
			bm_easy2 = new easy2() as Bitmap;
			bm_normal1 = new normal1() as Bitmap;
			bm_normal2 = new normal2() as Bitmap;
			bm_hard1 = new hard1() as Bitmap;
			bm_hard2 = new hard2() as Bitmap;
			
			// ボタンの座標の決定
			bm_title.y = 70;
			bm_title.x = 160;
			bm_easy1.y = bm_easy2.y = 190;
			bm_easy1.x = bm_easy2.x = 190;
			bm_normal1.y = bm_normal2.y = 270;
			bm_normal1.x = bm_normal2.x = 190;
			bm_hard1.y = bm_hard2.y = 350;
			bm_hard1.x = bm_hard2.x = 190;
			
			// Spriteの作成
			sp_title  = new Sprite();
			sp_easy   = new Sprite();
			sp_normal = new Sprite();
			sp_hard   = new Sprite();
			
			// BitmapインスタンスをSpriteに追加する
			sp_title.addChild(bm_title);
			sp_easy.addChild(bm_easy1);
			sp_easy.addChild(bm_easy2);
			sp_normal.addChild(bm_normal1);
			sp_normal.addChild(bm_normal2);
			sp_hard.addChild(bm_hard1);
			sp_hard.addChild(bm_hard2);
			
			// Spriteへイベントリスナーを追加する
			sp_easy.addEventListener(MouseEvent.MOUSE_DOWN, pushModeButton("Easy"));
			sp_easy.addEventListener(MouseEvent.MOUSE_OVER, putMouseButton);
			sp_easy.addEventListener(MouseEvent.MOUSE_OUT, putMouseButton);
			sp_normal.addEventListener(MouseEvent.MOUSE_DOWN, pushModeButton("Normal"));
			sp_normal.addEventListener(MouseEvent.MOUSE_OVER, putMouseButton);
			sp_normal.addEventListener(MouseEvent.MOUSE_OUT, putMouseButton);
			sp_hard.addEventListener(MouseEvent.MOUSE_DOWN, pushModeButton("Hard"));	
			sp_hard.addEventListener(MouseEvent.MOUSE_OVER, putMouseButton);
			sp_hard.addEventListener(MouseEvent.MOUSE_OUT, putMouseButton);
			
			// ボタンモードをtrueにする
			sp_easy.buttonMode = true;
			sp_normal.buttonMode = true;
			sp_hard.buttonMode = true;
			
			// Spriteを子として追加する
			stage.addChild(sp_title);
			stage.addChild(sp_easy);
			stage.addChild(sp_normal);
			stage.addChild(sp_hard);
		
		}
		
		// ゲームを開始する
		public function gameStart(mode:String):void
		{
			
			// Optionインスタンスの作成
			o = new Option(mode);
			
			// Drawインスタンスの作成
			d = new Draw(o);
			
			// スケールの設定
			this.setStageScale(o);
			
			// Drawインスタンスを子として追加
			stage.addChild(d);
			
			// 戻るボタンを描画
			makeBackButton(o);
			
			// リトライボタンの描画
			makeRetryButton(o);
			
			// 現在の状態を表示するパネルの描画
			makeStatusPanel(o);
			
			// イベントリスナーの追加
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		// stageのスケールを設定する
		public function setStageScale(o:Option):void
		{
			stage.stageWidth  = o.getStageWidth();
			stage.stageHeight = o.getStageHeight();
		}
		
		
		/*
		 * ボタン・パネル作成メソッド群
		 */
		// 戻るボタンを描画する
		public function makeBackButton(o:Option):void
		{
			// 戻るボタンの描画
			sp_back = new Sprite();
			bm_back = new back() as Bitmap;
			bm_back.y = o.getBackY();
			bm_back.x = o.getBackX();
			sp_back.addEventListener(MouseEvent.CLICK, pushBackButton);
			sp_back.buttonMode = true;
			sp_back.addChild(bm_back);
			stage.addChild(sp_back);
		}
		
		// リトライボタンを描画する
		public function makeRetryButton(o:Option):void
		{
			// リトライボタンの描画
			sp_retry = new Sprite();
			bm_retry = new retry() as Bitmap;
			bm_retry.y = o.getRetryY();
			bm_retry.x = o.getRetryX();
			sp_retry.addEventListener(MouseEvent.CLICK, pushRetryButton);
			sp_retry.buttonMode = true;
			sp_retry.addChild(bm_retry);
			sp_retry.visible = false;
			stage.addChild(sp_retry);
		}
		
		// 状態パネルを作成する
		private function makeStatusPanel(o:Option):void
		{
			// TextFieldインスタンス
			// 経過秒数
			tf_time = new TextField();
			tf_time.defaultTextFormat = new TextFormat("ＭＳ ゴシック", o.getPanelFontSize(), 0x000000); 
			tf_time.autoSize = TextFieldAutoSize.LEFT; 
			tf_time.text = "時間 : 0:00";
			
			// 残りのマス数
			tf_rem = new TextField();
			tf_rem.defaultTextFormat = new TextFormat("ＭＳ ゴシック", o.getPanelFontSize(), 0x000000); 
			tf_rem.autoSize = TextFieldAutoSize.LEFT; 
			tf_rem.text = "残数 : "　 + String(d.getRemBlocks());
			
			// 幅の設定
			tf_time.width = o.getPanelWidth();
			tf_rem.width  = o.getPanelWidth();
			
			// テキストフィールドの座標
			tf_time.x = o.getPanelX();
			tf_time.y = o.getPanelY();
			tf_rem.x = o.getPanelX();
			tf_rem.y = o.getPanelY() + o.getPanelFontSize() * 1.5;
			
			// stageへの追加
			stage.addChild(tf_time);
			stage.addChild(tf_rem);
			
		}
		
		// 状態パネルを更新する
		private function updateStatusPanel():void
		{
			// ステータスパネルの更新
			if ( !d.getGameFinished() && d.getFirstClick() ) {
				tf_time.text = "時間 : " + getPassedTimeStr();
			}
			tf_rem.text = "残数 : " + String(d.getRemBlocks());
		}
		
		// 経過時間の文字列を取得する
		private function getPassedTimeStr():String
		{
			// 経過した秒数を時間:分:秒の単位に分ける
			var str:String = "";
			var passed_sec:int = (int)((getTimer() - d.getStartTimer()) / 1000);
			var hour:int = (int)(passed_sec / 3600);
			var min:int = (int)((passed_sec - hour * 60) / 60);
			var sec:int = (int)(passed_sec - min * 60);
			
			// 表示の調整
			// 時間
			if ( hour > 0 ) {
				str += hour + ":";
			}
			
			// 分
			if ( hour == 0 && min > 0 ) {
				str += min + ":";
			} else if ( hour > 0 && min < 10 ) {
				str += "0" + min + ":";
			} else {
				str += "0:"
			}
			
			// 秒
			if ( sec < 10 ) {
				str += "0" + sec;
			} else {
				str += sec;
			}
			
			// 戻り値
			return str;
		}
		
		
		/*
		 * イベントリスナー
		 */
		// 毎フレーム行う処理
		private function onEnterFrame(event:Event):void 
		{
			
			// 状態パネルの更新
			updateStatusPanel();
			
			// ゲームが終了したかどうかのチェック
			if ( d.getGameFinished() || d.getStepOnMine() ) {
				
				// リトライボタンを可視化する
				sp_retry.visible = true;
				
				// 自身を削除する
				stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				
			}
			
		}
		
		// 難易度ボタンを押下した時の処理
		private function pushModeButton(mode:String):Function
		{
			return function(event:Event):void {
				
				// マウスを一時的に無効とする
				stage.mouseChildren = false;
				
				// ステージからから全要素を除く
				stage.removeChild(sp_title);
				stage.removeChild(sp_easy);
				stage.removeChild(sp_normal);
				stage.removeChild(sp_hard);
				
				// ゲーム開始
				gameStart(mode);
				
				// 一定時間経過後にマウスを有効にする
				var timer:Timer = new Timer(200, 1);
				timer.addEventListener(TimerEvent.TIMER, function():void{ stage.mouseChildren = true; } )
				timer.start();
				
			}
		}
		
		// ボタン上にマウスポインタを置いた場合の処理
		private function putMouseButton(event:Event):void
		{
			// Spriteの画像を入れ替える
			event.target.swapChildrenAt(0, 1);
		}
				
		// 戻るボタンを押した際の処理
		private function pushBackButton(event:Event):void
		{
			// メッセージ
			trace("Back-button is pushed.");
			
			// 現在のゲーム盤を消去する
			stage.removeChild(d);
			
			// 戻るボタンを消去する
			stage.removeChild(sp_back);
			
			// リトライボタンを消去する
			stage.removeChild(sp_retry);
			
			// ステータスパネルを削除する
			stage.removeChild(tf_time);
			stage.removeChild(tf_rem);
			
			// ゲーム盤の初期化
			init();
		}
		
		// リトライボタンを押した際の処理
		private function pushRetryButton(event:Event):void
		{
			// メッセージ
			trace("Retry-button is pushed.");
			
			// 現在のゲーム盤を消去する
			stage.removeChild(d);
			
			// リトライボタンを不可視にする
			sp_retry.visible = false;
			
			// ステータスパネルを削除する
			stage.removeChild(tf_time);
			stage.removeChild(tf_rem);
			
			// ゲームの開始
			gameStart(o.getMode());
		}
		
	}
	
}