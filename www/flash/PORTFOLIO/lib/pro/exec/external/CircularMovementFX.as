package pro.exec.external 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import frocessing.display.F5MovieClip2D;
	import gs.easing.Expo;
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author saz
	 */
	public class CircularMovementFX extends F5MovieClip2D 
	{
		private var __angle:int = -90 ;
		private var __sizeRect:Rectangle ;
		
		private var __percent:Number;
		private var __bmp:Bitmap;
		private var __opened:Boolean;
		
		public function get dimensions():Rectangle 
		{
			return __sizeRect ;
		}
		
		public function set dimensions(value:Rectangle):void 
		{
			__sizeRect = value ;
		}
		
		public function get bitmapData():BitmapData 
		{
			return __bmp.bitmapData ;
		}
		
		public function set bitmapData(value:BitmapData):void 
		{
			__bmp = setBitmapFromBitmapData(value) ;
		}
		private function setBitmapFromBitmapData(bmpData:BitmapData):Bitmap
		{
			return new Bitmap(bmpData, 'auto', true) ;
		}
		public function CircularMovementFX(bitmapData:BitmapData = null, dimensions:Rectangle = null) 
		{
			if (bitmapData) {
				this.bitmapData = bitmapData ;
				if (dimensions) {
					this.dimensions = dimensions ;
				}else {
					this.dimensions = new Rectangle(0,0,bitmapData.width, bitmapData.height) ;
				}
			}else {
				if (dimensions) {
					this.dimensions = dimensions ;
				}else {
					
				}
			}
		}
		
		public function setup():void 
		{
			initialSettings() ;
		}
		
		private function initialSettings():void 
		{
			size(__sizeRect.width, __sizeRect.height) ;
			scrollRect = __sizeRect ;
			smooth() ;
			noLoop() ;
			colorMode(RGB, 255, 255, 255);
			background(0,0,0,0) ;
			noStroke();
		}
		
		///////////////// START
		public function start(closure:Function = null, ...args:Array):void 
		{
			startSettings() ;
			TweenLite.killTweensOf(this) ;
			TweenLite.to(this, .45, { ease:Expo.easeInOut, percent:100, onUpdate:function():void {
				Qdraw(__percent) ;
			},onComplete:function():void {
				if (closure is Function) closure.apply(null, args) ;
			}}) ;
		}
		private function startSettings():void 
		{
			__percent = 0 ;
		}
		///////////////// KILL
		public function kill(closure:Function = null, ...args:Array):void 
		{
			TweenLite.killTweensOf(this) ;
			killSettings() ;
			TweenLite.to(this, .45, { ease:Expo.easeInOut,  percent:0, onUpdate:function():void {
				Pdraw(__percent) ;
			},onComplete:function():void {
				if (closure is Function) closure.apply(null, args) ;
			}}) ;
		}
		private function killSettings():void 
		{
			
		}
		
		////////////// DRAW AT START
		public function Qdraw(pct:Number):void {
			pct /= 100 ;
			var r:Rectangle = new Rectangle(0, 0, __sizeRect.width, __sizeRect.height) ;
			var w:int = r.width ;
			var h:int = r.height ;
			var center:Point = new Point(int(w >> 1), int(h >> 1)) ;
			var max:Number = Math.max(w, h) ;
			var min:Number = Math.min(w, h) ;
			var diameter:Number =  Math.sqrt((min*min) + (max*max)) ;
			fg.beginDraw() ;
			fg.clear() ;
			beginBitmapFill(__bmp.bitmapData) ;


			drawArc(center.x, center.y, diameter/2, diameter/2, radians(__angle), radians(__angle + 360 * pct), true) ;

			endFill() ;
			fg.endDraw() ;
        }
		////////////// DRAW AT KILL
        public function Pdraw(pct:Number):void {
			pct /= 100 ;
			var r:Rectangle = new Rectangle(0, 0, __sizeRect.width, __sizeRect.height) ;
			var w:int = r.width ;
			var h:int = r.height ;
			var center:Point = new Point(int(w >> 1), int(h >> 1)) ;
			var max:Number = Math.max(w, h) ;
			var min:Number = Math.min(w, h) ;
			var diameter:Number =  Math.sqrt((min*min) + (max*max)) ;
			fg.beginDraw() ;
			fg.clear() ;
			beginBitmapFill(__bmp.bitmapData) ;

			drawArc(center.x, center.y, diameter/2, diameter/2, radians( __angle + 360 * - pct), radians(__angle) , true) ;

			endFill() ;
			fg.endDraw() ;
        }
		
		public function get percent():Number 
		{
			return __percent;
		}
		
		public function set percent(value:Number):void 
		{
			__percent = value;
		}
	}

}