package of.app.required.commands.I
{
	
	/**
	 * The ICommand interface is part of the Naja Commands API.
	 * 
	 * @see	of.app.required.commands.BasicCommand
	 * @see	of.app.required.commands.Command
	 * @see	of.app.required.commands.WaitCommand
	 * @see	of.app.required.commands.CommandQueue
	 * @see	of.app.required.commands.I.IBasicCommand
	 * @see boa.core.x.base.Foundation
	 * 
     * @version 1.0.0
	 */

	public interface ICommand
	{
		/**
		* isCancellableNow means that the internal closure either has'nt execute yet, or is still executing.
		* 
		* @return Boolean - True if hasn't even start, or is'nt done executing yet, false otherwise
		*/
		function get isCancellableNow():Boolean ;
		/**
		* Passes the order to cancel, then dispatch a CANCEL Event.
		* 
		* @return Boolean  - True if no error encountered, false otherwise.
		*/
		function cancel():Boolean ;
		/**
		* Executes the internal closure, i-e launches the process.
		* 
		* @return Boolean  - True if no error encountered, false otherwise.
		*/
		function execute():Boolean ;
		/**
		* Replaces the IEventDispatcher method addEventListener, to have acces to it within the subclass.
		* 
		*/
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		/**
		* Replaces the IEventDispatcher method removeEventListener, to have acces to it within the subclass.
		* 
		* @param type String
		* @param listener Function
		* @param useCapture Boolean

		*/
		function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void ;
	}
	
}