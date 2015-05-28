package of.app.required.loading
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import frocessing.display.F5MovieClip2D;
	import of.app.required.loading.E.LoadEvent;
	import of.app.required.loading.E.LoadProgressEvent;
	import of.app.required.loading.I.ILoaderGraphics;
	import of.app.required.resize.StageProxy;
	import of.app.XUser;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.tweens.ITween;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class AribitraryLoaderGraphics implements ILoaderGraphics
	{
		private var stageDims:Point;
		private var target:Sprite ;
		private var diameter:Number ;
		private var circle:Sprite;
		private var progressZone:F5MovieClip2D ;
		private var midWidth:Number;
		private var midHeight:Number;
		
		public function AribitraryLoaderGraphics() 
		{
			target =  XUser.target ;
		}
		
		public function start(closure:Function = null, ...args:Array):void
		{
			stageDims = StageProxy.init(target.stage) ;
			trace("Loadingz Started !!!") ;
			
			midWidth = int(stageDims.x >> 1) ;
			midHeight = int(stageDims.y >> 1) ;
			diameter = 50 ;
			circle = new Sprite() ;
			circle.name = 'circle' ;
			progressZone = new F5MovieClip2D() ;
			progressZone.name = 'progressZone'
			circle.x = midWidth ;
			circle.y = midHeight ;
			
			circle.graphics.lineStyle(4, 0xD4D0C8, 1, false, "normal", "round", "round") ;
			circle.graphics.drawCircle(0, 0, diameter) ;
			circle.graphics.endFill() ;
			
			circle.addChild(progressZone ) ;
			target.addChild(circle) ;
			twStart.apply(this, [closure].concat(args)) ;
		}
		
		public function kill(closure:Function = null, ...args:Array):void {
			trace("Loadingz Ended !!!") ;
			var f:Function = function():void {
				var tw:ITween = BetweenAS3.to(circle, { alpha:0 }, .5) ;
				tw.onComplete = function():void 
				{
					closure.apply(closure, [].concat(args)) ;
					target.removeChild(circle) ;
				}
				tw.play() ;
			}
			twKill(f) ;
		}
		
		private function drawProgress(percent:Number):void
		{
			var rad:Number = percent * (Math.PI * 2) ;
			var begin:Number = -(Math.PI * .5) ;
			progressZone.clear() ;
			progressZone.lineStyle(4, 0xFF0000,1, true,'none',CapsStyle.SQUARE,JointStyle.MITER,5 ) ;
			progressZone.moveTo(0,-(diameter)) ;
			progressZone.arcTo(0, 0, diameter, diameter, 0, rad , begin) ;
			progressZone.endFill() ;
			progressZone.smooth() ;
		}
		private function twReset():void
		{
			progressZone.clear() ;
		}
		private function twStart(closure:Function, ...args:Array):void
		{
			var tw:ITween = BetweenAS3.to(progressZone, { alpha:1 }, .5) ;
			tw.onComplete = function():void 
			{
				closure.apply(closure, [].concat(args)) ;
			}
			tw.play() ;
		}
		private function twKill(closure:Function, ...args:Array):void
		{
			var tw:ITween = BetweenAS3.to(progressZone, { alpha:0 }, .5) ;
			tw.onComplete = function():void 
			{
				closure.apply(closure, [].concat(args)) ;
			}
			tw.play() ;
		}
		/////////////////////////////////////////////////// ALL
		public function onALLOpen(e:Event):void {
			
		}
		public function onALLProgress(e:ProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
			drawProgress(percent) ;
		}
		public function onALLLoadProgress(e:LoadProgressEvent):void {
			//trace("ALL Progress", " >> ", e.bytesLoaded, e.bytesTotal, e.bytesLoaded / e.bytesTotal )
		}
		public function onALLLoadOpen(e:LoadEvent):void {
			//trace("ALL Open", " >> ", e.index )
		}
		public function onALLLoadComplete(e:LoadEvent):void {
			//trace("ALL Complete", " >>", e.index)
		}
		public function onALLComplete(e:Event):void {
			//twKill() ;
		}
		/////////////////////////////////////////////////// ZIP
		public function onZIPOpen(e:Event):void {
			twReset() ;
			//twStart() ;
		}
		public function onZIPProgress(e:ProgressEvent):void {
			
		}
		public function onZIPLoadProgress(e:LoadProgressEvent):void {
			//var percent:Number = e.bytesLoaded / e.bytesTotal ;
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
			drawProgress(percent) ;
		}
		public function onZIPComplete(e:Event):void {
			//twKill() ;
		}
		/////////////////////////////////////////////////// IMG
		public function onIMGOpen(e:Event):void {
			twReset() ;
			//twStart() ;
		}
		public function onIMGProgress(e:ProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
			drawProgress(percent) ;
		}
		public function onIMGLoadProgress(e:LoadProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
		}
		public function onIMGComplete(e:Event):void {
			//twKill() ;
		}
		/////////////////////////////////////////////////// FONTS
		public function onFONTSOpen(e:Event):void {
			//twReset() ;
			//twStart() ;
		}
		public function onFONTSProgress(e:ProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
			drawProgress(percent) ;
		}
		public function onFONTSComplete(e:Event):void {
			//twKill() ;
		}
		/////////////////////////////////////////////////// SWF
		public function onSWFOpen(e:Event):void {
			//twReset() ;
			//twStart() ;
		}
		public function onSWFProgress(e:ProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
			drawProgress(percent) ;
		}
		public function onSWFComplete(e:Event):void {
			//twKill() ;
		}
		/////////////////////////////////////////////////// XML
		public function onXMLOpen(e:Event):void {
			//twReset() ;
			//twStart() ;
		}
		public function onXMLProgress(e:ProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
			drawProgress(percent) ;
		}
		public function onXMLComplete(e:Event):void {
			//twKill() ;
		}
	}
}