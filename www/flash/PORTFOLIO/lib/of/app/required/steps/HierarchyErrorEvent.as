package of.app.required.steps 
{
	import flash.events.Event;
	import of.app.required.error.HierarchyError;
	
	/**
	 * ...
	 * @author saz
	 */
	public class HierarchyErrorEvent extends Event 
	{
		static public const PATH_ERROR:String = "pathError" ;
		private var __error:HierarchyError;
		private var __errorPath:String;
		private var __currentPath:String ;
		public function HierarchyErrorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable) ;
		} 
		
		public override function clone():Event 
		{
			var h:HierarchyErrorEvent = new HierarchyErrorEvent(type, bubbles, cancelable) ;
			h.currentPath = __currentPath ;
			h.errorPath = __errorPath ;
			h.error = __error ;
			return h ;
		}
		
		public override function toString():String 
		{ 
			return formatToString("HierarchyEvent", "type", "bubbles", "cancelable", "eventPhase") ;
		}
		public function get currentPath():String { return __currentPath }
		public function set currentPath(value:String):void { __currentPath = value }
		
		public function get errorPath():String { return __errorPath }
		public function set errorPath(value:String):void { __errorPath = value }
		public function get error():HierarchyError { return __error }
		public function set error(value:HierarchyError):void { __error = value }
	}
	
}