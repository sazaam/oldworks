package of.app.required.commands 
{
	import flash.events.Event;
	import of.app.required.commands.I.ICommand;
	import of.app.XConsole;
	
	import of.dns.of_local ;
	
	/**
	 * The CommandQueue class is part of the Naja Commands API.
	 * 
	 * @see	of.app.required.commands.BasicCommand
	 * @see	of.app.required.commands.Command
	 * @see	of.app.required.commands.WaitCommand
	 * @see	of.app.required.commands.Commands
	 * @see	of.app.required.commands.I.ICommand
	 * @see	of.app.required.commands.I.ICommands
	 * 
     * @version 1.0.0
	 */
	
	public class CommandQueue extends Commands implements ICommand
	{
		use namespace of_local ;
		of_local var __isCancellable:Boolean = false;
//////////////////////////////////////////////////////////////CONSTRUCTOR
		public function CommandQueue() 
		{
			super() ;
		}
		public function init(...commandArray:Array) 
		{
			__commands = commandArray ;
			return this ;
		}
		///////////////////////////////////////////////////////////////////////////////// EXECUTE
		/**
		 * Executes the CommandQueue.
		 * 
		 * @return Boolean
		 */
		public function execute():Boolean
		{
			__index = -1 ;
			if (length !=0) {
				doNext() ;
				return true ;
			}
			return false ;
		}
		public function reset(command:Boolean = true):void
		{
			if (isCancellableNow) {
				cancel() ;
			}
			if(command) __commands = [] ;
			__index = -1 ;
		}
		public function continueProcess():void
		{
			doNext() ;
		}
		protected function doNext():void
		{
			__isCancellable = true ;
			var c:ICommand = __commands[ __index+1] ;
			c.addEventListener(Event.COMPLETE, doNextCompleteHandler) ;
			c.execute() ;
		}
		protected function doNextCompleteHandler( e:Event ):void
		{
			e.target.removeEventListener(e.type, doNextCompleteHandler) ;
			__index ++ ;
			if (__index == length - Array.length) {
				__isCancellable = false ;
				dispatchComplete() ;
			}else {
				continueProcess() ;
			}
		}
		//////////////////////////////////////////////////////////////CANCEL
		/**
		 * Cancels the Command.
		 * 
		 * @return Boolean
		 */
		public function cancel():Boolean {
			var s:Boolean = __isCancellable ;
			if (s) {
				var c:ICommand = __commands[__index+1] ;
				c.removeEventListener(Event.COMPLETE, doNextCompleteHandler) ;
				__isCancellable = false ;
			}
			empty() ;
			dispatchCancel() ;
			return s ;
		}
		///////////////////////////////////////////////////////////////////////////////// EMPTY
		/**
		 * Empties the CommandQueue, meaning emptying the array of Commands.
		 * 
		 */
		private function empty():void
		{
			var l:int = length ;
			
			while (l--) {
				var s:ICommand = ICommand(__commands[l] );
				s.cancel() ;
				__commands[l] = null ;
				delete __commands[ l ] ;
				__commands.pop() ;
			}
			__commands = [] ;
		}

///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get isCancellableNow():Boolean {
			return __isCancellable ;
		}
		public function get index():int {
			return __index ;
		}
	}
}