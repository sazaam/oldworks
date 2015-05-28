package pro.exec.external 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import frocessing.display.F5MovieClip2D;
	import gs.easing.Back;
	import gs.easing.Expo;
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author saz
	 */
	public class CircularMotionZoomFX extends F5MovieClip2D 
	{
		private var __sizeRect:Rectangle ;
		
		private var __bmp:Bitmap;
		private var __opened:Boolean;
		private var __shapes:Vector.<Shape>;
		
		
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
		public function CircularMotionZoomFX(bitmapData:BitmapData = null, dimensions:Rectangle = null) 
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
			var l:int = __shapes.length ;
			for(var i:int = 0 ; i< l ; i++){
				var shape:Shape = __shapes[i] ;
				TweenLite.killTweensOf(shape) ;
				shape.scaleX = shape.scaleY = 0 ;
				TweenLite.to(shape, .45, { ease:Back.easeInOut, scaleX: 3, scaleY: 3, delay: .2 + .2/l*i,  onUpdate:function():void {
					Qdraw() ;
				},onComplete:function():void {
					if (closure is Function) closure.apply(null, args) ;
				}}) ;
			} ;
		}
		
		private function startSettings():void 
		{
			__shapes = new Vector.<Shape>() ;
			for(var i:int = 0 ; i < 5 ; i++){
				var shape:Shape = __shapes[i] = new Shape() ;
				var coords:Point = getCoords(i) ;
				var locX:int = -coords.x >> 1 ;
				var locY:int = -coords.y >> 1
				shape.graphics.beginBitmapFill(__bmp.bitmapData, new Matrix(1, 0, 0, 1, locX ,locY)) ;
				shape.alpha = .3 ;
				shape.x = __sizeRect.width >> 1 ;
				shape.y = __sizeRect.height >> 1 ;
				shape.graphics.drawEllipse(locX, locY, coords.x, coords.y) ;
			}
		}
		 
		private function getCoords(n:int):Point 
		{
			var p:Point = new Point() ;
			var l:int = 5 ;
			var centerW:int = __sizeRect.width >> 1 ;
			var centerH:int = __sizeRect.height >> 1 ;
			p.x = centerW + centerW/l*n ;
			p.y = centerH + centerH/l*n ;
			return p ;
		};
		///////////////// KILL
		public function kill(closure:Function = null, ...args:Array):void 
		{
			var l:int = __shapes.length ;
			for(var i:int = 0 ; i< l ; i++){
				var shape:Shape = __shapes[(l-1)-i] ;
				TweenLite.killTweensOf(shape) ;
				TweenLite.to(shape, .45, { ease:Expo.easeOut, scaleX: 0, scaleY: 0, delay: .2 + .2/(l-i),  onUpdate:function():void {
					Qdraw() ;
				},onComplete:function():void {
					if (closure is Function) closure.apply(null, args) ;
				}}) ;
			} ;
		}
		private function killSettings():void 
		{
			//
		}
		
		public function Qdraw():void 
		{
			fg.beginDraw() ;
			fg.clear() ;
			beginBitmapFill(__bmp.bitmapData, null, false, true) ;
			
			var l:int = __shapes.length ;
			for(var i:int = 0 ; i < l ; i++){
				var sh:Shape = __shapes[i] ;
				var locX:int = sh.x - sh.width *.5 ;
				var locY:int = sh.y - sh.height *.5 ;
				drawEllipse(locX, locY, sh.width,  sh.height) ;
			}        
			endFill() ;
			fg.endDraw() ;
		}
	}

}