package testing 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.setTimeout;
	import of.app.required.formats.FileFormat;
	import of.app.required.loading.XLoader;
	import of.app.required.loading.XLoaderRequest;
	
	/**
	 * ...
	 * @author saz
	 */
	public class FroCircularLoadTest 
	{
		//////////////////////////////////////////////////////// VARS
		private var target:Sprite;
		private var loader:XLoader;
		private var circ:FroCircularLoaderGraphics;
		//////////////////////////////////////////////////////// CTOR
		public function FroCircularLoadTest(tg:Sprite) 
		{
			target = tg ;
			
			circ = new FroCircularLoaderGraphics(target) ;
			circ.start() ;
			
			setTimeout(load,1000) ;
		}
		
		private function load():void
		{
			loader = new XLoader() ;
			loader.addRequest(new XLoaderRequest("../img/home4.jpg", "testImage")) ;
			
			loader.addEventListener(ProgressEvent.PROGRESS, onProgress) ;
			loader.addEventListener(Event.COMPLETE, onComplete) ;
			loader.addEventListener(Event.OPEN, onOpen) ;
			loader.load() ;
		}
		
		private function onOpen(e:Event):void 
		{
			circ.onOpen(e) ;
		}
		///////////////////////////////////////////////////////////////////////////////// ON PROGRESS
		private function onProgress(e:ProgressEvent):void 
		{
			circ.onProgress(e) ;
		}
		///////////////////////////////////////////////////////////////////////////////// ON COMPLETE
		private function onComplete(e:Event):void 
		{
			loader.removeEventListener(ProgressEvent.PROGRESS, onProgress) ;
			loader.removeEventListener(Event.COMPLETE, onComplete) ;
			loader.removeEventListener(Event.OPEN, onOpen) ;
			circ.onComplete(e) ;
			
			reload() ;
		}
		
		private function reload():void
		{
			loader.removeAllRequests() ;
			setTimeout(load,1000) ;
		}
	}
}