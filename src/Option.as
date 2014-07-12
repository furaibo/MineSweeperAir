package 
{
	
	/**
	 * ...
	 * @author jun
	 */
	public class Option 
	{
		
		// メンバ変数
		private var mode:String;		// 現在の難易度モード
		private var stage_width:int;	// stageの幅
		private var stage_height:int	// stageの高さ
		private var base_x:int;			// ゲーム盤の位置の基準となるx座標
		private var base_y:int;			// ゲーム盤の位置の基準となるy座標
		private var back_x:int;			// 戻るボタンのx座標
		private var back_y:int;			// 戻るボタンのy座標
		private var retry_x:int;		// リトライボタンのx座標
		private var retry_y:int;		// リトライボタンのy座標
		private var panel_width:int;	// パネルの幅
		private var panel_height:int;	// パネルの高さ
		private var panel_x:int;		// パネルのx座標
		private var panel_y:int;		// パネルのy座標
		private var panel_font_size:int // パネル内の文字のフォントサイズ(px)
		private var blank_width:int;	// ウィンドウ周りの余白の幅(px)
		private var row_size:int;		// ゲーム盤のマス目の縦幅
		private var col_size:int;		// ゲーム盤のマス目の横幅
		private var mine:int;			// 地雷の個数
		private var img_size:int;		// 画像の幅(px)
		private var back_img_size:int;	// 戻るボタンの画像の幅
		private var retry_img_size:int; // リトライボタンの画像の幅
		private var flame_width:int;	// ゲーム盤のフレームの幅(px)
		
		// コンストラクタ
		public function Option(mode:String):void
		{
			// 各変数の初期化
			this.mode = mode;
			this.blank_width = 50;
			this.img_size = 20;
			this.panel_width = 40;
			//this.panel_height = 10;
			this.panel_font_size = 14;
			this.back_img_size = 40;
			this.retry_img_size = 72;
			this.flame_width = 2;
			
			// 選択したモードごとに分岐する
			switch (this.mode) {
				case "Easy":
					this.row_size = 10;
					this.col_size = 10;
					this.mine = 15;
					break;
				case "Normal":
					this.row_size = 16;
					this.col_size = 16;
					this.mine = 40;
					break;
				case "Hard":
					this.row_size = 20;
					this.col_size = 40;
					this.mine = 99;
					break;
				default:
					break;
			}
			
			// ゲーム盤の端の座標の設定
			this.base_x = this.blank_width;
			this.base_y = this.blank_width;
			
			// ステージサイズの設定
			this.stage_width  = this.img_size * this.col_size + this.blank_width * 2;
			this.stage_height = this.img_size * this.row_size + this.blank_width * 3;
			
			// パネルの座標の設定
			this.panel_x = this.stage_width - this.blank_width * 1.8;
			this.panel_y = this.stage_height - this.panel_font_size * 4;
			
			// 戻るボタンの座標を設定
			this.back_x = 0;
			this.back_y = this.stage_height - this.back_img_size;
			
			// リトライボタンの座標を設定
			this.retry_x = (this.stage_width - this.retry_img_size) / 2;
			this.retry_y = this.stage_height - this.blank_width * 1.6;
			
		}
		
		// ゲッター
		public function getMode():String       { return this.mode; }
		public function getBaseX():int         { return this.base_x; }
		public function getBaseY():int         { return this.base_y; }
		public function getStageWidth():int    { return this.stage_width; }
		public function getStageHeight():int   { return this.stage_height; }
		public function getBackX():int         { return this.back_x; }
		public function getBackY():int         { return this.back_y; }
		public function getRetryX():int        { return this.retry_x; }
		public function getRetryY():int        { return this.retry_y; }
		public function getPanelX():int        { return this.panel_x; }
		public function getPanelY():int        { return this.panel_y; }
		public function getPanelWidth():int    { return this.panel_width; }
		public function getPanelFontSize():int { return this.panel_font_size; }
		public function getRowSize():int       { return this.row_size; }
		public function getColSize():int       { return this.col_size; }
		public function getMine():int          { return this.mine; }
		public function getImgSize():int       { return this.img_size; }
		public function getFrameWidth():int    { return this.flame_width; }
		
		// セッター
		public function setRowSize(row_size:int):void { this.row_size = row_size; }
		public function setColSize(col_size:int):void { this.col_size = col_size;  }
		public function setMine(mine:int):void        { this.mine = mine; }
		public function setImgSize(img_size:int):void { this.img_size = img_size; }
		
		/*
		 * その他の関数群
		 */
		// 残りのマス数を数える
		public function getRemBlocks():int { return this.row_size * this.col_size - this.mine; }
		
	}
	
}