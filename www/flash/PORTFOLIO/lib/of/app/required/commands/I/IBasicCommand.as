package of.app.required.commands.I
{
	
	/**
	 * The IBasicCommand interface is part of the Open Framework Commands API.
	 * 
	 * @see	of.app.required.commands.BasicCommand
	 * @see	of.app.required.commands.Command
	 * @see	of.app.required.commands.WaitCommand
	 * @see	of.app.required.commands.CommandQueue
	 * @see	of.app.required.commands.I.ICommand
	 * 
     * @version 1.0.0
	 */
	
	public interface IBasicCommand 
	{
		/**
		* Dispatches a COMPLETE Event, declaring execution of internal closure did occur without having encountered any error
		*/
		function dispatchComplete():void ;
		/**
		* Dispatches a CANCEL Event, declaring internal closure have received a cancel order.
		*/
		function dispatchCancel():void ;
	}
	
}