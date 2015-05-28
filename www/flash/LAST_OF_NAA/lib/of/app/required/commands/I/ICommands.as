package of.app.required.commands.I
{
	
	/**
	 * The ICommands interface is part of the Naja Commands API.
	 * 
	 * @see	of.app.required.commands.CommandQueue
	 * @see	of.app.required.commands.Commands
	 * 
     * @version 1.0.0
	 */
	
	public interface ICommands
	{
		/**
		 * Adds a command to the internal commamd Array
		 * 
		 * @param	command ICommand
		 * @return ICommands
		 */
		function add(command:ICommand):ICommands ;
		/**
		 * Removes a command to the internal commamd Array
		 * 
		 * @param	command ICommand
		 * @return ICommands
		 */
		function remove(command:ICommand):ICommands ;
	}
	
}