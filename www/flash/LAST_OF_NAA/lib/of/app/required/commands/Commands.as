package of.app.required.commands 
{
	import flash.events.IEventDispatcher;
	import of.app.required.commands.I.ICommand;
	import of.app.required.commands.I.ICommands;
	
	import of.dns.of_local ;
	
	/**
	 * The Commands class is part of the Naja Commands API.
	 * 
	 * @see	of.app.required.commands.BasicCommand
	 * @see	of.app.required.commands.Command
	 * @see	of.app.required.commands.WaitCommand
	 * @see	of.app.required.commands.CommandQueue
	 * @see	of.app.required.commands.I.IBasicCommand
	 * @see	of.app.required.commands.I.ICommand
	 * @see	of.app.required.commands.I.ICommands
	 * 
     * @version 1.0.0
	 */
	
	public class Commands extends BasicCommand implements ICommands
	{
//////////////////////////////////////////////////////// VARS
		use namespace of_local ;
		of_local var __commands:Array ;
		of_local var __index:Number ;
//////////////////////////////////////////////////////// CTOR
		/**
		 * Contrsucts a Commands object
		 * 
		 * @param	commandArray (default = null) - An array of ICommand instances to fill into
		 * internal command Array right away
		 */
		public function Commands(commandArray:* = null) 
		{
			super() ;
			__commands = (commandArray == null)? [] : commandArray ;
		}
		
		///////////////////////////////////////////////////////////////////////////////// ADD
		/**
		 * Adds a command to command list
		 * 
		 * @param	command ICommand
		 * @return	Commands
		 */
		public function add(command:ICommand):ICommands
		{
			__commands.push(command) ;
			return this ;
		}
		///////////////////////////////////////////////////////////////////////////////// REMOVE
		/**
		 * Removes a command from command list
		 * @param	command ICommand
		 * @return	Commands
		 */
		public function remove(command:ICommand):ICommands
		{
			__commands.pop() ;
			return this ;
		}
///////////////////////////////////////////////////////////////////////////////// SETUP
		/**
		 * @param	source
		 */
		//override protected function initFromCustom(source:Object):void
		//{
			//setup(source._target, source._commandArray) ;
		//}
		
		/**
		 * @param	... sources
		 */	
		//override protected function setup(... sources:Array):void
		//{
			//var tar:IEventDispatcher = (sources[0] as IEventDispatcher) || new Query() ;
			//var commandArray:Array = sources[1] as Array || null ; 
			//_setter = _initializer.make(Initializer.SETUP_METHOD, getType(), function():void {
				//target = tar ;
				//__index = 0 ;
				//__commands = (commandArray == null)? [] : commandArray ;
			//});
		//}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get length():Number { return __commands.length }
	}
}