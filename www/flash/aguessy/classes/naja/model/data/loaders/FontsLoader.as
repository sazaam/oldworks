package naja.model.data.loaders 
{
	import flash.events.Event;
	import flash.text.Font;
	import naja.model.data.loaders.E.LoadEvent;
	
	/**
	 * ...
	 * @author saz
	 */
	public class FontsLoader extends XLoader
	{
		//////////////////////////////////////////////////////////////////////////////ON EXTRA COMPLETE
		public var onExtraComplete:Function = function(e:Event):void {
			_loader.removeEventListener(Event.COMPLETE, onSpecialComplete) ;
			removeEventListener(LoadEvent.COMPLETE, onFontsComplete ) ;
		}
		//////////////////////////////////////////////////////////////////////////////CTOR
		public function FontsLoader() 
		{
			onSpecialComplete = onExtraComplete ;
			addEventListener(LoadEvent.COMPLETE, onFontsComplete ) ;
		}
		private function onFontsComplete(e:LoadEvent):void 
		{
			
			var font:Class = e.content.loaderInfo.applicationDomain.getDefinition(e.req.id) as Class ;
			Font.registerFont(font) ;
			LoadedData.insert("Fonts", e.req.id, font) ;
		}
	}
}