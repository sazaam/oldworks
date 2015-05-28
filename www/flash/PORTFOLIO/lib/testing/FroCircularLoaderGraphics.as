package testing 
{
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import frocessing.display.F5MovieClip2D;
	import frocessing.display.F5MovieClip3D;
	import frocessing.math.FMath;
	import gs.TweenLite;
	import tools.geom.Cyclic;
	
	/**
	 * ...
	 * @author saz
	 */
	public class FroCircularLoaderGraphics 
	{
//////////////////////////////////////////////////////// VARS
		private var target:Sprite ;
		private var diameter:Number ;
		private var circle:Sprite;
		private var progressZone:F5MovieClip2D ;
		private var midWidth:Number;
		private var midHeight:Number;
		//////////////////////////////////////////////////////// CTOR
		public function FroCircularLoaderGraphics(tg:Sprite) {
			target = tg ;
		}
		public function start():void
		{
			midWidth = int(target.stage.stageWidth >> 1) ;
			midHeight = int(target.stage.stageHeight >> 1) ;
			diameter = 50 ;
			circle = new Sprite() ;
			progressZone = new F5MovieClip2D() ;
			
			circle.x = midWidth ;
			circle.y = midHeight ;
			
			circle.graphics.lineStyle(5, 0xFF6600, .3, false, "normal", "round", "round") ;
			circle.graphics.drawCircle(0, 0, diameter) ;
			circle.graphics.endFill() ;
			
			circle.addChild(progressZone ) ;

			target.addChild(circle) ;
		}
		/////////////////////////////////////////////////// IMG
		public function onOpen(e:Event):void 
		{
			progressZone.clear() ;
			progressZone.z = -400 ;
			TweenLite.to(progressZone, .5, { alpha:1, z:0}) ;
		}
		public function onProgress(e:ProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
			drawProgress(percent) ;
		}
		private function drawProgress(percent:Number):void
		{
			var rad:Number = percent * (Math.PI * 2) ;
			var begin:Number = -(Math.PI * .5) ;
			progressZone.clear() ;
			progressZone.lineStyle(3, 0xFF6600,1, true,'none',CapsStyle.SQUARE,JointStyle.MITER,5 ) ;
			progressZone.moveTo(0, -(diameter)) ;
			progressZone.arcTo(0, 0, diameter, diameter, 0, rad , begin) ;
			progressZone.endFill() ;
			progressZone.smooth() ;
		}
		public function onComplete(e:Event):void {
			TweenLite.to(progressZone, .5, { alpha:0, z:400 }) ;
		}
	}	
}