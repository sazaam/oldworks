package of.app.required.commands 
{
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import of.app.required.commands.I.ICommand;
	
	import of.dns.of_local ;
	
	/**
	 * The WaitCommand class is part of the Naja Commands API.
	 * 
	 * @see	of.app.required.commands.BasicCommand
	 * @see	of.app.required.commands.Command
	 * @see	of.app.required.commands.CommandQueue
	 * @see	of.app.required.commands.I.ICommand
	 * 
     * @version 1.0.0
	 */
	
	public class WaitCommand extends BasicCommand implements ICommand
	{
//////////////////////////////////////////////////////// VARS
		use namespace of_local ;
		private var __timer:Timer ;
		of_local var __delay:Number ;
		of_local var __isCancellable:Boolean = false ;
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
			if (c.of_local::__delay != c2.of_local::__delay) return false ;
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