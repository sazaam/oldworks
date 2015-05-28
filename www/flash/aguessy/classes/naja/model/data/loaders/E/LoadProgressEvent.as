package naja.model.data.loaders.E 
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import naja.model.data.loaders.MultiLoaderRequest;
	
	/**
	 * ...
	 * @author saz
	 */
	public class LoadProgressEvent extends ProgressEvent 
	{
		public static const PROGRESS:String = "loadprogress" ;
		public var req:MultiLoaderRequest ;
		public var index:int ;
		
		public function LoadProgressEvent(_req:MultiLoaderRequest, bubbles:Boolean=false, cancelable:Boolean=false,_index:int = 0) 
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