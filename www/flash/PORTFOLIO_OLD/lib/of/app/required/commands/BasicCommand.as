package of.app.required.commands 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import of.app.required.commands.I.IBasicCommand;
	
	/**
	 * The BasicCommand class is part of the Naja X API.
	 * 
	 * @see	naja.model.Root
	 * @see	naja.model.XData
	 * @see	naja.model.XModel
	 * @see	boa.core.x.base.Base
	 * 
     * @version 1.0.0
	 */
	
	public class BasicCommand extends EventDispatcher implements IBasicCommand
	{
//////////////////////////////////////////////////////// CTOR
		/**
		* Constructs a BasicCommand
		* 
		* 
		*/
		public function BasicCommand() 
		{
			super() ;
		}
		///////////////////////////////////////////////////////////////////////////////// DISPATCHCOMPLETE
		/**
		* Dispatches a COMPLETE Event
		*/
		public function dispatchComplete():void
		{
			dispatchEvent( new Event(Event.COMPLETE) );
		}
		///////////////////////////////////////////////////////////////////////////////// DISPATCHCOMPLETE
		/**
		* Dispatches a CANCEL Event
		*/
		public function dispatchCancel():void
		{
			dispatchEvent( new Event(Event.CANCEL) );
		}
	}
	
}