package testing 
{
	import flash.display.Bitmap;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import frocessing.display.F5MovieClip2DBmp;
	import frocessing.math.FMath;
	import frocessing.shape.FShape;
	import gs.easing.Expo;
	import gs.easing.Quad;
	import gs.easing.Sine;
	import gs.plugins.BezierPlugin;
	import gs.plugins.TweenPlugin;
	import gs.TweenLite;
	import tools.geom.Cyclic;
	
	/**
	 * ...
	 * @author saz
	 */
	public class TestDecor extends F5MovieClip2DBmp 
	{
		private var __oldPoint:Point;
		private var __percent:Number;
		private var __sizeRect:Rectangle;
				private var n:int = 12;
		private static const URL:String = '../img/works/drawings_visual.png' ;
		private static var ANGLE:int = -90 ;
		private var __bmp:Bitmap ;
		private var __functionStart:Function;
				private var alphas:Array = [];
		
		public function TestDecor() 
		{
			__sizeRect = new Rectangle(100, 100, 200, 240 ) ;
			__functionStart = start ;
			x = 200 ; 
			y = 200 ;
			
			stage.scaleMode = 'noScale' ;
		}
		public function setup():void 
		{
			size(__sizeRect.width, __sizeRect.height) ;
			smooth() ;
			
			noLoop() ;
			radius = 50 ;
			colorMode(RGB, 255, 255, 255);
			background(51, 51, 51, 1) ;
			rect(0,0, 200, 240) ;
			noStroke();
			//makeAlphas();
			filters = [
				new DropShadowFilter(4, 90, 0x0, .75, 25, 45, 1, 3, true), 
				new DropShadowFilter(1, 90, 0xFFFFFF, .45, 1, 1, 1, 3)
			]
			//drawLoader() ;
			__functionStart = start ;
        }
		
		
		private function start():void 
		{
			startSettings() ;
			TweenLite.killTweensOf(this) ;
			var loader:Loader = new Loader() ;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete) ;
			loader.load(new URLRequest(URL)) ;
		}
		private function kill():void 
		{
			
			TweenLite.killTweensOf(this) ;
			
			__percent = 0 ;
			__functionStart = start ;
			TweenLite.to(this, .45, { ease:Expo.easeInOut ,percent:100, onUpdate:function():void {
				Pdraw(__percent) ;
			},onComplete:function():void {
				__bmp = null ;
				background(51, 51, 51, 1) ;
			}}) ;
		}
		private function startSettings():void 
		{
			trace('Hey') ;
			__percent = 0 ;
			__oldPoint = null ;
			__functionStart = kill ;
		}
		
		private function onLoadComplete(e:Event):void 
		{
			var loader:Loader = e.target.loader ;
			loader.removeEventListener(e.type, arguments.callee) ;
			loader.removeEventListener(ProgressEvent.PROGRESS, addDraw) ;
			__bmp = Bitmap(e.target.content) ;
			__bmp.smoothing = true ;
			startSettings() ;
			TweenLite.to(this, .45, { ease:Expo.easeInOut, percent:100, onUpdate:function():void {
				Qdraw(__percent) ;
			},onComplete:function():void {
				
			}}) ;
		}
		
		public function Qdraw(pct:Number):void {
			var r:Rectangle = new Rectangle(0, 0, __sizeRect.width, __sizeRect.height) ;
			var w:int = r.width ;
			var h:int = r.height ;
			var center:Point = new Point(int(w >> 1), int(h >> 1)) ;
			fg.beginDraw() ;
			beginBitmapFill(__bmp.bitmapData) ;
			moveTo(center.x, center.y) ;
			
			var angle:Number = (pct/100) * PI *2 ;
			var deg:int = ceil(degrees(angle)) ;
			__oldPoint = Boolean(__oldPoint) ? __oldPoint : getPointFromCenter(0, r, ANGLE) ;
			var focus:Point = getPointFromCenter(deg , r, ANGLE) ;
			
			var newPoint:Point = focus ;
			if (deg >= 350) {
				drawRect(r.x, r.y, r.width, r.height) ;
			}else if (deg >= 45 * 7) {
				lineTo(center.x, r.y) ;
				lineTo(r.width, r.y) ;
				lineTo(r.width, r.height) ;
				lineTo(r.x, r.height) ;
				lineTo(r.x, r.y) ;
				newPoint.y = r.y ;
			}else if (deg >= 45 * 5) {
				lineTo(center.x, r.y) ;
				lineTo(r.width, r.y) ;
				lineTo(r.width, r.height) ;
				lineTo(r.x, r.height) ;
				newPoint.x = r.x ;
			}else if (deg >= 45 * 3) {
				lineTo(center.x, r.y) ;
				lineTo(r.width, r.y) ;
				lineTo(r.width, r.height) ;
				newPoint.y = r.height ;
			}else if (deg >= 45) {
				lineTo(center.x, r.y) ;
				lineTo(r.width, r.y) ;
				newPoint.x = r.width ;
			}else if (deg < 45) {
				lineTo(center.x, r.y) ;
				newPoint.y = r.y ;
			}
			if (deg < 360) lineTo(newPoint.x, newPoint.y) ;
			
			
			endFill() ;
			fg.endDraw() ;
			__oldPoint = newPoint ;
        }
        public function Pdraw(pct:Number):void {
			var r:Rectangle = new Rectangle(0, 0, __sizeRect.width, __sizeRect.height) ;
			var w:int = r.width ;
			var h:int = r.height ;
			var center:Point = new Point(int(w >> 1), int(h >> 1)) ;
			fg.beginDraw() ;
			beginFill(0x333333, 1 ) ;
			
			moveTo(center.x, center.y) ;
			
			var angle:Number = (pct/100) * PI *2 ;
			var deg:int = ceil(degrees(angle)) ;
			__oldPoint = Boolean(__oldPoint) ? __oldPoint : getPointFromCenter(0, r, ANGLE) ;
			var focus:Point = getPointFromCenter(360 - deg , r, ANGLE) ;
			
			var newPoint:Point = focus ;
			if (deg >= 350) {
				drawRect(r.x, r.y, r.width, r.height) ;
			}else if (deg >= 45 * 7) {
				lineTo(center.x, r.y) ;
				lineTo(r.x, r.y) ;
				lineTo(r.x, r.height) ;
				lineTo(r.width, r.height) ;
				lineTo(r.width, r.y) ;
				newPoint.y = r.y ;
			}else if (deg >= 45 * 5) {
				lineTo(center.x, r.y) ;
				lineTo(r.x, r.y) ;
				lineTo(r.x, r.height) ;
				lineTo(r.width, r.height) ;
				newPoint.x = r.width ;
			}else if (deg >= 45 * 3) {
				lineTo(center.x, r.y) ;
				lineTo(r.x, r.y) ;
				lineTo(r.x, r.height) ;
				newPoint.y = r.height ;
			}else if (deg >= 45) {
				lineTo(center.x, r.y) ;
				lineTo(r.x, r.y) ;
				newPoint.x = r.x ;
			}else if (deg < 45) {
				lineTo(center.x, r.y) ;
				newPoint.y = r.y ;
			}
			if (deg < 360) lineTo(newPoint.x, newPoint.y) ;
			
			
			endFill() ;
			fg.endDraw() ;
			__oldPoint = newPoint ;
        }
		
		private function getPointFromCenter(angle:Number, r:Rectangle, startAngle:Number, center:Point = null):Point 
		{
			var p:Point = new Point() ;
			if (!Boolean(center is Point)) center = new Point(r.width >> 1, r.height >> 1) ;
			
			p.x = int(center.x + (cos(radians(startAngle + angle))*(r.width/2))) ;
			p.y = int(center.y + (sin(radians(startAngle + angle))*(r.height/2))) ;
			
			
			return  p ;
		}
        public function mousePressed():void {
			__functionStart() ;
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