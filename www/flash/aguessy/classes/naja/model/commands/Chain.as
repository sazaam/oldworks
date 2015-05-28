package naja.model.commands 
{
	import naja.model.commands.I.ICommand
	/**
	 * ...
	 * @author saz
	 */
	public function Chain(command:ICommand = null)
	{
		return command? ResponsabilityChain.execute(command) : ResponsabilityChain ;
	}
}