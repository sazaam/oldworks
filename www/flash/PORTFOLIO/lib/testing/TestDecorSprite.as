package testing 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import gs.easing.Expo;
	import gs.plugins.BezierPlugin;
	import gs.plugins.TweenPlugin;
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author saz
	 */
	public class TestDecorSprite extends Sprite
	{
		private var twParams:Object;
		private var __oldPoint:Point;
		private var __percent:Number;
		private var __sizeRect:Rectangle;
		private var radToDeg:Number = 180.0 / Math.PI ;
		private var degToRad:Number = 180.0 / Math.PI ;
		private var __output:Bitmap;
		private var __offTarget:Shape;
		
		// OUTSIDE PARAMS
		private const ANGLE:int = -90 ;
		private const X:int = 100 ;
		private const Y:int = 100 ;
		private var __outputBmpData:BitmapData;
		
		
		public function TestDecorSprite() 
		{
			TweenPlugin.activate([BezierPlugin]) ;
			trace('YO')
			__sizeRect = new Rectangle(100, 100, 600, 200) ;
			__outputBmpData = new BitmapData(__sizeRect.width, __sizeRect.height, true , 0x0 ), 'auto', true
			__output = new Bitmap(__outputBmpData.clone()) ;
			addChild(__output) ;
			//__offTarget.x = X ;
			//__offTarget.y = Y ;
			
			addEventListener(Event.ADDED_TO_STAGE, init) ;
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			setup() ;
			stage.addEventListener(MouseEvent.CLICK, onClicked) ;
		}
		private function onClicked(e:MouseEvent):void 
		{
			trace("connardo")
			setup() ;
		}
		public function setup():void 
		{
			trace('starting...') ;
			__percent = 0 ;
			
			__offTarget = new Shape() ;
			__offTarget.alpha = .3 ;
			__offTarget.graphics.clear() ;
			__oldPoint = null ;
			TweenLite.killTweensOf(twParams) ;
			//stage.quality = 1 ;
			__output.bitmapData = __outputBmpData.clone() ;
			__output.bitmapData.unlock() ;
			TweenLite.to(this, .8, { ease:Expo.easeOut, percent:100, onUpdate:function():void {
				draw() ;
			}, onComplete:function():void {
				__output.bitmapData.lock() ;
				//stage.quality = 3 ;
			}}) ;
        }
		
        public function draw():void 
		{
            
			var r:Rectangle = new Rectangle(0, 0, __sizeRect.width, __sizeRect.height) ;
			var w:int = r.width ;
			var h:int = r.height ;
			var center:Point = new Point(int(w >> 1), int(h >> 1)) ;
			
			__offTarget.graphics.beginFill(0x2A2A2A) ;
			__offTarget.graphics.moveTo(center.x, center.y) ;
			
			var angle:Number = (percent/100) * Math.PI *2 ;
			var deg:int = Math.ceil(degrees(angle)) ;
			__oldPoint = Boolean(__oldPoint) ? __oldPoint : new Point(center.x, r.y) ;
			var focus:Point = getPointFromCenter(deg , r, ANGLE) ;
			
			var newPoint:Point = focus ;
			if (deg >= 358) {
				__offTarget.graphics.drawRect(r.x, r.y, r.width, r.height) ;
			}else if (deg >= 45 * 7) {
				__offTarget.graphics.lineTo(center.x, r.y) ;
				__offTarget.graphics.lineTo(r.width, r.y) ;
				__offTarget.graphics.lineTo(r.width, r.height) ;
				__offTarget.graphics.lineTo(r.x, r.height) ;
				__offTarget.graphics.lineTo(r.x, r.y) ;
				newPoint.y = r.y ;
			}else if (deg >= 45 * 5) {
				__offTarget.graphics.lineTo(center.x, r.y) ;
				__offTarget.graphics.lineTo(r.width, r.y) ;
				__offTarget.graphics.lineTo(r.width, r.height) ;
				__offTarget.graphics.lineTo(r.x, r.height) ;
				newPoint.x = r.x ;
			}else if (deg >= 45 * 3) {
				__offTarget.graphics.lineTo(center.x, r.y) ;
				__offTarget.graphics.lineTo(r.width, r.y) ;
				__offTarget.graphics.lineTo(r.width, r.height) ;
				newPoint.y = r.height ;
			}else if (deg >= 45) {
				__offTarget.graphics.lineTo(center.x, r.y) ;
				__offTarget.graphics.lineTo(r.width, r.y) ;
				newPoint.x = r.width ;
			}else if (deg < 45) {
				__offTarget.graphics.lineTo(center.x, r.y) ;
				newPoint.y = r.y ;
			}
			if (deg < 360) __offTarget.graphics.lineTo(newPoint.x, newPoint.y) ;
			
			__offTarget.graphics.endFill() ;
			
			render() ;
			//__output.bitmapData.dispose() ;
			__oldPoint = newPoint ;
        }
		
		private function render():void 
		{
			__output.bitmapData.draw(__offTarget) ;
		}
		
		private function getPointFromCenter(angle:Number, r:Rectangle, startAngle:Number, center:Point = null):Point 
		{
			var p:Point = new Point() ;
			if (!Boolean(center is Point)) center = new Point(r.width >> 1, r.height >> 1) ;
			
			p.x = int(center.x + (Math.cos(radians(startAngle + angle))*(r.width/2))) ;
			p.y = int(center.y + (Math.sin(radians(startAngle + angle))*(r.height/2))) ;
			
			
			return  p ;
		}
		
		public function get percent():Number 
		{
			return __percent;
		}
		
		public function set percent(value:Number):void 
		{
			__percent = value;
		}
		
		//////////////// HELPERS
		public function degrees( rad:Number ):Number
		{
			return radToDeg * rad ;
		}
		public function radians( deg:Number ):Number
		{
			return degToRad * deg ;
		}
	}

}