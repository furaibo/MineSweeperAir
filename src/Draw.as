package 
{
	import flash.utils.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	/**
	 * ...
	 * @author furaibo
	 */
	public class Draw extends Sprite
	{	
		
		// 埋め込み画像
		[Embed(source = "../img/back.png")]
		public var back:Class;
		[Embed(source = "../img/mas1.png")]
		public var mas1:Class;
		[Embed(source = "../img/mas2.png")]
		public var mas2:Class;
		[Embed(source = "../img/mas3.png")]
		public var mas3:Class;
		[Embed(source = "../img/masMine.png")]
		public var masMine:Class;
		[Embed(source = "../img/masCheckMine.png")]
		public var masCheckMine:Class;
		[Embed(source = "../img/masRedMine.png")]
		public var masRedMine:Class;
		[Embed(source = "../img/masType0.png")]
		public var masType0:Class;
		[Embed(source = "../img/masType1.png")]
		public var masType1:Class;
		[Embed(source = "../img/masType2.png")]
		public var masType2:Class;
		[Embed(source = "../img/masType3.png")]
		public var masType3:Class;
		[Embed(source = "../img/masType4.png")]
		public var masType4:Class;
		[Embed(source = "../img/masType5.png")]
		public var masType5:Class;
		[Embed(source = "../img/masType6.png")]
		public var masType6:Class;
		[Embed(source = "../img/masType7.png")]
		public var masType7:Class;
		[Embed(source = "../img/masType8.png")]
		public var masType8:Class;
		
		// メンバ変数
		private var g:Game;
		private var o:Option;
		private var gameboard:Array;
		private var rem_blocks:int;
		private var block_sprites:Array;
		private var start_timer:int;
		
		// フラグ
		private var first_click:Boolean;
		private var game_finished:Boolean;
		private var step_on_mine:Boolean;
		
		// コンストラクタ
		public function Draw(option:Option):void
		{	
			// 変数
			var i:int;
			var j:int;
			var images:Object;
			var tmp:String;
			
			// 設定の保存
			o = option;
			
			// ゲーム盤の初期化と取得
			g = new Game(o);
			gameboard = g.getGameBoard();
			
			// 地雷を除くオープン済みでないマス数のカウント
			rem_blocks = o.getRemBlocks();
			
			// ゲーム終了フラグを初期化する
			game_finished = false;
			step_on_mine = false;
			first_click = false;
			
			// スプライト格納用の配列の初期化
			block_sprites = new Array(o.getRowSize());
			for ( i = 0; i < o.getRowSize(); i++ ) {
				block_sprites[i] = new Array(o.getColSize());
				for (j = 0 ; j < o.getColSize(); j++ ) {
					block_sprites[i][j] = new Sprite();
				}
			}
			
			// 盤面の描画
			graphics.beginFill(0xDD9955); 
			graphics.drawRect(o.getBaseX() - o.getFrameWidth(), o.getBaseY() - o.getFrameWidth(), o.getImgSize()　*　o.getColSize() + o.getFrameWidth(), o.getImgSize()　*　o.getRowSize() + o.getFrameWidth());
			
			// 初期の盤面の描画
			for ( i = 0; i < o.getRowSize(); i++ ) {
				for ( j = 0; j < o.getColSize(); j++ ) {
					
					// Bitmapの設定
					var bm1:Bitmap = new mas1() as Bitmap;
					var bm2:Bitmap = new mas2() as Bitmap;
					
					// 座標の設定
					bm1.y = bm2.y = o.getBaseY() + o.getImgSize() * i;
					bm1.x = bm2.x = o.getBaseX() + o.getImgSize() * j; 
					
					// SpriteへのChildの追加
					block_sprites[i][j].addChild(bm2);
					block_sprites[i][j].addChild(bm1);
					
					// イベントリスナーの登録
					//block_sprites[i][j].addEventListener(MouseEvent.MOUSE_OVER, mouseOverBlock);
					//block_sprites[i][j].addEventListener(MouseEvent.MOUSE_OUT, mouseOutBlock);
					
					// SpriteをChildとして追加する
					addChild(block_sprites[i][j]);
					
				}
			}
			
			// イベントリスナーの登録
			registEventListeners();
			
		}
		
		// イベントリスナーを登録する
		private function registEventListeners():void {
			addEventListener(MouseEvent.RIGHT_CLICK, checkBlock);
			//addEventListener(MouseEvent.MOUSE_DOWN, pushBlock);
			addEventListener(MouseEvent.MOUSE_UP, openBlock);
		}
		
		// イベントリスナーを削除する
		private function removeAllEventListeners():void {
			removeEventListener(MouseEvent.RIGHT_CLICK, checkBlock);
			//addEventListener(MouseEvent.MOUSE_DOWN, pushBlock);
			removeEventListener(MouseEvent.MOUSE_UP, openBlock);
		}
		
		
		/*
		 * イベントリスナー
		 */
		// マウスの座標を表示する 
		private function getMousePosition(event:MouseEvent):void {
			trace(String(mouseX) + ", " + String(mouseY));
		}
		
		// マウスオーバー時のマス画像の入れ替え
		private function mouseOverBlock(event:MouseEvent):void
		{
			// マスの列と行の取得
			var row:int = (mouseY - o.getBaseY()) / o.getImgSize();
			var col:int = (mouseX - o.getBaseX()) / o.getImgSize();
			
			// 座標のチェック
			if ( row < 0 || col < 0 ) { return; }
			if ( row > o.getRowSize() - 1 || col > o.getColSize() - 1 ) { return; }
			
			// オープン済かどうかのチェック
			if ( gameboard[row][col].getOpen() ) { return; }
			
			// Spriteの画像を入れ替える
			event.target.swapChildrenAt(0, 1);
			
		}
		
		// マウスアウト時のマス画像の入れ替え
		private function mouseOutBlock(event:MouseEvent):void
		{
			// マスの列と行の取得
			var row:int = (mouseY - o.getBaseY()) / o.getImgSize();
			var col:int = (mouseX - o.getBaseX()) / o.getImgSize();
			
			// 座標のチェック
			if ( row < 0 || col < 0 ) { return; }
			if ( row > o.getRowSize() - 1 || col > o.getColSize() - 1 ) { return; }
			
			// オープン済かどうかのチェック
			if ( gameboard[row][col].getOpen() ) { return; }
			
			// Spriteの画像を入れ替える
			event.target.swapChildrenAt(0, 1);
		}
		
		// 右クリック(チェック)時のマスの画像入れ替え
		private function checkBlock(event:MouseEvent):void
		{
			// マスの列と行の取得
			var row:int = (mouseY - o.getBaseY()) / o.getImgSize();
			var col:int = (mouseX - o.getBaseX()) / o.getImgSize();
			
			// 座標のチェック
			if ( row < 0 || col < 0 ) { return; }
			if ( row > o.getRowSize() - 1 || col > o.getColSize() - 1 ) { return; }
			
			// オープン済かどうかのチェック
			if ( gameboard[row][col].getOpen() ) { return; }
			
			// 処理の分岐
			if ( !gameboard[row][col].getCheck() ) {
				
				// Bitmapインスタンスの作成
				var bm3:Bitmap = new mas3() as Bitmap;
				bm3.y = o.getBaseY() + o.getImgSize() * row;
				bm3.x = o.getBaseX() + o.getImgSize() * col;
				
				// SpriteにChildを追加
				block_sprites[row][col].removeChildAt(0);
				block_sprites[row][col].addChild(bm3);
				gameboard[row][col].switchCheck();
				
			} else {
				
				// Bitmapインスタンスの作成
				var bm1:Bitmap = new mas1() as Bitmap;
				bm1.y = o.getBaseY() + o.getImgSize() * row;
				bm1.x = o.getBaseX() + o.getImgSize() * col;
				
				// SpriteにChildを追加
				block_sprites[row][col].removeChildAt(0);
				block_sprites[row][col].addChild(bm1);
				gameboard[row][col].switchCheck();
				
			}
			
		}
		
		// マウスダウン時のマスの押下
		private function pushBlock(event:MouseEvent):void
		{
			// マスの列と行の取得
			var row:int = (mouseY - o.getBaseY()) / o.getImgSize();
			var col:int = (mouseX - o.getBaseX()) / o.getImgSize();
			
			// 座標のチェック
			if ( row < 0 || col < 0 ) { return; }
			if ( row > o.getRowSize() - 1 || col > o.getColSize() - 1 ) { return; }
			
			// 対象となるマスを全てオープンする
			var bm2:Bitmap = new mas2() as Bitmap;
			bm2.y = o.getImgSize() * row;
			bm2.x = o.getImgSize() * col;
			
			// SpriteにChildを追加
			block_sprites[row][col].removeChildAt(0);
			block_sprites[row][col].addChild(bm2);
			
		}
		
		// マウスアップ時のマスのオープン
		private function openBlock(event:MouseEvent):void
		{
			
			// マスの列と行の取得
			var row:int = (mouseY - o.getBaseY()) / o.getImgSize();
			var col:int = (mouseX - o.getBaseX()) / o.getImgSize();
			
			// 座標のチェック
			if ( row < 0 || col < 0 ) { return; }
			if ( row > o.getRowSize() - 1 || col > o.getColSize() - 1 ) { return; }
			
			// チェックされているマスであればオープンしない
			if ( gameboard[row][col].getCheck() ) { return; }
			
			// 枠内が最初にクリックされた場合、時間の起点を取得する
			if ( !first_click ) {
				first_click = true;
				start_timer = getTimer();
				trace("Game Start!");
			}
			
			// イベントリスナーを削除する
			//block_sprites[row][col].removeEventListener(MouseEvent.MOUSE_OVER, mouseOverBlock);
			//block_sprites[row][col].removeEventListener(MouseEvent.MOUSE_OUT, mouseOutBlock);
			
			// オープンするマスの数を数え、各マスの内容に該当する画像を読み込む
			var open_blocks:int = getBlockImages(row, col);
			
			// 地雷のあるマスをオープンした場合にはゲーム終了
			if ( gameboard[row][col].getMineStatus() ) {
				drawAllMines(row, col);
				removeAllEventListeners();
				game_finished = true;
				step_on_mine = true;
				trace("Game Over!");
				return;
			}
			
			// 残りのマス数のカウント
			rem_blocks -= open_blocks;
			
			// 残りのマス数の出力
			//trace(rem_blocks);
			
			// 残りのマス数が0となった場合にはゲーム終了
			if ( rem_blocks <= 0 ) {
				removeAllEventListeners();
				game_finished = true;
				trace("Game Clear!");
			}
			
		}
		
		
		// ゲッター
		public function getGameFinished():Boolean { return this.game_finished; }
		public function getStepOnMine():Boolean { return this.step_on_mine; }
		public function getFirstClick():Boolean { return this.first_click; }
		public function getRemBlocks():int { return this.rem_blocks; }
		public function getStartTimer():int { return this.start_timer; }
		
		
		/*
		 *  その他の関数群
		 */
		// マスの内容に該当する画像を読み込む
		private function getBlockImages(row:int, col:int):int
		{
			// 変数
			var i:int;
			var j:int;
			var open_count:int = 0;
			
			// オープン済かどうかのチェック
			if ( gameboard[row][col].getOpen() ) { return 0; }
			
			// 描画処理の分岐
			// オープンするマスが無印の場合
			if ( gameboard[row][col].getLabel() == "0" ) {
				
				// 配列の初期化
				var open:Array = new Array()
				for ( i = 0; i < o.getRowSize(); i++ ) {
					open[i] = new Array(o.getColSize());
				}
				
				// オープンするブロックの配列を受け取る
				open = g.searchOpenBlocks(row, col);
				
				// 配列に従ってブロックをオープン
				for ( i = 0; i < o.getRowSize(); i++ ) {
					for ( j = 0; j < o.getColSize(); j++ ) {
						if ( open[i][j] && !gameboard[i][j].getOpen() ) {
							drawBlock(i, j);
							open_count++;
						}
					}
				}
				
			// オープンするマスが無印でない場合
			} else {
				drawBlock(row, col);
				open_count = 1;
			}
			
			// 戻り値(オープンしたマスの数)
			return open_count;
			
		}
		
		
		// 指定されたマスを描画する
		private function drawBlock(row:int, col:int):void
		{
			// 変数
			var bm:Bitmap;;
			
			// Bitmap画像処理の分岐
			switch ( gameboard[row][col].getLabel() ) {
				case "*":
					bm = new masRedMine() as Bitmap;
					break;
				case "0":
					bm = new masType0() as Bitmap;
					break;
				case "1":
					bm = new masType1() as Bitmap;
					break;
				case "2":
					bm = new masType2() as Bitmap;
					break;
				case "3":
					bm = new masType3() as Bitmap;
					break;
				case "4":
					bm = new masType4() as Bitmap;
					break;
				case "5":
					bm = new masType5() as Bitmap;
					break;
				case "6":
					bm = new masType6() as Bitmap;
					break;
				case "7":
					bm = new masType7() as Bitmap;
					break;
				case "8":
					bm = new masType8() as Bitmap;
					break;
				default:
					break;
			}
			
			// Bitmap画像の座標を設定する
			bm.y = o.getBaseY() + o.getImgSize() * row;
			bm.x = o.getBaseX() + o.getImgSize() * col;
			
			// SpriteにBitmap画像を追加する
			block_sprites[row][col].removeChildAt(0);
			block_sprites[row][col].addChild(bm);
			
			// マスのオープン
			gameboard[row][col].setOpen();
			
		}
		
		// クリックされなかったすべての地雷マスを開示する
		public function drawAllMines(row:int, col:int):void
		{
			// 変数
			var i:int;
			var j:int;
			
			// クリックされなかった地雷マスの表示
			for ( i = 0; i < o.getRowSize(); i++ ) {
				for ( j = 0; j < o.getColSize(); j++ ) {
					if ( !(i == row && j == col) && gameboard[i][j].getMineStatus() ) {
						
						// Bitmapの取得
						var bm:Bitmap;
						
						// マスがチェック済みかどうかで画像を分岐
						if ( gameboard[i][j].getCheck() ){
							bm = new masCheckMine() as Bitmap;
						} else {
							bm = new masMine() as Bitmap;
						}
						
						// Bitmap画像の座標を設定する
						bm.y = o.getBaseY() + o.getImgSize() * i;
						bm.x = o.getBaseX() + o.getImgSize() * j;
						
						// SpriteにBitmap画像を追加する
						block_sprites[i][j].removeChildAt(0);
						block_sprites[i][j].addChild(bm);
						
					}
				}
			}
			
		}
		
	}
	
}