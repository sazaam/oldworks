package of.app.required.commands 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import of.app.required.commands.I.IBasicCommand;
	import of.app.required.commands.I.ICommand;
	
	
	import of.dns.of_local ;
	
	/**
	 * The Command class is part of the Naja Commands API.
	 * 
	 * @see	of.app.required.commands.BasicCommand
	 * @see	of.app.required.commands.WaitCommand
	 * @see	of.app.required.commands.CommandQueue
	 * @see	of.app.required.commands.I.IBasicCommand
	 * @see	of.app.required.commands.I.ICommand
	 * @see	boa.core.x.base.Foundation
	 * 
     * @version 1.0.0
	 */
	
	public class Command extends BasicCommand implements ICommand
	{
//////////////////////////////////////////////////////// VARS
		use namespace of_local ;
		of_local var __thisObject : Object ;
		of_local var __function : Function ;
		of_local var __params : Array ;
		of_local var __isCancellable : Boolean = false ;
//////////////////////////////////////////////////////// CTOR
		/**
		 * Constructs an Command.
		 * 
		 * @param thisObject Object - The scope which the command will be executing in
		 * @param func Function - The closure to execute
		 * @param ... params Array - The paramsthat should be passed to the closure
		 */	
		public function Command(thisObject:Object,func:Function, ...params:Array) 
		{
			super() ;
			__thisObject = thisObject ; 
			__function = func ;
			__params = params ;
		}
		///////////////////////////////////////////////////////////////////////////////// EXECUTE
		/**
		 * Executes the Command.
		 * 
		 * @return Boolean
		 * @throws Error - Thrown if an error occured within the closure
		 */
		public function execute():Boolean {
			try 
			{
				__isCancellable = true ;
				__function.apply(__thisObject, __params) ;
			}
			catch (e:Error)
			{
				throw(e) ;
			}
			__isCancellable = false ;
			dispatchComplete();
			return true ;
		}
		///////////////////////////////////////////////////////////////////////////////// EXECUTE
		/**
		 * Cancels the Command actually executing. Takes effect only if executing.
		 * 
		 * @return Boolean
		 */
		public function cancel():Boolean {
			var s:Boolean = __isCancellable ;
			dispatchCancel() ;
			delete this ;
			return s ;
		}
		///////////////////////////////////////////////////////////////////////////////// COMPARECOMMANDS
		/**
		 * Compares two Commands in terms of 'equality'.
		 * 
		 * @param c Command - First Command object to compare
		 * @param c2 Command - Second Command object to compare
		 * @return Boolean - the result of the check, if true, both Command objects are equal.
		 */
		public static function compareCommands(c:Command,c2:Command):Boolean
		{
			if (c.of_local::__function != c2.of_local::__function) return false ;
			if (c.of_local::__thisObject != c2.of_local::__thisObject) return false ;
			if (c.of_local::__params != c2.of_local::__params) return false ;
			if (c.of_local::__isCancellable != c2.of_local::__isCancellable) return false ;
			return true ;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get isCancellableNow():Boolean { return __isCancellable }
		
		public function get params():Array { return __params }
		
		public function set params(value:Array):void { __params = value }
		
		public function get func():Function { return __function }
		
		public function set func(value:Function):void { __function = value}
	}
}