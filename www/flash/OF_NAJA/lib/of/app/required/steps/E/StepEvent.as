package of.app.required.steps.E
{
	import flash.events.Event ;
	
	public class StepEvent extends Event 
	{
		public static var OPEN:String = "open" ;
		public static var CLOSE:String = "close" ;
		public static var CANCEL:String = "cancel" ;
		
		
		public var name:String;
		public var id:int;
		public function StepEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,_name:Object = null) 
		{ 
			if (_name is String) {
				name = String(_name) ;
				id = -1 ;
			}
			if (_name is int) {
				id = int(_name) ;
				name = String(name) ;
			}
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new StepEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("StepEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}