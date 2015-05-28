package naja.model.data.loaders 
{
	import flash.events.Event;
	import naja.model.data.loaders.E.LoadEvent;
	
	/**
	 * ...
	 * @author saz
	 */
	public class XMLLoader extends XLoader
	{	
		//////////////////////////////////////////////////////////////////////////////ON EXTRA COMPLETE
		public var onExtraComplete:Function = function(e:Event):void {
			_loader.removeEventListener(Event.COMPLETE, onSpecialComplete) ;
			removeEventListener(LoadEvent.COMPLETE, onXMLComplete ) ;
		}
		//////////////////////////////////////////////////////////////////////////////CTOR
		public function XMLLoader() 
		{
			onSpecialComplete = onExtraComplete ;
			addEventListener(LoadEvent.COMPLETE, onXMLComplete ) ;
		}
		private function onXMLComplete(e:LoadEvent):void 
		{
			LoadedData.insert("XML", e.req.id, e.content) ;
		}
	}
}