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
	public class CircleSpawnFX extends F5MovieClip2D 
	{
		private var __sizeRect:Rectangle ;
		
		private var __percent:Number;
		private var __bmp:Bitmap;
		private var __opened:Boolean;
		
		public function CircleSpawnFX(bmpData:BitmapData, dimensions:Rectangle = null) 
		{
			if (dimensions) {
				__sizeRect = dimensions ;
			}else {
				__sizeRect.width = bmpData.width ;
				__sizeRect.height = bmpData.height ;
			}
			__bmp = new Bitmap(bmpData, 'auto', true) ;
			__bmp.smoothing = true ;
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
			TweenLite.to(this, .35, { ease:Expo.easeInOut, percent:100, onUpdate:function():void {
				Qdraw(__percent) ;
			},onComplete:function():void {
				if (Boolean(closure is Function))  closure.apply(null, args) ;
			}}) ;
		}
		private function startSettings():void 
		{
			__percent = 0 ;
			__oldPoint = null ;
		}
		///////////////// KILL
		public function kill(closure:Function = null, ...args:Array):void 
		{
			TweenLite.killTweensOf(this) ;
			killSettings() ;
			TweenLite.to(this, .25, { ease:Expo.easeInOut ,percent:0, onUpdate:function():void {
				Pdraw(__percent) ;
			},onComplete:function():void {
				background(0, 0, 0, 0) ;
				if (Boolean(closure is Function))  closure.apply(null, args) ;
			}}) ;
		}
		private function killSettings():void 
		{
			//__percent = 0 ;
			__oldPoint = null ;
		}
		////////////// DRAW
		public function Qdraw(pct:Number):void {
			pct /= 100 ;
			var r:Rectangle = new Rectangle(0, 0, __sizeRect.width, __sizeRect.height) ;
			var w:int = r.width ;
			var h:int = r.height ;
			var center:Point = new Point(int(w >> 1), int(h >> 1)) ;
			var max:Number = Math.max(w, h) ;
			var min:Number = Math.min(w, h) ;
			var diameter =  Math.sqrt((min*min) + (max*max)) ;
			fg.beginDraw() ;
			fg.clear() ;
			beginBitmapFill(__bmp.bitmapData) ;
			translate(center.x, center.y) ;
			ellipse(0,0,diameter*pct,diameter* pct) ;
			endFill() ;
			fg.endDraw() ;
		}
		public function Pdraw(pct:Number):void {
			pct /= 100 ;
			var r:Rectangle = new Rectangle(0, 0, __sizeRect.width, __sizeRect.height) ;
			var w:int = r.width ;
			var h:int = r.height ;
			var center:Point = new Point(int(w >> 1), int(h >> 1)) ;
			var max:Number = Math.max(w, h) >> 1;
			var min:Number = Math.min(w, h) >> 1;
			var diameter =  Math.sqrt((min*min) + (max*max)) ;
			fg.beginDraw() ;
			fg.clear() ;
			beginBitmapFill(__bmp.bitmapData) ;
			translate(center.x, center.y) ;
			ellipse(0,0,diameter*pct,diameter* pct) ;
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