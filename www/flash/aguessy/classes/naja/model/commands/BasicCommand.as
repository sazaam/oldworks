package naja.model.commands 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import naja.model.commands.I.IBasicCommand;
	
	/**
	 * ...
	 * @author saz
	 */
	public class BasicCommand extends EventDispatcher implements IBasicCommand
	{
		
		public function BasicCommand() 
		{
			
		}
		
		public function dispatchComplete():void
		{
			dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		public function dispatchCancel():void
		{
			dispatchEvent( new Event(Event.CANCEL) );
		}
	}
	
}