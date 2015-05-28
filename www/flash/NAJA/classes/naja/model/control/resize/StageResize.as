package naja.model.control.resize 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author saz
	 */
	public class StageResize 
	{////////////////////////////////////////////// VARS
		static private var __instance:StageResize;
		static private var __resizables:Dictionary;
		//////////////////////////////////////////////////////////////////// CTOR
		public function StageResize() 
		{
			__instance = this ;
			__resizables = new Dictionary() ;
		}
//////////////////////////////////////////////////////////////////////////// PUBLIC
//////////////////////////////////////////////////////////////////////////// METHODS
///////////////////////////////////////////////////////////////////////////////////////////////// INIT
		public function init(stage:Stage):StageResize
		{
			stage.addEventListener(Event.RESIZE, onStageResize) ;
			return this ;
		}
///////////////////////////////////////////////////////////////////////////////////////////////// HANDLE
		public function handle(ed:EventDispatcher):void 
		{
			__resizables[ed] = ed ;
			ed.addEventListener(Event.ADDED_TO_STAGE, onStage) ;
		}
///////////////////////////////////////////////////////////////////////////////////////////////// HANDLE
		public function unhandle(ed:EventDispatcher):void 
		{
			__resizables[ed] = null ;
			delete __resizables[ed] ;
		}
//////////////////////////////////////////////////////////////////////////// PRIVATE
//////////////////////////////////////////////////////////////////////////// METHODS
		///////////////////////////////////////////////////////////////////////////////// STAGERESIZE
		private function onStageResize(e:Event):void 
		{
			for each(var i:* in __resizables) {
				dispatchResize(EventDispatcher(i)) ;
			}
		}
		///////////////////////////////////////////////////////////////////////////////// EVENT DISPATCH
		private function dispatchResize(ed:EventDispatcher):void 
		{
			if(ed.hasEventListener(Event.RESIZE)) ed.dispatchEvent(new Event(Event.RESIZE)) ;
		}
		///////////////////////////////////////////////////////////////////////////////// EVENT HANDLE
		private function onStage(e:Event):void 
		{
			var ed:EventDispatcher = EventDispatcher(e.currentTarget) ;
			ed.removeEventListener(Event.ADDED_TO_STAGE, arguments.callee) ;
			dispatchResize(ed) ;
			ed.addEventListener(Event.REMOVED_FROM_STAGE, onExit) ;
		}
		private function onExit(e:Event):void 
		{
			var ed:EventDispatcher = EventDispatcher(e.currentTarget) ;
			ed.removeEventListener(Event.REMOVED_FROM_STAGE, arguments.callee) ;
			ed.addEventListener(Event.ADDED_TO_STAGE, onStage) ;
		}
//////////////////////////////////////////////////////////////////// GETTERS & SETTERS
/////////////////////////////////////////////////////////////////////////////////// STATICS
		static public function init(s:Stage):StageResize{ return  __instance.init(s) }
		static public function get instance():StageResize{ return  __instance || new StageResize() }
		static public function get hasInstance():Boolean{ return  Boolean(__instance)}
	}
}