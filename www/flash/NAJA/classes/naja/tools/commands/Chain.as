package naja.tools.commands 
{
	import naja.tools.commands.I.ICommand
	/**
	 * ...
	 * @author saz
	 */
	public function Chain(command:ICommand = null):Class
	{
		return command? Class(ResponsabilityChain.execute(command)) : ResponsabilityChain ;
	}
}