package testing 
{
	import flash.events.Event;
	import of.app.required.commands.Command;
	import of.dns.of_local ;
	/**
	 * ...
	 * @author saz
	 */
	public class DifferedCommand extends Command 
	{
		use namespace of_local ;
		
		public function DifferedCommand(thisObject:Object,func:Function, ...params:Array) 
		{
			super(thisObject, func, params) ;
		}
		override public function execute():Boolean {
			var c:Boolean = true ;
			try {
				__isCancellable = true ;
				trace('PARAMS', __params)
				__function.apply(__thisObject, __params) ;
			}catch (e:Error)
			{
				c = false ;
				throw(e) ;
			}
			return c ;
		}
		override public function dispatchComplete():void {
			__isCancellable = false ;
			super.dispatchComplete() ;
		}
		public function dispatchClose():void 
		{
			dispatchEvent(new Event(Event.CUT)) ;
		}
	}

}