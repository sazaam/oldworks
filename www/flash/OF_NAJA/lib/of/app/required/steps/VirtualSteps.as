package of.app.required.steps 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import of.app.required.commands.I.ICommand;
	import of.app.required.data.Gates;
	import of.app.required.steps.E.StepEvent;
	import of.app.required.steps.I.IStep;
	import of.dns.of_local;
	
	import naja.dns.of_local ;
	
	/**
	 * ...
	 * @author saz
	 */
	public class VirtualSteps extends StepList implements IStep
	{
		use namespace of_local ;
		
		private var __commandOpen:ICommand ;
		private var __commandClose:ICommand ;
		
		of_local var __xml:XML ;
		of_local var __userData:Object = {} ;
		of_local var __currentStep:IStep ;
		of_local var __playhead:int ;
		of_local var history:Array ;
		of_local var __index:int;
		of_local var __depth:int;
		of_local var __id:Object;
		of_local var __ancestor:VirtualSteps;
		of_local var __parent:VirtualSteps;
		of_local var __isCancellable:Boolean;
		
		protected var __opened:Boolean;
		private var __definition;
		private var __debug:Boolean;
		private var __genealogy:String;
		private static var __default:VirtualSteps;
		public static var ASYNC_ADDRESS:Boolean;

		//////////////////////////////////////////////////////// CTOR
		public function VirtualSteps(_id:Object = null,_commandOpen:ICommand = null,_commandClose:ICommand = null,_steps:Gates = null)
		{
			var args:Array = [_id, _commandOpen, _commandClose, _steps] ;
			init.apply(null, args) ;
		}
		override protected function init(...params:Array):void {
			super.init(params[3]) ;
			if(Boolean(params[0])) __id = params[0] ;
			if(Boolean(params[1])) commandOpen = params[1] ;
			if(Boolean(params[2])) commandClose = params[2] ;
			history = [] ;
		}
		///////////////////////////////////////////////////////////////////////////APPEND
		override public function add(step:IStep):IStep {
			step.parent = this ;
			history.push(step) ;
			step.depth = __depth + 1 ;
			step.index = history.indexOf(step) ;
			return super.add(step) ;
		}
		override public function remove(_id:Object = null):IStep {
			
			var item:IStep = super.remove(_id) ;
			item.index = -1 ;
			item.depth = 0 ;
			var n:int = history.indexOf(item) ;
			history = history.slice(0, n).concat(history.slice(n + 1, history.length));
			if(__playhead == n) __playhead -- ;
			item.parent = null ;
			return item ;
		}
		public function removeAll():void {
			for (var i:String in __gates) {
				remove(__gates[i].id) ;
			}
		}
///////////////////////////////////////////////////////////////////////////LAUNCH
protected function launchFunction(e:StepEvent):void { launch() } ;

public function launch(_num:Object = -1):void
		{
			if (__isCancellable == true ) __isCancellable = false ;
			//if (history.length == 0) trace("No such int callable Step in HistoryList... " + __id) ;
			if (_num == -1) return ;
			if (__currentStep && currentStep.id != _num && __currentStep.opened) {
				__currentStep.stop() ;
			}
			if (_num is String) {
				__currentStep = __gates[_num] ;
			}else if(_num is IStep){
				__currentStep = IStep(_num) ;
			}else {
				__currentStep = __gates.merged[_num] ;
			}
			var n:int = history.indexOf(__currentStep) ;
			__currentStep.play() ;
			__playhead = n ;
		}
		public function closeCurrentStep():void
		{
			var step:IStep = __currentStep ;
			step.addEventListener(StepEvent.CLOSE, function(e:StepEvent) {
				step.removeEventListener(StepEvent.CLOSE, arguments.callee) ;
			}) ;
			if(step is VirtualSteps  && VirtualSteps(step).currentStep) VirtualSteps(step).closeCurrentStep() ;
			step.close() ;
		}
///////////////////////////////////////////////////////////////////////////NEXT
		public function hasNext():Boolean {
			if (getNext()) {
				return true ;
			}else return false ;
		}
		
		public function getNext():VirtualSteps
		{
			return VirtualSteps(history[__playhead + 1]) ;
		}
		public function next():int {
			if (hasNext()) launch(getNext()) ;
			else trace("NO STEP FURTHER") ;
			return __playhead ;
		}
///////////////////////////////////////////////////////////////////////////PREV
		public function hasPrev():Boolean {
			if (getPrev()) {
				return true ;
			}else return false ;
		}
		
		public function getPrev():VirtualSteps
		{
			return VirtualSteps(history[__playhead - 1]) ;
		}
		public function prev():int {
			if (hasPrev()) launch(getPrev()) ;
			else trace("NO ANTERIOR STEP") ;
			return __playhead ;
		}
		public function getStep(ref:*):VirtualSteps 
		{
			return VirtualSteps(__gates.getElement(ref)) ;
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
			//__currentStep = null ;
			
			dispatchClose() ;
		}
		private function onCancel(e:Event):void 
		{
			commandOpen.removeEventListener(e.type, arguments.callee) ;
			__isCancellable = false ;
			dispatchCancel() ;
		}
////////////////////////////////////////////////////////////////////ISTEP
		public function play():void {
			__isCancellable = true ;
			
			if (commandOpen) {
				if(!hasEventListener(StepEvent.OPEN)) addEventListener(StepEvent.OPEN, launchFunction )
			}
			open() ;
		}
///////////////////////////////////////////////////////////////////////////STOP
		public function stop():void
		{
			if (__currentStep) {
				try 
				{
					__currentStep.stop() ;
				}catch (e:Error)
				{
					//trace(e) ;
				}
			}
			if (commandOpen) {
				if(!hasEventListener(StepEvent.OPEN)) removeEventListener(StepEvent.OPEN, launchFunction )
			}
			close() ;
		}
////////////////////////////////////////////////////////////////////IBASICSTEP
		public function cancel():Boolean
		{
			if (__currentStep) {
				__currentStep.addEventListener(StepEvent.CANCEL, onStepCancelled)
				return __currentStep.cancel() ;
			}else {
				if (__isCancellable && commandOpen) {
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
		public function close():void{
			if (commandClose) {
				commandClose.addEventListener(Event.COMPLETE, onCommandCloseComplete)
				commandClose.execute() ;
			}else {
				dispatchClose() ;
			}
		}
		public function dispatchStep():void {
			__opened = true ;
			if(hasEventListener(StepEvent.OPEN)) dispatchEvent(new StepEvent(StepEvent.OPEN,false,false,__id)) ;
		}
		public function dispatchClose():void {
			__opened = false ;
			if(hasEventListener(StepEvent.CLOSE)) dispatchEvent(new StepEvent(StepEvent.CLOSE,false,false,__id)) ;
		}
		public function dispatchCancel():void
		{
			__opened = false ;
			if(hasEventListener(StepEvent.CANCEL)) dispatchEvent(new StepEvent(StepEvent.CANCEL,false,false,__id)) ;
		}
		
///////////////////////////////////////////////////////////////////////////GETTERS & SETTERS
		private function getAncestor():VirtualSteps
		{
			var s:VirtualSteps = this ;
			var g:String = String(s.id) ;
			while (Boolean(s.parent as VirtualSteps)) {
				g = String(s.parent.id) + "/"+g ;
				s = s.parent ;
			}
			__genealogy = g ;
			return s ;
		}
		override public function toString():String 
		{return "[ Object "+ getQualifiedClassName(this) +"  "+ __id+ ' gates >> ' +__gates+" ]" }
		
		public function set debug(value:Boolean):void 
		{
			for (var i:int = 0; i < history.length ; i++ ) {
				if(IStep(history[i])) IStep(history[i])["debug"] = value ;
			}
			__debug = value;
		}
		public function get debug():Boolean
		{
			return __debug ;
		}
		public function get id():Object { return __id ; }
		public function set id(value:Object):void { __id = value; }
		public function get currentStep():IStep { return __currentStep }
		public function get isCancellableNow():Boolean { return __isCancellable }
		public function get parent():VirtualSteps { return __parent }
		public function set parent(value:VirtualSteps):void 
		{
			__parent = value ;
		}
		public function get index():int { return __parent? __parent.gates.merged.indexOf(this) : __index }
		public function set index(value:int):void 
		{ __index = value }
		public function get xml():XML { return __xml }
		public function set xml(value:XML):void 
		{ __xml = value	}
		public function get userData():Object { return __userData }
		public function set userData(value:Object):void 
		{ __userData = value }
		public function get opened():Boolean { return __opened }
		public function get ancestor():VirtualSteps { 
			__ancestor = getAncestor() ;
			return __ancestor ;
		}
		public function get depth():int { return __depth }
		public function set depth(value:int):void 
		{ __depth = value }
		public function get playhead():int { return __playhead }
		
		public function get genealogy():String { 
			if (!Boolean(__genealogy as String))
				getAncestor() ;
			return __genealogy ;
		}
		
		public function get defaultStep():VirtualSteps { return __default; }
		
		public function get commandOpen():ICommand { return __commandOpen; }
		public function set commandOpen(value:ICommand):void 
		{ __commandOpen = value; }
		
		public function get commandClose():ICommand { return __commandClose; }
		public function set commandClose(value:ICommand):void 
		{ __commandClose = value; }
		
	}
}