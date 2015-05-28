package sketchbook.graphics
{
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	/**
	* Graphics.beginBitmapFillをクラス化したもの
	*/
	public class BitmapFill
	{
		
		public var bitmap:BitmapData
		public var matrix:Matrix
		public var repeat:Boolean
		public var smooth:Boolean
			
		public function BitmapFill(bitmap:BitmapData,matrix:Matrix=null,repeat:Boolean=true,smooth:Boolean=false)
		{
			this.bitmap = bitmap
			this.matrix = matrix
			this.repeat = repeat
			this.smooth = smooth
		}
			
		/**
		 * 対象のGraphicsインスタンスの、beginBitmapFillを実行します。
		 * 渡されるパラメーターはこのインスタンスのプロパティです。
		 */
		public function applySetting(g:Graphics):void
		{
			g.beginBitmapFill(bitmap,matrix,repeat,smooth)
		}
			
		public function clone():BitmapFill
		{
			return new BitmapFill(bitmap,matrix,repeat,smooth)
		}
	}
}