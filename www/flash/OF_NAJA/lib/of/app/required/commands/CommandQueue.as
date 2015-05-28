package of.app.required.commands 
{
	import flash.events.Event;
	import of.app.required.commands.I.ICommand;
	
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
		private var __autoExec:Boolean = true;
		private var __stopped:Boolean;
//////////////////////////////////////////////////////////////CONSTRUCTOR
		public function CommandQueue(...commandArray:Array) 
		{
			super() ;
			__commands = commandArray ;
		}
		///////////////////////////////////////////////////////////////////////////////// EXECUTE
		/**
		 * Executes the CommandQueue.
		 * 
		 * @return Boolean
		 */
		public function execute():Boolean
		{
			__index = 0 ;
			doNext() ;
			return true ;
		}
		public function continueProcess():void
		{
			doNext() ;
		}
		protected function doNext():void
		{
			__isCancellable = true ;
			var c:ICommand = __commands[ __index ] ;
			c.addEventListener(Event.COMPLETE, doNextCompleteHandler) ;
			c.execute() ;
		}
		protected function doNextCompleteHandler( e:Event ):void
		{
			__isCancellable = false ;
			e.target.removeEventListener(e.type, arguments.callee) ;
			__index ++ ;
			if (__index == __commands.length ) {
				dispatchComplete() ;
				__stopped = false ;
			}else {
				if(__autoExec)
					continueProcess() ;
				else
					__stopped = true ;
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
				var c:ICommand = __commands[__index] ;
				c.removeEventListener(Event.COMPLETE, doNextCompleteHandler) ;
				__isCancellable = false ;
			}
			__stopped = false ;
			empty() ;
			dispatchCancel() ;
			//delete this ;
			return s ;
		}
		///////////////////////////////////////////////////////////////////////////////// EMPTY
		/**
		 * Empties the CommandQueue, meaning emptying the array of Commands.
		 * 
		 */
		private function empty():void
		{
			var l:int = __commands.length ;
			
			while (l--) {
				var s:ICommand = ICommand(__commands[l] );
				s.cancel() ;
				__commands[l] = null ;
				delete __commands[ l ] ;
				__commands.pop() ;
			}
			
			__commands = [] ;
		}
		///////////////////////////////////////////////////////////////////////////////// COPYCOMMANDQUEUE
		/**
		 * Copies the content of a CommandQueue into another.
		 * 
		 * @param c CommandQueue - The original CommandQueue
		 * @param c2 CommandQueue - The newly copied CommandQueue
		 */
		public static function copyCommandQueue(c:CommandQueue,c2:CommandQueue):void
		{
			//var coms:Array = c.of_local::__commands ;
			//var l:int = coms.length ;
			//for (var i:int = 0 ; i < l ; i++ ) {
				//var com:ICommand = coms[i] ;
				//if(com is Command) c2.add(Command(com.clone())) ;
				//if(com is WaitCommand) c2.add(WaitCommand(com.clone())) ;
			//}
		}
		///////////////////////////////////////////////////////////////////////////////// COMPAREQUEUES
		/**
		 * Compare the contents of two CommandQueues.
		 * 
		 * @param c CommandQueue - The first CommandQueue
		 * @param c2 CommandQueue - The second CommandQueue
		 * @return Boolean - true if both CommandQueues are alike ; false otherwise.
		 */
		public static function compareQueues(c:CommandQueue,c2:CommandQueue):Boolean
		{
			//var arr:Array = c.of_local::__commands ;
			//var arr2:Array = c2.of_local::__commands ;
			//var l:int = arr.length ;
			//var l2:int = arr2.length ;
			//if (l != l2) return false ;
			//for (var i:int = 0 ; i < l; i++ )
			//{
				//var com:ICommand = ICommand(arr[i]) ;
				//var com2:ICommand = ICommand(arr2[i]) ;
				//if (!com.equals(com2)) return false ;
				//
			//}
			return true ;
		}		
		
///////////////////////////////////////////////////////////////////////////////// CLONE
		/**
		 * Creates and returns a copy of this object. The precise meaning of "copy" may depend on the class of the object. 
		 * 
		 * @param source Object (default=null) - Initialize the clone instance with custom properties.
		 * @return Object - a clone of this instance.
		 */
		//override public function clone(source:Object=null):Object
		//{
			//if (source != null)
				//return Type.getInstance.apply(null, [this, source]) ; 
			//var clone:CommandQueue = CommandQueue(Type.getInstance.apply(null, [this])) ; 
			//copyCommandQueue(this,clone) ;
			//return clone ;
		//}
///////////////////////////////////////////////////////////////////////////////// EQUALS
		/**
		 * Compares this object to another in order to assume their "equality".
		 * 
		 * @param o Object - the reference object with which to compare.
		 * @return Boolean - true if this object equals the object passed as argument; false otherwise.
		 */
		//override public function equals(o:Object):Boolean
		//{
			//if (o == this)
				//return true ;
			//if(!(o is CommandQueue))
				//return false ;
			//return compareQueues(this,CommandQueue(o));
		//}
		
		
		/**
		 * Returns a hash code value for the object.
		 * 
		 * @return int - a hash code value for this object.
		 */
		//override public function hashCode():int
		//{
			//return getType().defaultHashCode + (__commands.length * 31);
		//}
			
		/**
		 * Returns a string representation of the object.
		 * 
		 * @return	String - A string representation of the object.
		 */
		//override public function toString():String
		//{
			//return Type.format(this, null, []);
		//}
		
		/**
		 * @return String - the class version
		 */
		//override public function get version():String
		//{
			//return getType().declaringClass + " version : " + Version.getStringVersion();
		//}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get isCancellableNow():Boolean {
			return __isCancellable ;
		}
		public function get index():int {
			return __index ;
		}
		
		public function get autoExecute():Boolean { return __autoExec }
		public function set autoExecute(value:Boolean):void 
		{ __autoExec = value }
		
		public function get stopped():Boolean { return __stopped }
	}
}