package naja.model.commands 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import naja.model.commands.I.ICommand;
	
	/**
	 * ...
	 * @author saz
	 */
	public class WaitCommand extends BasicCommand implements ICommand
	{
		protected var _timer:Timer ;
		protected var _delay:Number ;
		protected var _isCancellable:Boolean = false ;
//////////////////////////////////////////////////////////////CONSTRUCTOR
		public function WaitCommand(delay:Number = 1000) 
		{
			super() ;
			_delay = delay ;
		}
//////////////////////////////////////////////////////////////EXECUTING
		public function execute():Boolean
		{
			_isCancellable = true ;
			_timer = new Timer(_delay, 1) ;
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, executeCompleteHandler) ;
			_timer.start() ;
			return true ;
		}
		
//////////////////////////////////////////////////////////////WAITING
		protected function executeCompleteHandler(e:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, executeCompleteHandler ) ;
			_timer.stop() ;
			_timer = null ;
			_isCancellable = false ;
			dispatchComplete() ;
		}
//////////////////////////////////////////////////////////////CANCELING
		public function cancel():Boolean {
			var s:Boolean = _isCancellable ;
			if (s) {
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, executeCompleteHandler ) ;
				_timer.stop() ;
				_timer = null ;
			}
			delete this ;
			return s ;
		}
		public function get isCancellableNow():Boolean {
			return _isCancellable ;
		}
	}
	
}