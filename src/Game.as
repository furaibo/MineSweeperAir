package 
{
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author jun
	 */
	public class Game
	{
		
		// メンバ変数
		private var o:Option;
		private var gameboard:Array;
		
		// コンストラクタ
		public function Game(option:Option):void
		{	
			// 初期化
			var i:int;
			var j:int;
			var m:int;
			var n:int;
			var tmp:String;
			
			// 設定の保存
			o = option;
			
			// 2次元配列の作成
			var minemap:Array = new Array(o.getRowSize());
			var boardmap:Array = new Array(o.getRowSize());
			for ( i = 0; i < o.getRowSize(); i++ ) {
				minemap[i] = new Array(o.getColSize());
				boardmap[i] = new Array(o.getColSize());
			}
			
			// 2次元配列の初期化
			for ( i = 0; i < o.getRowSize(); i++ ) {
				for ( j = 0; j < o.getColSize(); j++ ) {
					minemap[i][j] = 0;
				}
			}
			
			// 地雷配置を決定する
			for ( i = 0; i < o.getMine(); i++ ) {
				m = Math.random() * o.getRowSize();
				n = Math.random() * o.getColSize();
				if ( minemap[m][n] == 0 ) {
					minemap[m][n] = 1;
				} else {
					i--;
				};
			}
			
			// マスの表示を決定する
			for ( i = 0; i < o.getRowSize(); i++ ) {
				for ( j = 0; j < o.getColSize(); j++ ) {
					var mine_count:int = 0;
					if ( minemap[i][j] == 1 ) {
						boardmap[i][j] = "*";
					} else {
						boardmap[i][j] = this.countMines(minemap, i, j)
					}
					
				}
			}
			
			// メンバ変数gameboardの初期化
			this.gameboard = new Array(o.getRowSize());
			for ( i = 0; i < o.getRowSize(); i++ ) {
				this.gameboard[i] = new Array(o.getColSize());
			}
			
			// ゲーム盤の構成
			for ( i = 0; i < o.getRowSize(); i++ ) {
				for ( j = 0; j < o.getColSize(); j++ ) {
					
					// ゲーム盤のマスを取得
					tmp = boardmap[i][j];
					
					// Blockインスタンスの作成
					this.gameboard[i][j] = new Block(String(tmp));
					
				}
			}
			
			// 盤面のトレース出力(テスト用)
			//outputTest(minemap, boardmap, o);
			
		}
		
		
		// 地雷をカウントする
		private function countMines(minemap:Array, i:int, j:int):String
		{
			// 変数
			var count:int = 0;
			
			// 上段
			if ( !(i == 0) ) {
				if ( !(j == 0) && minemap[i - 1][j - 1] ) { count++; }
				if ( minemap[i - 1][j] ) { count++;  }
				if ( !(j == o.getColSize() - 1) && minemap[i - 1][j + 1] ) { count++; }
			}
			
			// 中段
			if ( !(j == 0) && minemap[i][j - 1] ) { count++; }
			if ( minemap[i][j] ) { count++; }
			if ( !(j == o.getColSize() - 1) && minemap[i][j + 1] ) { count++; }
						
			// 下段
			if ( !(i == o.getRowSize() - 1) ) {
				if ( !(j == 0) && minemap[i + 1][j - 1] ) { count++; }
				if ( minemap[i + 1][j] ) { count++; }
				if ( !(j == o.getColSize() - 1) && minemap[i + 1][j + 1] ) { count++; }
			}
			
			// 戻り値
			return String(count);
			
		}
		
		
		// 無印のマスをオープンした時に、一挙にオープンするマスの集合の座標を求める
		public function searchOpenBlocks(row:int, col:int):Array
		{
			
			// 変数
			var i:int;
			var j:int;
			var k:int;
			var l:int;
			var x:int;
			
			// 配列の初期化
			var open:Array = new Array();
			var zero:Array = new Array();
			for ( i = 0; i < o.getRowSize(); i++ ) {
				open[i] = new Array(o.getColSize());
				zero[i] = new Array(o.getColSize());
			}
			for ( i = 0; i < o.getRowSize(); i++ ) {
				for ( j = 0; j < o.getColSize(); j++ ) {
					zero[i][j] = false;
					open[i][j] = false;
				}
			}
			
			// クリックしたマスはオープンとする
			zero[row][col] = true;
			open[row][col] = true;
			
			// 0のマスの探索
			// クリックしたマスの上側の行
			for ( i = row - 1; i >= 0; i-- ) {
				if ( gameboard[i][col].getLabel() == "0" ) {
					zero[i][col] = true;
				} else {
					break;
				}
			}
			
			// クリックしたマスの下側の行
			for ( i = row + 1; i < o.getRowSize(); i++ ) {
				if ( gameboard[i][col].getLabel() == "0" ) {
					zero[i][col] = true;
				} else {
					break;
				}
			}
			
			// クリックしたマスの右側の列
			for ( j = col + 1; j < o.getColSize(); j++ ) {
				if ( gameboard[row][j].getLabel() == "0" ) {
					zero[row][j] = true;
				} else {
					break;
				}
			}
			
			// クリックしたマスの左側の列
			for ( j = col - 1; j >= 0; j-- ) {
				if ( gameboard[row][j].getLabel() == "0" ) {
					zero[row][j] = true;
				} else {
					break;
				}
			}
			
			// 初期情報を元にオープンすべきマスを繰り返し探索する
			/*
			 *  この時、高速に処理を行えるように考慮はしていない
			 *  探索木を使って枝切りを工夫すれば高速化出来ると思う
			 */
			for ( x = 0; x < o.getRowSize() * o.getColSize() / 2; x++ ) {
				
				for ( i = 0; i < o.getRowSize(); i++ ) {
					for ( j = 0; j < o.getColSize(); j++ ) {
						if ( zero[i][j] ) {
							
							//　上方向
							for ( k = i - 1; k >= 0; k-- ) {
								if ( gameboard[k][j].getLabel() == "0" ) {
									zero[k][j] = true;
								} else {
									break;
								}
							}
							
							// 下方向
							for ( k = i + 1; k < o.getRowSize(); k++ ) {
								if ( gameboard[k][j].getLabel() == "0" ) {
									zero[k][j] = true;
								} else {
									break;
								}
							}
							
							// 右方向
							for ( l = j + 1; l < o.getColSize(); l++ ) {
								if ( gameboard[i][l].getLabel() == "0" ) {
									zero[i][l] = true;
								} else {
									break;
								}
							}
							
							// 左方向
							for ( l = j - 1; l >= 0; l-- ) {
								if ( gameboard[i][l].getLabel() == "0" ) {
									zero[i][l] = true;
								} else {
									break;
								}
							}
							
							// 斜め右上方向
							if ( !(i == 0) && !(j == o.getColSize() - 1) && gameboard[i - 1][j + 1].getLabel() == "0"  ) {
								zero[i - 1][j + 1] = true;
							}
							
							// 斜め左上方向
							if ( !(i == 0) && !(j == 0) && gameboard[i - 1][j - 1].getLabel() == "0" ) {
								zero[i - 1][j - 1] = true;
							}
							
							// 斜め右下方向
							if ( !(i == o.getRowSize() - 1) && !(j == o.getColSize() - 1) && gameboard[i + 1][j + 1].getLabel() == "0" ) {
								zero[i + 1][j + 1] = true;
							}
							
							// 斜め左下方向
							if ( !(i == o.getRowSize() - 1) && !(j == 0) && gameboard[i + 1][j - 1].getLabel() == "0" ) {
								zero[i + 1][j - 1] = true;
							}
							
						}
					}
				}
				
			}
			
			// 連続する0のマスの周辺をオープンすべきマスとして設定
			for (i = 0; i < o.getRowSize(); i++ ) {
				for (j = 0; j < o.getColSize(); j++ ) {
					if ( zero[i][j] ) {
						
						// 上段
						if ( !(i == 0) ) {
							if ( !(j == 0) ) { open[i - 1][j - 1] = true; }
							open[i - 1][j] = true;
							if ( !(j == o.getColSize() - 1) ) { open[i - 1][j + 1] = true; }
						}
						
						// 中段
						if ( !(j == 0) ) { open[i][j - 1] = true; }
						open[i][j] = true;
						if ( !(j == o.getColSize() - 1) ) { open[i][j + 1] = true; }
						
						// 下段
						if ( !(i == o.getRowSize() - 1) ) {
							if ( !(j == 0) ) { open[i + 1][j - 1] = true; }
							open[i + 1][j] = true;
							if ( !(j == o.getColSize() - 1) ) { open[i + 1][j + 1] = true; }
						}
						
					}
				}
			}
			
			// 戻り値
			return open;
			
		}
		
		
		// ゲッター
		public function getGameBoard():Array { return this.gameboard; }
		
		
		// 出力テスト用
		private function outputTest(minemap:Array, gameboard:Array, o:Option):void {
			
			// 変数
			var i:int;
			var j:int;
			var str:String
			
			// 出力
			for ( i = 0; i < o.getRowSize(); i++ ) {
				str = "";
				for ( j = 0; j < o.getColSize(); j++ ) {
					str += minemap[i][j];
					str += " ";
				}
				trace(str);
			}
			
			trace("");
			for ( i = 0; i < o.getRowSize(); i++ ) {
				str = "";
				for ( j = 0; j < o.getColSize(); j++ ) {
					str += gameboard[i][j];
					str += " ";
				}
				trace(str);
			}
			
		}
		
	}
	
}