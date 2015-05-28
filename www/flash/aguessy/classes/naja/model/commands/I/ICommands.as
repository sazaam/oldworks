package naja.model.commands.I
{
	
	/**
	 * ...
	 * @author saz
	 */
	public interface ICommands
	{
		function add(command:ICommand):ICommands ;
		function remove(command:ICommand):ICommands ;
	}
	
}