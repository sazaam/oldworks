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
			//var clone:Command = Command(Type.getInstance.apply(null, [this, __thisObject, __function, __params])) ; 
			//clone.target = target ;
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
			//if(!(o is Command))
				//return false ;
			//return compareCommands(this,Command(o));
		//}

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
			//setup(source._target, source._thisObject, source._function, source._params);
		//}
		/**
		 * @param	... sources
		 */	
		//override protected function setup(... sources:Array):void
		//{
			//var tar:IEventDispatcher = (sources[0] as IEventDispatcher) || new Query() ;
			//var o:Object = sources[1] || null; 
			//var f:Function = (sources[2] as Function) || function():void { } ;
			//var arr:Array = (sources[3] as Array) || [] ;
			//_setter = _initializer.make(Initializer.SETUP_METHOD, getType(), function():void {
				//target = tar ;
				//__thisObject = o ; 
				//__function = f ;
				//__params = arr ;
			//});
		//}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get isCancellableNow():Boolean { return __isCancellable }
	}
}