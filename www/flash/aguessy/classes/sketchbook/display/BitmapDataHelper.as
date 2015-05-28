package sketchbook.display{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	
	/**
	 * ビットマップ操作のAPIを提供するヘルパークラスです。
	 * 
	 * @see flash.display.BitmapData
	 */
	public class BitmapDataHelper{
		private var _target:BitmapData
		private var _capture:BitmapData
		
		private static var _t_bmd:BitmapData = new BitmapData(1,1,false,0x000000);
		private static var _t_bmd32:BitmapData = new BitmapData(1,1,true,0x00000000);
		private static var _t_mat:Matrix = new Matrix(1,0,0,1,0,0);
		private static var _t_rect:Rectangle = new Rectangle(0,0,1,1);

		public function BitmapDataHelper(bitmapData:BitmapData)
		{
			_target = bitmapData
		}
		
		public function get target():BitmapData
		{
			return _target
		}
		
		public function set target(bitmapData:BitmapData):void
		{
			_target = bitmapData
		}
		
		public function setPixel(x:int, y:int, color:uint, blendMode:String="normal"):void
		{
			if(blendMode=="normal"){
				_target.setPixel(x,y,color)
			}else{
				_t_bmd.setPixel(0,0,color);
				_t_mat.tx = x
				_t_mat.ty = y
				_target.draw(_t_bmd,_t_mat,null,blendMode);
			}
		}
		
		public function setPixel32(x:int, y:int, color:uint, blendMode:String="normal"):void
		{
			if(blendMode=="normal"){
				_target.setPixel32(x,y,color)
			}else{
				_t_bmd32.fillRect(_t_rect, color)
				_t_mat.tx = x
				_t_mat.ty = y
				_target.draw(_t_bmd32,_t_mat,null,blendMode);
			}
		}
		
		/**
		 * 指定範囲の平均色を求める
		 */
		public function averageColor(rect:Rectangle=null):void
		{
			throw new Error("not yet implemented");
		}
		
		/**
		 * 指定範囲の平均色を求める
		 */
		public function averageColor32(rect:Rectangle=null):void
		{
			throw new Error("not yet implemented");
		}
		
		
		/** 
		 * ビットマップを単色で塗りつぶすBitmapData.fillRectの簡易版です。
		 * 
		 * @param color 色を示す数字。
		 * 
		 * @see flash.display.BitmapData#fillRect()
		 */
		public function fill(color:uint):void
		{
			_target.fillRect(_target.rect, color);
		}
		
		
		public function colorTransform(colt:ColorTransform):void
		{
			_target.colorTransform(_target.rect, colt);
		}
		
		
		/** 
		 * ビットマップ全体にBlurFilterを適用します。
		 * 
		 * @param blurX 水平方向のブラー
		 * @param blurY 垂直方向のブラー
		 * @param quality ブラーのクオリティ
		 * 
		 * @see flash.display.BitmapData#applyFilter
		 * @see flash.filters.BlurFilter
		 */
		public function blur(blurX:Number=4, blurY:Number=4, quality:uint=1):void
		{
			var bf:BlurFilter = new BlurFilter(blurX, blurY, quality);
			_target.applyFilter(_target, _target.rect, new Point(0,0), bf);
		}
		
		
		/** 
		 * ビットマップにモザイク処理を加えます。 
		 * 
		 * @param size モザイクの大きさです。
		 */
		public function mosaic(size:Number):void
		{
			var nsize:Number = 1 / size;
			
			var smallBmd:BitmapData = new BitmapData(Math.floor(_target.width*nsize),Math.floor(_target.height*nsize),true,0x000000);
			var mat:Matrix = new Matrix(nsize,0,0,nsize,0,0);
			smallBmd.draw(_target, mat, null, null, null, true);
			
			mat = new Matrix(size,0,0,size,0,0);
			_target.draw(smallBmd, mat, null, null, null, true);
			
			smallBmd.dispose()
		}
		
		
		
		
		/** 
		 * 現在の画像をキャプチャーして、一時保存します。
		 * 
		 * @return 現在の画像のコピー
		 */
		public function capture():BitmapData
		{
			if(_capture)
				_capture.dispose()
			
			_capture = _target.clone()
			return _capture
		}
		
		/** 
		 * ビットマップを最後にキャプチャーした状態に戻します 
		 */
		public function restore():void
		{
			_target.copyPixels(_capture, _capture.rect, new Point(0,0));
		}
		
		/** 
		 * ビットマップをスクロールさせます。
		 * 
		 * @param x 水平方向のスクロール量
		 * @param y 垂直方向のスクロール量
		 * @param loop 画面外にいった部分を反対側に折り返すかどうか
		 * 
		 * @see flash.display.BitmapData#scroll()
		 */
		public function scroll(x:Number, y:Number, loop:Boolean=false):void
		{
			if(loop==false)
			{
				_target.scroll(x,y)
			}else{
				if(x!=0)
					loopScrollX(x)
				if(y!=0)
					loopScrollY(y)
			}
		}
		
		private function loopScrollY(x:Number):void
		{
			var w:Number = Math.abs(x)
			var tempBmd:BitmapData = new BitmapData( w, _target.height, _target.transparent, 0x000000 );
			if(x<0){
				tempBmd.copyPixels(_target, new Rectangle(0,0,w,_target.height),new Point(0,0));
				_target.scroll(x,0)
				_target.copyPixels( tempBmd, new Rectangle(0,0,tempBmd.width, tempBmd.height), new Point(_target.width-w,0));
			}else{
				
			}
		}
		
		private function loopScrollX(y:Number):void
		{
			if(y<0){
				
			}else{
				
			}
		}
	}
}