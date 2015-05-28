	/*
	 * Version 1.0.0
	 * Copyright BOA 2009
	 * 
	 * 
                                                                      SSSSSS
                                                                      SSSSSS
                                                                      SSSSSS
                                                                      3SSSSS



                    SSSSS                      ASSSSSS                                     SSSSSSA                 3ASSSSSS
        ASSSS    SSSSSSSSSSS               SSSSSSSSSSSSSSS            3SSSSS          3SSSSSSSSSSSSSS         S3SSSS SA3 3 SA3S
        ASSSS  SSSSSSSSSSSSSSS           SSSSSSSSSSSSSSSSSS           3SSSSS        SSSSSSSSSSSSSSSSSSS     SSS3SSSSSSSS3 SS S33
        ASSSS3SSSSSSA3SSSSSSSSS         SSSSSSS3    3SSSSSSS          3SSSSS        SSSSSSS     SSSSSSSS   A3ASS3SSSSSSSSASSSSSAS
        ASSSSSSSS        SSSSSS         SSS            SSSSSS         3SSSSS        SSS            SSSSS3 3SSSSSSSSSSSASA    33
        ASSSSSSS          SSSSSS                        SSSSS         3SSSSS                       SSSSSS 33SSSSSS3SSSSA
        ASSSSS             SSSSS                        SSSSS         3SSSSS                        SSSSSSS SSSSSSS3AS
        ASSSSS             SSSSS                        SSSSS3        3SSSSS                        SSSSSSSSSS 33SS3A3
        ASSSSS             SSSSS                        SSSSS3        3SSSSS                        SSSSS3SSSSSSSSSSSS
        ASSSSS             SSSSS               SSSSSSSSSSSSSS3        3SSSSS              3SSSSSSSSSSSSSSSASS SSSS
        ASSSSS             SSSSS           SSSSSSSSSSSSSSSSSS3        3SSSSS          3SSSSSSSSSSSSSSSSSSSSS3 SSSSSS3
        ASSSSS             SSSSS         SSSSSSSSSSSSSSSSSSSS3        3SSSSS        3SSSSSSSSSSSSSSSSSSSSSSS 3SSS 33
        ASSSSS             SSSSS        SSSSSS          SSSSS3        3SSSSS       SSSSSSS          SSSSSSSS   SSSS
        ASSSSS             SSSSS       SSSSSS           SSSSS3        3SSSSS       SSSSS            SSSSSS   3 SSS3
        ASSSSS             SSSSS       SSSSS            SSSSS3        3SSSSS      ASSSSS            SSSSSSA   A AA
        ASSSSS             SSSSS       SSSSS            SSSSS3        3SSSSS      SSSSSS            SSSSSS  ASA3S
        ASSSSS             SSSSS       SSSSS           SSSSSS3        3SSSSS      ASSSSS           SSSSSSS    3AS
        ASSSSS             SSSSS       SSSSSS        SSSSSSSS3        3SSSSS       SSSSSS        SSSSSSSSS    3A
        ASSSSS             SSSSS        SSSSSSSSSSSSSSSSSSSSS3        3SSSSS       ASSSSSSSSSSSSSSSSSSSSSS    S
        ASSSSS             SSSSS         SSSSSSSSSSSSSS  SSSS3        3SSSSS         SSSSSSSSSSSSSS 3SSSS
        3SSSS3             SSSSS           SSSSSSSSSS    SSSS         3SSSSS           SSSSSSSSSA    SSSS    A
                                                                      3SSSSS                             A  S
                                                                      ASSSSS                               3
                                                                      SSSSSA
                                                                      SSSSS
                                                                SSSSSSSSSSS
                                                                SSSSSSSSSS
                                                                SSSSSSSSA
                                                                   33
	 
	 * 
	 * 
	 *  
	 */

package naja.tools.commands 
{
	import flash.events.Event;
	import naja.tools.commands.I.ICommand;
	
	import naja.dns.naja_local ;
	
	/**
	 * The CommandQueue class is part of the Naja Commands API.
	 * 
	 * @see	naja.tools.commands.BasicCommand
	 * @see	naja.tools.commands.Command
	 * @see	naja.tools.commands.WaitCommand
	 * @see	naja.tools.commands.Commands
	 * @see	naja.tools.commands.I.ICommand
	 * @see	naja.tools.commands.I.ICommands
	 * 
     * @version 1.0.0
	 */
	
	public class CommandQueue extends Commands implements ICommand
	{
		use namespace naja_local ;
		naja_local var __isCancellable:Boolean = false;
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
			//var coms:Array = c.naja_local::__commands ;
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
			//var arr:Array = c.naja_local::__commands ;
			//var arr2:Array = c2.naja_local::__commands ;
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