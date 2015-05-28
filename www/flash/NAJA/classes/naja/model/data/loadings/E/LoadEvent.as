package naja.model.data.loadings.E 
{
	import flash.events.Event;
	import naja.model.data.loadings.XLoaderRequest;
	
	/**
	 * ...
	 * @author saz
	 */
	public class LoadEvent extends Event 
	{
		public static const COMPLETE:String = "loadComplete" ;
		public static const OPEN:String = "loadOpen" ;

		
		public var req:XLoaderRequest ;
		public var index:int ;
		public var content:* ;
		
		public function LoadEvent(_req:XLoaderRequest,type:String, bubbles:Boolean=false, cancelable:Boolean=false,_index:int = 0) 
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