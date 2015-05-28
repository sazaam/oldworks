package naja.model.commands.I
{
	
	/**
	 * ...
	 * @author saz
	 */

	public interface ICommand
	{
		function get isCancellableNow():Boolean ;
		function cancel():Boolean ;
		function execute():Boolean ;
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void ;
	}
	
}