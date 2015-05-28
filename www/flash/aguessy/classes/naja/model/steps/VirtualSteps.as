package naja.model.steps 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import naja.model.commands.Command;
	import naja.model.commands.I.ICommand;
	import naja.model.steps.E.StepEvent;
	import naja.model.steps.I.IBasicStep;
	import naja.model.steps.I.IStep;
	
	/**
	 * ...
	 * @author saz
	 */
	public class VirtualSteps extends StepList implements IStep, IBasicStep
	{
		public var commandOpen:ICommand ;
		public var commandClose:ICommand ;
		
		private var __xml:XML ;
		private var __userData:Object = {} ;
		
		private var _currentStep:IStep ;
		public var playhead:int ;
		public var history:Array ;
		private var _debug:Boolean;
		private var _index:int;
		private var _depth:int;
		private var _id:Object;
		private var _parent:VirtualSteps;
		private var _isCancellable:Boolean;
		protected var _opened:Boolean;
		private var launchFunction:Function = function(e:StepEvent):void { launch() } ;
///////////////////////////////////////////////////////////////////////////CONSTRUCTOR
		public function VirtualSteps(__id:Object= null,_commandOpen:ICommand = null,_commandClose:ICommand = null)
		{
			if (_commandOpen) commandOpen = _commandOpen ;
			if (_commandClose) commandClose = _commandClose ;
			_id = __id ;
			playhead = -1 ;
			history = [] ;
			
			_depth = 0 ;
			
			super();
			
			//if(stepsData) append(stepsData) ;
		}

///////////////////////////////////////////////////////////////////////////APPEND
		//public function append(stepsData:Object):void
		//{
			//if (stepsData is Array) {
				//
				//var arr:Array = stepsData as Array ;
				//for (var i:int = 0, l:int = arr.length ; i < l ; i++ ) {
					//history.push(IStep(arr[i])) ;
					//add(IStep(arr[i])) ;
				//}
			//} else {
				//var dict:Dictionary = stepsData as Dictionary ;
				//for (var s:String in dict) {
					//history.push(IStep(arr[i])) ;
					//add(IStep(dict[s])) ;
				//}
			//}
		//}
		override public function add(_step:IStep):IStep {
			_step.parent = this ;
			history.push(_step) ;
			_step.depth = _depth + 1 ;
			_step.index = history.indexOf(_step) ;
			return super.add(_step) ;
		}
		override public function remove(_id:Object = null):IStep {
			
			var item:IStep = super.remove(_id) ;
			item.index = -1 ;
			item.depth = 0 ;
			var n:int = history.indexOf(item) ;
			history = history.slice(0, n).concat(history.slice(n + 1, history.length));
			if(playhead == n) playhead -- ;
			item.parent = null ;
			return item ;
		}
		public function removeAll():void {
			for (var i:String in _gates) {
				remove(_gates[i].id) ;
			}
		}
///////////////////////////////////////////////////////////////////////////LAUNCH
		public function launch(_num:Object = -1):void
		{
			if (_isCancellable == true ) _isCancellable = false ;
			//if (history.length == 0) trace("No such int callable Step in HistoryList... " + _id) ;
			
			if (_num == -1) return ;

			if (_currentStep && currentStep.id != _num) {
				_currentStep.stop() ;
			}
			if (_num is String) {
				_currentStep = _gates[_num] ;
			}else if(_num is IStep){
				_currentStep = IStep(_num) ;
			}else {
				_currentStep = gates.merged[_num] ;
			}
			var n:int = history.indexOf(_currentStep) ;
			//trace('Yo Launched' + _currentStep.id) ;
			_currentStep.play() ;
			playhead = n ;
		}
		public function kill(_id:Object = null):void
		{
			if (_id == null) {
				if (_currentStep) _currentStep.stop() ;
				
			}else if (_id is VirtualSteps) {
				
				var step:VirtualSteps = VirtualSteps(_id) ;
				//if(step.)
			}else if (_id is String) {
				var ref:String = String(_id) ;
			}else if (_id is int) {
				var refInt:int = int(_id) ;
			}
			_currentStep = null ;
			playhead = -1 ;
		}
		public function closeCurrentStep():void
		{
			var step:IStep = _currentStep ;
			
			step.addEventListener(StepEvent.CLOSE, function(e:StepEvent) {
				step.removeEventListener(StepEvent.CLOSE, arguments.callee) ;
			}) ;
			if(step is VirtualSteps  && VirtualSteps(step).currentStep) VirtualSteps(step).closeCurrentStep() ;
			step.close() ;
		}
///////////////////////////////////////////////////////////////////////////NEXT
		public function hasNext():Boolean {
			if (IStep(history[playhead+1])) {
				return true ;
			}else return false ;
		}
		public function next():int {
			if (hasNext()) launch(playhead+1) ;
			else trace("NO STEP FURTHER") ;
			return playhead ;
		}
///////////////////////////////////////////////////////////////////////////PREV
		public function hasPrev():Boolean {
			if (IStep(history[playhead-1])) {
				return true ;
			}else return false ;
		}
		public function prev():int {
			if (hasPrev()) launch(playhead-1) ;
			else trace("NO ANTERIOR STEP") ;
			return playhead ;
		}
///////////////////////////////////////////////////////////////////////////INTERFACE IMPLEMENTATION

///////////////////////////////////////////////////////////////////////////EVENT HANDLING
		private function onCommandOpenComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			dispatchStep() ;
		}
		private function onCommandCloseComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			_currentStep = null ;
			
			dispatchClose() ;
		}
		private function onCancel(e:Event):void 
		{
			commandOpen.removeEventListener(e.type, arguments.callee) ;
			_isCancellable = false ;
			dispatchCancel() ;
		}
////////////////////////////////////////////////////////////////////ISTEP
		public function get id():Object {
			return _id ;
		}
		public function play():void {
			_isCancellable = true ;
			
			if (commandOpen) {
				if(!hasEventListener(StepEvent.OPEN)) addEventListener(StepEvent.OPEN, launchFunction )
			}
			open() ;
		}
///////////////////////////////////////////////////////////////////////////STOP
		public function stop():void
		{
			if (_currentStep) {
				//trace("SHOULD STOP : "+_currentStep.id+"  from "+id)
				try 
				{
				//trace(_currentStep)
					_currentStep.stop() ;
				}catch (e:Error)
				{
					//trace(e) ;
				}
			}
			if (debug) trace("STEP STOPPING : " + _id) ;
			if (_isCancellable) trace("MAYBE SHOULD CANCEL")
			if (commandOpen) {
				if(!hasEventListener(StepEvent.OPEN)) removeEventListener(StepEvent.OPEN, launchFunction )
			}
			
			close() ;
		}
////////////////////////////////////////////////////////////////////IBASICSTEP
		public function cancel():Boolean
		{
			if (_currentStep) {
				_currentStep.addEventListener(StepEvent.CANCEL, onStepCancelled)
				return _currentStep.cancel() ;
			}else {
				if (_isCancellable && commandOpen) {
					commandOpen.removeEventListener(Event.COMPLETE, onCommandOpenComplete) ;
					commandOpen.addEventListener(Event.CANCEL, onCancel) ;
					
					return commandOpen.cancel() ;
				}else {
					dispatchCancel()  ;
					return false ;
				}
			}
		}
		
		private function onStepCancelled(e:StepEvent):void 
		{
			_currentStep = null ;
			dispatchCancel()  ;
		}
		public function open():void {
			if (commandOpen) {
				commandOpen.addEventListener(Event.COMPLETE, onCommandOpenComplete)
				commandOpen.execute() ;
			}else {
				dispatchStep() ;
			}
		}
		public function close():void {
			if (commandClose) {
				commandClose.addEventListener(Event.COMPLETE, onCommandCloseComplete)
				commandClose.execute() ;
			}else {
				dispatchClose() ;
				_currentStep = null ;
			}
		}
		public function dispatchStep():void {
			_opened = true ;
			if(hasEventListener(StepEvent.OPEN)) dispatchEvent(new StepEvent(StepEvent.OPEN,false,false,_id)) ;
		}
		public function dispatchClose():void {
			_opened = false ;
			if(hasEventListener(StepEvent.CLOSE)) dispatchEvent(new StepEvent(StepEvent.CLOSE,false,false,_id)) ;
		}
		public function dispatchCancel():void
		{
			_opened = false ;
			if(hasEventListener(StepEvent.CANCEL)) dispatchEvent(new StepEvent(StepEvent.CANCEL,false,false,_id)) ;
		}
///////////////////////////////////////////////////////////////////////////GETTERS & SETTERS
		public function set debug(value:Boolean):void 
		{
			for (var i:int = 0; i < history.length ; i++ ) {
				if(Step(history[i])) Step(history[i]).debug = value ;
			}
			_debug = value;
		}
		public function get debug():Boolean
		{
			return _debug ;
		}
		
		public function get currentStep():IStep { return _currentStep }
		public function get isCancellableNow():Boolean { return _isCancellable }
		

		
		public function get parent():VirtualSteps { return _parent }
				
		public function set parent(value:VirtualSteps):void 
		{
			//value.add(VirtualSteps(_parent.remove(this))) ;
			_parent = value ;
		}
		
		public function get index():int { return _parent? _parent.gates.merged.indexOf(this) : _index }
		public function set index(value:int):void 
		{ _index = value }
		
		public function get xml():XML { return __xml }
		public function set xml(value:XML):void 
		{ __xml = value	}
		public function get userData():Object { return __userData }
		public function set userData(value:Object):void 
		{ __userData = value }
		
		public function get opened():Boolean { return _opened }
		
		public function get depth():int { return _depth }
		public function set depth(value:int):void 
		{ _depth = value }
		

		override public function toString():String 
		{return "[ Object VirtualStep  "+gates+" ] "+_id }
	}
}