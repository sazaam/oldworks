package naja.model.data.loaders.E 
{
	import flash.events.Event;
	import naja.model.data.loaders.MultiLoaderRequest;
	
	/**
	 * ...
	 * @author saz
	 */
	public class LoadEvent extends Event 
	{
		public static const CONNECT:String = "connect" ;
		public static const COMPLETE:String = "loadcomplete" ;
		public static const ROOT_COMPLETE:String = "root_complete" ;
		public static const OPEN:String = "open" ;
		public static const ROOT_OPEN:String = "root_open" ;
		
		public var req:MultiLoaderRequest ;
		public var index:int ;
		public var content:* ;
		
		public function LoadEvent(_req:MultiLoaderRequest,type:String, bubbles:Boolean=false, cancelable:Boolean=false,_index:int = 0) 
		{ 
			super(type, bubbles, cancelable) ;
			req = _req ;
			index = _index ;
		} 
		
		public override function clone():Event 
		{ 
			return new LoadEvent(req, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LoadEvent", "req", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}