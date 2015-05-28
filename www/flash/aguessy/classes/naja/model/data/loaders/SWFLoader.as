package naja.model.data.loaders 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import naja.model.data.loaders.E.LoadEvent;
	
	/**
	 * ...
	 * @author saz
	 */
	public class SWFLoader extends XLoader
	{
		//////////////////////////////////////////////////////////////////////////////ON EXTRA COMPLETE
		public var onExtraComplete:Function = function(e:Event):void {
			_loader.removeEventListener(Event.COMPLETE, onSpecialComplete) ;
			removeEventListener(LoadEvent.COMPLETE, onSWFComplete ) ;
		}
		//////////////////////////////////////////////////////////////////////////////CTOR
		public function SWFLoader() 
		{
			onSpecialComplete = onExtraComplete ;
			addEventListener(LoadEvent.COMPLETE, onSWFComplete ) ;
		}
		private function onSWFComplete(e:LoadEvent):void 
		{
			var tg:Sprite = Sprite(e.content) ;
			//Loader(e.content.parent).unload() ;
			LoadedData.insert("SWF", e.req.id, tg) ;
		}
	}
}