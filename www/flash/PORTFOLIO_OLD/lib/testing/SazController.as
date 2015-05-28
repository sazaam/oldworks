package testing 
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import tools.begin.Spawner;
	/**
	 * ...
	 * @author saz
	 */
	public class SazController extends EventDispatcher
	{
		private var __view:SazViewPort;
		private var __model:SazModel;
		
		public function SazController() 
		{
			
		}
		
		public function init(model:SazModel, viewport:SazViewPort, target:Sprite):SazController
		{
			__model = model ;
			__view = viewport ;
			__view.init(target, __model.conf_xml.*[0]) ;
			
			parseModel() ;
			
			return this ;
		}
		
		private function parseModel():void 
		{
			trace(' >>> ', Spawner.parse(__model.plugin_xml, onModelComplete));
		}
		private function onModelComplete(e:Event):void 
		{
			var c:Class = Spawner.getDefinition('of::HomeStep') ;
			trace(c)
			dispatchEvent(new Event(Event.INIT)) ;
		}
	}
}