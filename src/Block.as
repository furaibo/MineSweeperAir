package 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author furaibo
	 */
	public class Block 
	{
		
		// メンバ変数
		private var label:String;		// ブロックのラベル
		private var img_path:String;	// 画像のパス
		private var open:Boolean;		// オープン済かどうか
		private var check:Boolean;		// チェック(旗マーク)が付いているか
		private var bitmap:Bitmap;		// Bitmapクラスのインスタンス
		
		// コンストラクタ
		public function Block(label:String):void
		{
			// メンバ変数の初期化
			this.label = label;
			this.open  = false;
			this.check = false;
			this.img_path = "";
		}
		
		// ゲッター
		public function getLabel():String   { return this.label; }
		public function getOpen():Boolean   { return this.open; }
		public function getCheck():Boolean  { return this.check; }
		
		// セッター
		public function setOpen():void { this.open = true; }
		
		
		/*
		 * その他の関数群
		 */
		// チェックされているかどうかのフラグを反転させる
		public function switchCheck():void { this.check = !this.check; }
		
		// 地雷かどうか判定
		public function getMineStatus():Boolean { return this.getLabel() == "*"; }
		
	}
	
}