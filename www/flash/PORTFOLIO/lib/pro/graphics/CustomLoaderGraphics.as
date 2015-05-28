package pro.graphics 
{
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import gs.TweenLite;
	import of.app.required.context.XContext;
	import of.app.required.loading.E.LoadEvent;
	import of.app.required.loading.E.LoadProgressEvent;
	import of.app.required.loading.I.ILoaderGraphics;
	import of.app.required.resize.StageProxy;
	import of.app.required.resize.StageResize;
	import of.app.Root;
	import of.app.XUser;
	import pro.exec.ExecuteController;
	import pro.exec.ExecuteModel;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class CustomLoaderGraphics implements ILoaderGraphics
	{
		private var user:XUser;
		
		private var stageDims:Point;
		private var target:Sprite ;
		private var loadContainer:Sprite;
		private var progressZone:Sprite ;
		private var total:int;
		private var sizeHeight:int;
		
		public function CustomLoaderGraphics() 
		{
			user = Root.user ;
		}
		
		public function start(closure:Function = null, ...args:Array):void
		{
			
			trace("Loadingz Started !!!") ;
			
			loadContainer = new Sprite() ;
			progressZone = Sprite(loadContainer.addChild(new Sprite())) ;
			
			StageResize.instance.handle(loadContainer) ;
			loadContainer.addEventListener(Event.RESIZE, drawCont) ;
			target = XContext.$get('#universe')[0] ;
			target.addChild(loadContainer) ;
			twStart.apply(this, [closure].concat(args)) ;
		}
		
		private function drawCont(e:Event):void 
		{
			var w:int = 600 ;
			var h:int = 600 ;
			var stageDims:Point = StageProxy.init(Root.root.stage) ;
			total = w ;
			sizeHeight = 10 ;
			var g:Graphics = loadContainer.graphics ;
			
			loadContainer.x = (stageDims.x - w)  >> 1 ;
			loadContainer.y = 100 ;
			
			g.clear() ;
			g.lineStyle(sizeHeight, ExecuteController.hasInstance ? ExecuteController.instance.execModel.colors.main : 0xFFFFFF, .1, true, 'none', CapsStyle.ROUND, JointStyle.ROUND, 4) ;
			g.lineTo(w, 0) ;
		}
		
		private function drawProgress(percent:Number):void
		{
			var pct:Number = percent * total ;
			var g:Graphics = progressZone.graphics ;
			g.clear() ;
			g.lineStyle(sizeHeight, ExecuteController.hasInstance ? ExecuteController.instance.execModel.colors.main : 0xFFFFFF , 1, true, 'none', CapsStyle.ROUND, JointStyle.ROUND, 4 ) ;
			g.lineTo(pct, 0) ;
		}
		private function twReset():void
		{
			progressZone.graphics.clear() ;
		}
		
		private function twStart(closure:Function = null, ...args:Array):void
		{
			TweenLite.killTweensOf(progressZone) ;
			TweenLite.to(progressZone, .25, { alpha:1, onComplete:function():void {
				if(closure is Function) closure.apply(closure, [].concat(args)) ;
			}}) ;
		}
		
		private function twKill(closure:Function = null, ...args:Array):void
		{
			TweenLite.killTweensOf(progressZone) ;
			TweenLite.to(progressZone, .25, { onComplete:function():void {
				if(closure is Function) closure.apply(closure, [].concat(args)) ;
			}} ) ;
		}		
		
		public function kill(closure:Function = null, ...args:Array):void {
			trace("Loadingz Ended !!!") ;
			var f:Function = function():void {
				TweenLite.killTweensOf(loadContainer) ;
				TweenLite.to(loadContainer, .25, { alpha:0, onComplete:function():void {
					StageResize.instance.unhandle(loadContainer) ;
					loadContainer.removeEventListener(Event.RESIZE, drawCont) ;
					target.removeChild(loadContainer) ;
					loadContainer = null ;
					progressZone = null ;
					if (closure is Function) closure.apply(closure, [].concat(args)) ;
				}} ) ;
			}
			twKill(f) ;
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