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
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import naja.tools.commands.I.ICommand;
	
	import naja.dns.naja_local ;
	
	/**
	 * The WaitCommand class is part of the Naja Commands API.
	 * 
	 * @see	naja.tools.commands.BasicCommand
	 * @see	naja.tools.commands.Command
	 * @see	naja.tools.commands.CommandQueue
	 * @see	naja.tools.commands.I.ICommand
	 * 
     * @version 1.0.0
	 */
	
	public class WaitCommand extends BasicCommand implements ICommand
	{
//////////////////////////////////////////////////////// VARS
		use namespace naja_local ;
		private var __timer:Timer ;
		naja_local var __delay:Number ;
		naja_local var __isCancellable:Boolean = false ;
//////////////////////////////////////////////////////// CTOR
		/**
		* Constructs a WaitCommand
		* 
		* @param time Number - The dalay in milliseconds
		*/	
		public function WaitCommand(delay:Number = 1000) 
		{
			super() ;
			__delay = delay ; 
		}
		///////////////////////////////////////////////////////////////////////////////// EXECUTE
		/**
		 * Launches the countdown to the Function's real execution.
		 * 
		 * @return Boolean - Will allways return true.
		 */
		public function execute():Boolean
		{
			__isCancellable = true ;
			__timer = new Timer(__delay, 1) ;
			__timer.addEventListener(TimerEvent.TIMER_COMPLETE, executeCompleteHandler) ;
			__timer.start() ;
			return true ;
		}
		///////////////////////////////////////////////////////////////////////////////// COMPLETE
		protected function executeCompleteHandler(e:TimerEvent):void
		{
			__timer.removeEventListener(TimerEvent.TIMER_COMPLETE, executeCompleteHandler ) ;
			__timer.stop() ;
			__timer = null ;
			__isCancellable = false ;
			dispatchComplete() ;
		}
		////////////////////////////////////////////////////////////// CANCEL
		/**
		 * Tries to cancel and will return false if this WaitCommand can't cancel when asked to.
		 * 
		 * @return Boolean
		 */
		public function cancel():Boolean {
			var s:Boolean = __isCancellable ;
			if (s) {
				__timer.removeEventListener(TimerEvent.TIMER_COMPLETE, executeCompleteHandler ) ;
				__timer.stop() ;
				__timer = null ;
			}
			delete this ;
			return s ;
		}
///////////////////////////////////////////////////////////////////////////////// CLONE
		/**
		 * Creates and returns a copy of this object. The precise meaning of "copy" may depend on the class of the object. 
		 * @param source Object (default = null) - Initialize the clone instance with custom properties.
		 * @return Object - a clone of this instance.
		 */
		//override public function clone(source:Object=null):Object
		//{
			//if (source != null)
				//return Type.getInstance.apply(null, [this, source]) ; 
			//var clone:WaitCommand = WaitCommand(Type.getInstance.apply(null, [this,__delay])) ; 
			//clone.target = target ;
			//return clone ;
		//}
///////////////////////////////////////////////////////////////////////////////// EQUALS
		/**
		 * Compares this object to another in order to assume their "equality".
		 * @param o Object - the reference object with which to compare.
		 * @return Boolean - true if this object equals the object passed as argument; false otherwise.
		 */
		//override public function equals(o:Object):Boolean
		//{
			//if (o == this)
				//return true ;
			//if(!(o is WaitCommand))
				//return false ;
			//return compareCommands(this,WaitCommand(o));
		//}
///////////////////////////////////////////////////////////////////////////////// EQUALS
		/**
		 * Compares two commands cheking their respective delay and target
		 * @param c WaitCommand first WaitCommand object
		 * @param c2 WaitCommand second WaitCommand object
		 * @return Boolean - true if this object equals the object passed as argument; false otherwise.
		 */
		public static function compareCommands(c:WaitCommand,c2:WaitCommand):Boolean
		{
			if (c.naja_local::__delay != c2.naja_local::__delay) return false ;
			return true ;
		}
///////////////////////////////////////////////////////////////////////////////// VERSION
		/**
		 * @return String - the class version
		 */
		//override public function get version():String
		//{
			//return getType().declaringClass + " version : " + Version.getStringVersion();
		//}
///////////////////////////////////////////////////////////////////////////////// SETUP
		/**
		 * @param	source
		 */
		//override protected function initFromCustom(source:Object):void
		//{
			//setup(source._target, source._delay);
		//}
		/**
		 * @param	... sources
		 */	
		//override protected function setup(...sources:Array):void
		//{
			//
			//var tar:IEventDispatcher = (sources[0] as IEventDispatcher) || new Query() ;
			//var o:Number = Number(sources[1]) || NaN ; 
			//
			//_setter = _initializer.make(Initializer.SETUP_METHOD, getType(), function():void {
				//target = tar ;
				//__delay = o ; 
			//});
		//}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		/**
		 * @return	Boolean
		 */	
		public function get isCancellableNow():Boolean {
			return __isCancellable ;
		}
	}
	
}