package testing 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	import gs.TweenLite;
	import of.app.required.loading.E.LoadEvent;
	import of.app.required.loading.E.LoadProgressEvent;
	import of.app.required.loading.XAllLoader;
	import of.app.required.loading.XLoaderRequest;
	
	/**
	 * @author saz
	 */
	public class MultiLoaderRequestTest 
	{
		private var __target:Sprite;
		private var __contLoad:Sprite;
		private var xml:XML;
		private var __ind:int;
		
		public function MultiLoaderRequestTest(tg:Sprite) 
		{
			__target = tg ;
			initialize() ;
		}
		
		private function initialize():void
		{
			xml = <scheme merged="false">
				<xml id="sections" url="sections/sections.xml" />
				<fonts id="KozGothProEL" url="KozGothProEL.swf"/>
				<fonts id="KozGothProL" url="KozGothProL.swf"/>
				<fonts id="KozGothProH" url="KozGothProH.swf"/>
				<img id="shoe" url="shoe.png"/>
				<img id="metal" url="metal.jpg"/>
				<swf id="clips" url="graphics.swf"/>
			</scheme> ;
			
			generate() ;
			
			__target.stage.addEventListener(MouseEvent.CLICK, onStageClicked)
			
		}
		
		private function onStageClicked(e:MouseEvent):void 
		{
			XAllLoader.clean() ;
		}
		//////////////////////////////////////////////////////// GENERATE & KILL
		private function generate():void
		{
			XAllLoader.init(__target, "allYannick", xml.copy()) ;
			
			graphicsStart() ;
			
			XAllLoader.addEventListener(ProgressEvent.PROGRESS, onProgress) ;
			XAllLoader.addEventListener(Event.COMPLETE, onComplete) ;
			XAllLoader.addEventListener(LoadProgressEvent.PROGRESS, onLoadProgress) ;
			XAllLoader.addEventListener(LoadEvent.OPEN, onLoadConnect) ;
			XAllLoader.addEventListener(LoadEvent.COMPLETE, onLoadComplete) ;
			//
			XAllLoader.launch() ;
		}
		
		private function regenerate():void
		{
			var newXML:XML = xml.copy() ;
			newXML.@merged = "true" ;
			
			XAllLoader.init(__target, "allYannick", newXML) ;
			
			graphicsStart() ;
			
			XAllLoader.addEventListener(ProgressEvent.PROGRESS, onProgress) ;
			XAllLoader.addEventListener(Event.COMPLETE, onComplete) ;
			XAllLoader.addEventListener(LoadProgressEvent.PROGRESS, onLoadProgress) ;
			XAllLoader.addEventListener(LoadEvent.OPEN, onLoadConnect) ;
			XAllLoader.addEventListener(LoadEvent.COMPLETE, onLoadComplete) ;
			
			XAllLoader.launch() ;
		}
		
		private function kill():void
		{
			XAllLoader.clean() ;
			
			XAllLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress) ;
			XAllLoader.removeEventListener(Event.COMPLETE, onComplete) ;
			XAllLoader.removeEventListener(LoadProgressEvent.PROGRESS, onLoadProgress) ;
			XAllLoader.removeEventListener(LoadEvent.OPEN, onLoadConnect) ;
			XAllLoader.removeEventListener(LoadEvent.COMPLETE, onLoadComplete) ;
			
			tweenKill() ;
		}
		
		private function tweenKill():void
		{
			TweenLite.to(__contLoad,.5,{alpha:0,onComplete:function(){graphicsKill()}}) ;
		}
		//////////////////////////////////////////////////////// EVENT HANDLERS
		private function onLoadConnect(e:LoadEvent):void 
		{
			var req:XLoaderRequest = e.req ;
			var sh:Sprite = new Sprite() ;
			sh.name = "load_" + e.index ;
			sh.graphics.beginFill(0xD40000, .85) ;
			sh.graphics.drawRect(0,0,250,1) ;
			sh.x = 0 ;
			sh.y = (e.index * 15) + 20 ;
			sh.scaleX = 0 ;
			__contLoad.addChild(sh) ;
		}
		private function onLoadComplete(e:LoadEvent):void 
		{
			var sh:Sprite = Sprite(__contLoad.getChildByName("load_" + e.index)) ;
			TweenLite.to(sh, .5, { alpha:.5 } ) ;
		}
		private function onLoadProgress(e:LoadProgressEvent):void 
		{
			var sh:Sprite = Sprite(__contLoad.getChildByName("load_" + e.index)) ;
			sh.scaleX = e.bytesLoaded / e.bytesTotal ;
		}
		private function onProgress(e:ProgressEvent):void 
		{
			var mc:Sprite = Sprite(__contLoad.getChildByName('loadingBar')) ;
			mc.scaleX = e.bytesLoaded / e.bytesTotal ;
		}
		private function onComplete(e:Event):void
		{
			if (XAllLoader.phase == 'swf' || XAllLoader.phase == 'All') {
				kill() ;
				__ind ++ ; 
				if(__ind % 2 == 1) setTimeout(regenerate, 1000) ;
				else setTimeout(generate, 1000) ;
				
			}
		}
		//////////////////////////////////////////////////////// GRAPHICS
		private function graphicsStart():void
		{
			__contLoad = new Sprite() ;
			__contLoad.graphics.beginFill(0xD40000, .15) ;
			__contLoad.graphics.drawRect(0, 0, 250, 10) ;
			__contLoad.graphics.endFill() ;
			__contLoad.x = (__target.stage.stageWidth >> 1) - (__contLoad.width >> 1 );
			__contLoad.y = (__target.stage.stageHeight >> 1) - (__contLoad.height >> 1 );
			var mc:Sprite = new Sprite() ;
			mc.name = 'loadingBar' ;
			mc.graphics.beginFill(0xD40000) ;
			mc.graphics.drawRect(0, 0, 250, 10) ;
			mc.graphics.endFill() ;
			mc.scaleX = 0 ;
			__contLoad.addChild(mc) ;
			__target.addChild(__contLoad) ;
		}
		private function graphicsKill():void
		{
			__target.removeChild(__contLoad) ;
			__contLoad = null ;
		}
	}
}