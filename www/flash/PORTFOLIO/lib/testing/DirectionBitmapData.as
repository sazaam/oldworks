package testing 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author saz
	 */
	public class DirectionBitmapData extends BitmapData 
	{
		private var __dims:Rectangle;
		private var __source:IBitmapDrawable;
		static public const NORMAL:int = -1
		static public const X_AXIS_INVERTED:int = 1 ;
		static public const Y_AXIS_INVERTED:int = 2 ;
		
		
		public function DirectionBitmapData(src:IBitmapDrawable, mode:int = -1) 
		{
			__source = src ;
			__dims = __source as DisplayObject? DisplayObject(__source).getBounds(__dims) : new Rectangle(0,0,BitmapData(src).width, BitmapData(src).height) ;
			super(__dims.width, __dims.height, true, 0xFF6600) ;
			drawSource(mode) ;
		}
		public function drawSource(mode:int = -1):void 
		{
			var m:Matrix ; 
			switch(mode) {
				case X_AXIS_INVERTED:
					m = new Matrix(-1, 0, 0, 1, __dims.width, 0) ;
				break;
				case Y_AXIS_INVERTED:
					m = new Matrix(1, 0, 0, -1, 0, __dims.height) ;
				break;
				default :
					return draw(source, null, null, null, null, true) ;
				break ;
			}
			var temp:BitmapData = this.clone() ;
			temp.draw(__source, null, null, null, null, true) ;
			draw(temp, m) ;
		}
		public function toBitmap(pixelSnapping:String, smoothing:Boolean):Bitmap
		{
			return new Bitmap(this, pixelSnapping, smoothing) ; 
		}
		
		public function get source():IBitmapDrawable { return __source }
		public function set source(value:IBitmapDrawable):void { __source = value }
		
		public function get dimensions():Rectangle { return __dims }
		public function set dimensions(value:Rectangle):void { __dims = value }
		
	}
}