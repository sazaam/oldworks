package naja.model.data.loaders 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import naja.model.data.loaders.E.LoadEvent;
	
	/**
	 * ...
	 * @author saz
	 */
	public class IMGLoader extends XLoader
	{
		//////////////////////////////////////////////////////////////////////////////ON EXTRA COMPLETE
		public var onExtraComplete:Function = function(e:Event):void {
			_loader.removeEventListener(Event.COMPLETE, onSpecialComplete) ;
			removeEventListener(LoadEvent.COMPLETE, onIMGComplete ) ;
		}
		//////////////////////////////////////////////////////////////////////////////CTOR
		public function IMGLoader() 
		{
			onSpecialComplete = onExtraComplete ;
			addEventListener(LoadEvent.COMPLETE, onIMGComplete ) ;
		}
		private function onIMGComplete(e:LoadEvent):void 
		{
			
			var bmp:Bitmap = Bitmap(e.content) ;
			//Loader(e.content.parent).unload() ;
			LoadedData.insert("IMG", e.req.id, bmp) ;
		}
	}
}