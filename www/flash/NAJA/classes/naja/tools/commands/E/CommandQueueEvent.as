package naja.tools.commands.E 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author saz
	 */
	public class CommandQueueEvent extends Event 
	{
		static public const READY:String = "ready" ;
		public function CommandQueueEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable) ;
			
		} 
		
		public override function clone():Event 
		{ 
			return new CommandQueueEvent(type, bubbles, cancelable) ;
		}
		
		public override function toString():String 
		{ 
			return formatToString("CommandQueueEvent", "type", "bubbles", "cancelable", "eventPhase") ;
		}
		
	}
	
}