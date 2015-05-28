﻿package of.app.required.commands.E 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author saz
	 */
	public class CommandQueueEvent extends Event 
	{
		static public const READY:String = "ready" ;
		static public const CHAIN_READY:String = "chainReady" ;
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