/**
 * 
 * matrix formula is from http://psyark.jp/?entry=20060212001513
 * special thanks to Key
 * 
 */
package sketchbook.display
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.SpreadMethod;
	import flash.display.IBitmapDrawable;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	public class BitmapTextureUtil
	{
		//一時作業用
		private static var maskSp:Sprite = new Sprite();  //左上スプライト
		private static var bm:Bitmap = new Bitmap();
		private static var mat0:Matrix = new Matrix();
		private static var mat1:Matrix = new Matrix();
		
		public function draw():void
		{
			
		}
		
		/**
		 * 指定した３点がプロットされるように変形したビットマップを描画する
		 */
		 
		/**
		 * uvが変形前、xyが変形後
		 * var mtx0:Matrix = new Matrix(u1 - u0, v1 - v0, u2 - u0, v2 - v0, u0, v0); 
		 * var mtx1:Matrix = new Matrix(x1 - x0, y1 - y0, x2 - x0, y2 - y0, x0, y0); 
		 * mtx0.invert(); 
		 * mtx0.concat(mtx1);
		 * 
		 * 
		 */
		public static function drawTexture(	destBitmap:BitmapData, 
													source:BitmapData, 
													destPoints:Array, 
													sourcePoints:Array,
													colorTransform:ColorTransform = null,
													blendMode:String = null,
													clipRect:Rectangle = null,
													smoothing:Boolean = false
													):void
		{
			//変形Matrixを準備
			var s0:Point = sourcePoints[0];
			var s1:Point = sourcePoints[1];
			var s2:Point = sourcePoints[2];
			var d0:Point = destPoints[0];
			var d1:Point = destPoints[1];
			var d2:Point = destPoints[2];
			mat0.a = s1.x - s0.x;	
			mat0.b = s1.y - s0.y; 
			mat0.c = s2.x - s0.x; 
			mat0.d = s2.y - s0.y; 
			mat0.tx = s0.x; 
			mat0.ty = s0.y;
			mat1.a = d1.x - d0.x;
			mat1.b = d1.y - d0.y; 
			mat1.c = d2.x - d0.x; 
			mat1.d = d2.y - d0.y; 
			mat1.tx = d0.x; 
			mat1.ty = d0.y;
			mat0.invert();
			mat0.concat(mat1);
			
			//Source画像にマスクを充てる
			bm.bitmapData = source;
			bm.mask = maskSp;

			var g:Graphics = maskSp.graphics
			g.clear();
			g.beginFill(0x000000,1);
			g.moveTo(s0.x, s0.y);
			g.lineTo(s1.x, s1.y);
			g.lineTo(s2.x, s2.y);
			g.lineTo(s0.x, s0.y);
				
			destBitmap.draw(bm, mat0,colorTransform, blendMode, clipRect, smoothing);
		}
		
		
		/**
		 * 変形四角形をテクスチャーとして転送します。
		 * 時計回りに４点指定してください
		 */
		public static function drawQuadTexture(	destBitmap:BitmapData, 
													source:BitmapData, 
													destPoints:Array, 
													sourcePoints:Array,
													recursive:uint = 0,
													colorTransform:ColorTransform = null,
													blendMode:String = null,
													clipRect:Rectangle = null,
													smoothing:Boolean = false
													):void
		{
		}
	}
}