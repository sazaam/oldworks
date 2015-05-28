package of.app.required.loading.E 
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import of.app.required.loading.XLoaderRequest;
	
	/**
	 * ...
	 * @author saz
	 */
	public class LoadProgressEvent extends ProgressEvent 
	{
		public static const PROGRESS:String = "loadProgress" ;
		public var req:XLoaderRequest ;
		public var index:int ;
		
		public function LoadProgressEvent(_req:XLoaderRequest, bubbles:Boolean=false, cancelable:Boolean=false,_index:int = 0) 
		{ 
			super(PROGRESS, bubbles, cancelable);
			req = _req ;
			index = _index ;
		}
		public override function clone():Event 
		{ 
			return new LoadProgressEvent(req, bubbles, cancelable);
		}
		public override function toString():String 
		{ 
			return formatToString("LoadProgressEvent", "req", "type", "bytesLoaded","bytesTotal", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}