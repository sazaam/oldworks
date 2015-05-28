package naja.model.commands 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import naja.model.commands.I.ICommand;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class Command extends BasicCommand implements ICommand
	{
		protected var _thisObject : Object;
		protected var _function : Function;
		protected var _params : Array;
		protected var _isCancellable : Boolean = false;
		
		public function Command(thisObject:Object,func:Function, ...params) 
		{
			super() ;
			_thisObject = thisObject ;
			_function = func ;
			_params = params ;
		}

		public function execute():Boolean {
			try 
			{
				_isCancellable = true ;
				_function.apply(_thisObject, _params) ;
			}
			catch (e:Error)
			{
				throw(e) ;
			}
			_isCancellable = false ;
			dispatchComplete();
			return true ;
		}
		
		//
		public function cancel():Boolean {
			var s:Boolean = _isCancellable ;
			dispatchCancel() ;
			delete this ;
			return s ;
		}
		
		public function get isCancellableNow():Boolean { return _isCancellable }
		
	}
}