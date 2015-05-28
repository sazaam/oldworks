package of.app.required.steps 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author saz
	 */
	public class HierarchyEvent extends Event 
	{
		static public const READY:String = "ready" ;
		static public const ADDRESS_COMPLETE:String = "addressComplete" ;
		public function HierarchyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable) ;
		} 
		
		public override function clone():Event 
		{ 
			return new HierarchyEvent(type, bubbles, cancelable) ;
		}
		
		public override function toString():String 
		{ 
			return formatToString("HierarchyEvent", "type", "bubbles", "cancelable", "eventPhase") ;
		}
		
	}
	
}