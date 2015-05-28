package of.app.required.loading 
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import gs.TweenLite;
	import of.app.required.loading.E.LoadEvent;
	import of.app.required.loading.E.LoadProgressEvent;
	import of.app.required.loading.I.ILoaderGraphics;
	import of.app.required.resize.StageProxy;
	import of.app.Root;
	import of.app.XUser;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class AribitraryBasicLoaderGraphics implements ILoaderGraphics
	{
		private var user:XUser;
		
		private var stageDims:Point;
		private var target:Sprite ;
		private var size:Number ;
		private var square:Sprite;
		private var progressZone:Sprite ;
		private var midWidth:Number;
		private var midHeight:Number;
		
		public function AribitraryBasicLoaderGraphics() 
		{
			target =  Sprite(Root.root.addChild(new Sprite)) ;
			user = Root.user ;
		}
		
		public function start(closure:Function = null, ...args:Array):void
		{
			stageDims = StageProxy.init(Root.root.stage) ;
			trace("Loadingz Started !!!") ;
			
			midWidth = int(stageDims.x >> 1) ;
			midHeight = int(stageDims.y >> 1) ;
			size = 5 ;
			square = new Sprite() ;
			progressZone = new Sprite() ;
			
			//square.x = midWidth - (size/2) ;
			//square.y = midHeight - (size/2) ;
			
			square.graphics.beginFill(0xF2F2F2, .35) ;
			square.graphics.drawRect(0, 0, target.stage.stageWidth, size) ;
			square.graphics.endFill() ;
			
			square.addChild(progressZone ) ;
			target.addChild(square) ;
			twStart.apply(this, [closure].concat(args)) ;
		}
		private function drawProgress(percent:Number):void
		{
			var pct:Number = percent ;
			progressZone.graphics.clear() ;
			progressZone.graphics.beginFill(0xe42322) ;
			//progressZone.graphics.lineStyle(3, 0xFF6600,1, true,'none',CapsStyle.SQUARE,JointStyle.MITER,5 ) ;
			progressZone.graphics.drawRect(0, 0, pct*target.stage.stageWidth, size) ;
			progressZone.graphics.endFill() ;
		}
		private function twReset():void
		{
			progressZone.graphics.clear() ;
		}
		
		private function twStart(closure:Function = null, ...args:Array):void
		{
			twReset() ;
			TweenLite.to(progressZone, .5, { alpha:1, onComplete:function():void {
				if (Boolean(closure)) closure.apply(closure, [].concat(args)) ;
			}}) ;
		}
		
		private function twKill(closure:Function = null, ...args:Array):void
		{
			TweenLite.to(progressZone, .5, { onComplete:function():void {
				if (Boolean(closure)) closure.apply(closure, [].concat(args)) ;
			}} ) ;
		}		
		
		public function kill(closure:Function = null, ...args:Array):void {
			trace("Loadingz Ended !!!") ;
			var f:Function = function():void {
				TweenLite.to(square, .5, { alpha:0, onComplete:function():void {
					closure.apply(closure, [].concat(args)) ;
				}} ) ;
			}
			twKill(f) ;
		}

		/////////////////////////////////////////////////// ALL
		public function onALLOpen(e:Event):void {
			twStart() ;
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
			twKill() ;
		}
		/////////////////////////////////////////////////// ZIP
		public function onZIPOpen(e:Event):void {
			twStart() ;
		}
		public function onZIPProgress(e:ProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
			drawProgress(percent) ;
		}
		public function onZIPComplete(e:Event):void {
			twKill() ;
		}
		/////////////////////////////////////////////////// IMG
		public function onIMGOpen(e:Event):void {
			twStart() ;
		}
		public function onIMGProgress(e:ProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
			drawProgress(percent) ;
		}
		public function onIMGComplete(e:Event):void {
			twKill() ;
		}
		/////////////////////////////////////////////////// FONTS
		public function onFONTSOpen(e:Event):void {
			twStart() ;
		}
		public function onFONTSProgress(e:ProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
			drawProgress(percent) ;
		}
		public function onFONTSComplete(e:Event):void {
			twKill() ;
		}
		/////////////////////////////////////////////////// SWF
		public function onSWFOpen(e:Event):void {
			twStart() ;
		}
		public function onSWFProgress(e:ProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
			drawProgress(percent) ;
		}
		public function onSWFComplete(e:Event):void {
			twKill() ;
		}
		/////////////////////////////////////////////////// XML
		public function onXMLOpen(e:Event):void {
			twStart() ;
		}
		public function onXMLProgress(e:ProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal ;
			drawProgress(percent) ;
		}
		public function onXMLComplete(e:Event):void {
			twKill() ;
		}
	}
} 