package enhancefro 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import frocessing.core.F5Graphics;
	import frocessing.core.F5Graphics2D;
	import frocessing.core.F5Graphics3D;
	import frocessing.display.F5MovieClip;
	import frocessing.display.F5MovieClip2D;
	import frocessing.display.F5MovieClip3D;
	import frocessing.math.FMath;
	
	/**
	 * ...
	 * @author ...
	 */
	
	public class BaseView
	{
		public static const BIDIMENSIONAL:String = '2D' ;
		public static const TRIDIMENSIONAL:String = '3D' ;
		private var __target:Sprite ;
		private var __w:Number ;
		private var __h:Number ;
		private var __halfw:Number ;
		private var __halfh:Number ;
		private var __renderer3D:F5Graphics3D;
		private var __renderer:F5Graphics;
		internal var __params__:Object = { } ;
		internal var __rest:Array ;
		private var __stage:Stage;
		
		public function BaseView() 
		{
			
		}
		
		///////////////////////////////////////////////////////////	2D
		public function prepare2D(tg:Sprite):F5Graphics2D
		{
			if (tg) {
				if (checkF5('2D', tg)) {
					__renderer2D = F5MovieClip2D(tg).fg ;
				}else {
					__renderer2D = new F5Graphics2D(tg.graphics, __w, __h) ;
				}
			}
			__renderer = __renderer2D ;
			return __renderer2D ;
		}
		
		
		///////////////////////////////////////////////////////////	3D
		public function prepare3D(tg:Sprite = null):F5Graphics3D
		{
			if (isNaN(__w) || isNaN(__h)) throw(new EvalError('A problem occured since width or height of BaseView is equal to NaN')) ;
			
			tg = tg || __target ;
			if (checkF5('3D', tg)) {
				__renderer3D = F5MovieClip3D(tg).fg ;
			}else {
				
				__renderer3D = new F5Graphics3D(tg.graphics, __w, __h) ;
			}
			__renderer = __renderer3D ;
			return __renderer3D ;
		}
		
		private function checkF5(type:String, tg:Sprite):Boolean
		{
			var b:Boolean ;
			if (type == TRIDIMENSIONAL) {
				b = (tg is F5MovieClip3D) ;
			}else {
				b = (tg is F5MovieClip2D) ;
			}
			return b ;
		}
		
		
		public function init(st:Stage, tg:Sprite = null):BaseView
		{
			__stage  = st ;
			if (tg) __target = tg ;
			return this ;
		}
		
		public function getDimensions(obj:Object):Point
		{
			if (obj is Stage) {
				return new Point(obj.stageWidth, obj.stageHeight) ;
			}else if (obj is Sprite) {
				return new Point(obj.width, obj.height) ;
			}
		}
		public function getHalfDimensions(obj:Object):Point
		{
			if (obj is Stage) {
				return new Point(obj.stageWidth * .5, obj.stageHeight* .5) ;
			}else if (obj is Sprite) {
				return new Point(obj.width* .5, obj.height* .5) ;
			}
		}
		public function centerCamera(x:Number, y:Number):Point
		{
			var p:Point = this.getHalfDimensions(stage) ;
			var ca:Number = -FMath.radians(45 / p.x * (x - p.x ) - 90) ;
			var cb:Number = FMath.radians(45 / p.y * (y - p.y )) ;
			__renderer.camera( p.x + 500 * Math.cos(ca), p.y + 500 * Math.sin(cb), 500 * Math.sin(ca), p.x, p.y, 0, 0, 1, 0);
			return p ;
		}

		
		
		public function get target():Sprite { return __target }
		public function set target(value:Sprite):void { __target = value }
		public function get w():Number { return __w }
		public function set w(value:Number):void { __w = int(value) }
		public function get h():Number { return __h }
		public function set h(value:Number):void { __h = int(value) }
		public function get renderer():F5Graphics { return __renderer }
		public function set renderer(value:F5Graphics ):void { __renderer = value }
		public function get stage():Stage { return __stage }
	}
}