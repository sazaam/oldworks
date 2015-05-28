package naja.model.commands 
{
	import naja.model.commands.I.ICommand;
	import naja.model.commands.I.ICommands;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Commands extends BasicCommand implements ICommands
	{
		protected var _commands:Array
		protected var _index:Number
//////////////////////////////////////////////////////////////CONSTRUCTOR
		public function Commands(commandArray:Array = null) 
		{
			super() ;
			_index = 0 ;
			_commands = (commandArray == null)? [] : commandArray ;
		}
		
//////////////////////////////////////////////////////////////ADDING & REMOVE
		public function add(command:ICommand):ICommands
		{
			_commands.push(command) ;
			return this ;
		}
		public function remove(command:ICommand):ICommands
		{
			_commands.pop() ;
			return this ;
		}
		
		public function get length():Number { return _commands.length }
	}
}