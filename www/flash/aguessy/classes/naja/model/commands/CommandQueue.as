package naja.model.commands 
{
	import flash.events.Event;
	import naja.model.commands.I.ICommand;
	
	/**
	 * ...
	 * @author saz
	 */
	public class CommandQueue extends Commands implements ICommand
	{
		private var _isCancellable:Boolean;
//////////////////////////////////////////////////////////////CONSTRUCTOR
		public function CommandQueue(...commandArray) 
		{
			super(commandArray) ;
		}
//////////////////////////////////////////////////////////////EXECUTING
		public function execute():Boolean
		{
			_index = 0 ;
			doNext();
			return true ;
		}
//////////////////////////////////////////////////////////////QUEUEING
		protected function doNext():void
		{
			//trace(_commands[ _index ])
			//trace(_commands[ _index ])
			_isCancellable = true ;
			var c :ICommand = _commands[ _index ];
			c.addEventListener(Event.COMPLETE, doNextCompleteHandler);
			c.execute();
		}
		
		protected function doNextCompleteHandler( e:Event ):void
		{
			_isCancellable = false ;
			e.target.removeEventListener(e.type, arguments.callee);
			
			_index ++;
			if (_index == _commands.length ) {
				//trace("QUEUE COMPLETE") ;
				dispatchComplete();
			}else {
				doNext();
			}		
		}
//////////////////////////////////////////////////////////////CANCELING
		public function cancel():Boolean {
			var s:Boolean = _isCancellable ;
			if (s) {
				var c:ICommand = _commands[_index] ;
				c.removeEventListener(Event.COMPLETE, doNextCompleteHandler);
				_isCancellable = false ;
			}
			empty();
			dispatchCancel();
			delete this ;
			return s ;
		}
		private function empty():void
		{
			var l:int = _commands.length ;
			
			while (l--) {
				trace(l >= _index?"REMAINIG :: "+_commands[ l ] : "PASSED :: "+_commands[ l ] ) ;
				var s:ICommand = ICommand(_commands[l] );
				s.cancel();
				_commands[l] = null ;
				delete _commands[ l ];
				_commands.pop() ;
			}
			
			_commands = [] ;
		}
		public function get isCancellableNow():Boolean {
			return _isCancellable ;
		}
		public function get index():int {
			return _index ;
		}
	}
}