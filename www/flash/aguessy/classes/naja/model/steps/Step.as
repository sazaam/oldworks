package naja.model.steps
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import naja.model.commands.I.ICommand;
	import naja.model.steps.E.StepEvent;
	import naja.model.steps.I.IBasicStep;
	import naja.model.steps.I.IStep ;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Step extends EventDispatcher implements IStep, IBasicStep 
	{
		public var commandOpen:ICommand ;
		public var commandClose:ICommand ;
		private var _id:Object ;
		private var _index:int ;
		private var _depth:int ;
		private var _parent:VirtualSteps ;
		public var debug:Boolean ;
		private var _isCancellable:Boolean ;
		private var _opened:Boolean;
///////////////////////////////////////////////////////////////////////////CONSTRUCTOR
		public function Step(__id:Object,_commandOpen:ICommand,_commandClose:ICommand = null) 
		{
			_id = __id ;
			commandOpen = _commandOpen ;
			if (_commandClose) commandClose = _commandClose ;
		}
///////////////////////////////////////////////////////////////////////////PLAY
		public function play():void 
		{
			if(debug) trace("STEP PLAYING : " + _id) ;
			open() ;
		}
///////////////////////////////////////////////////////////////////////////STOP
		public function stop():void
		{
			if(debug) trace("STEP STOPPING : " + _id) ;
			close() ;
		}
///////////////////////////////////////////////////////////////////////////EVENT HANDLING
///////////////////////////////////////////////////////////////////////////OPEN
		public function open():void
		{
			_isCancellable = true ;
			commandOpen.addEventListener(Event.COMPLETE, onCommandComplete) ;
			commandOpen.execute() ;
		}
		private function onCommandComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			_isCancellable = false ;
			dispatchStep() ;
		}
		public function dispatchStep():void 
		{
			_opened = true ;
			if (debug) trace("STEP OPENED : " + _id) ;
			
			if(hasEventListener(StepEvent.OPEN)) dispatchEvent(new StepEvent(StepEvent.OPEN,false,false,_id)) ;
		}
///////////////////////////////////////////////////////////////////////////CLOSE
		public function close():void
		{
			if (commandClose) {
				commandClose.addEventListener(Event.COMPLETE, onCommandCloseComplete)
				commandClose.execute() ;
			}else {
				dispatchClose() ;
			}
		}
		private function onCommandCloseComplete(e:Event):void 
		{
			
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			dispatchClose() ;
		}
		public function dispatchClose():void 
		{
			_opened = false ;
			if(debug) trace("STEP CLOSED : " + _id) ;
			if(hasEventListener(StepEvent.OPEN)) dispatchEvent(new StepEvent(StepEvent.CLOSE,false,false,_id)) ;
		}
///////////////////////////////////////////////////////////////////////////CANCEL
		public function cancel():Boolean
		{
			if (commandOpen && _isCancellable) {
				commandOpen.removeEventListener(Event.COMPLETE, onCommandComplete) ;
				commandOpen.cancel() ;
				commandOpen.addEventListener(Event.CANCEL, onCancel) ;
				return _isCancellable ;
			}else {
				dispatchCancel() ;
				return false ;
			}
		}
		private function onCancel(e:Event):void 
		{
			
			commandOpen.removeEventListener(e.type, arguments.callee) ;
			_isCancellable = false ;
			dispatchCancel() ;
		}
		public function dispatchCancel():void
		{
			_opened = false ;
			if(debug) trace("STEP CANCELLED : " + _id) ;
			if(hasEventListener(StepEvent.CANCEL)) dispatchEvent(new StepEvent(StepEvent.CANCEL,false,false,_id)) ;
		}
///////////////////////////////////////////////////////////////////////////GETTER & SETTER
		public function get id():Object { return _id }
		
		public function get isCancellableNow():Boolean { return _isCancellable }
		

		public function get opened():Boolean { return _opened }
		public function get parent():VirtualSteps { return _parent }
		public function set parent(value:VirtualSteps):void 
		{ _parent = value }
		
		public function get index():int { return _index }
		
		public function set index(value:int):void 
		{ _index = value }
		
		public function get depth():int { return _depth }
		public function set depth(value:int):void 
		{ _depth = value }
///////////////////////////////////////////////////////////////////////////TOSTRING
		override public function toString():String {
			return "[Object Step  >> " + String(_id)+" ]" ;
		}

	}
	
}