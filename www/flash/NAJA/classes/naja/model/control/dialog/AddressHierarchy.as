package naja.model.control.dialog 
{
	import flash.events.Event;
	import naja.tools.commands.Command;
	import naja.tools.commands.CommandQueue;
	import naja.tools.commands.E.CommandQueueEvent;
	import naja.tools.commands.I.ICommand;
	import naja.tools.commands.Wait;
	import naja.tools.steps.I.IStep;
	import naja.tools.steps.VirtualSteps;
	import naja.tools.lists.Gates ;
	
	/**
	 * ...
	 * @author saz
	 */
	public class AddressHierarchy 
	{
		public var functions:VirtualSteps ;
		protected var __delay:Number = 1 ;
		private var __steps:Array ;
		private var __swfAddressChanger:SWFAddressChanger;
		private var __currentCommand:CommandQueue;
		private var __commandQueue:CommandQueue;
		private var launchingPathes:Array;
		private var __oldPathes:Array;
		private var __currentPath:String;
		private var __autoExec:Boolean;
		private var __stopped:Boolean;
		private var __isSimple:Boolean;
		
		public function AddressHierarchy()
		{
			//
		}
		public function init(_changer:SWFAddressChanger):void
		{
			__swfAddressChanger = _changer ;
		}
		public function add(_id:Object,_onOpen:ICommand = null,_onClose:ICommand = null):IStep
		{
			var s:VirtualSteps = new VirtualSteps(_id, _onOpen, _onClose) ;
			return IStep(functions.add(s)) ;
		}
		public function getAt(p:VirtualSteps,s:String):VirtualSteps
		{
			return VirtualSteps(p.gates[s]) ;
		}
		public function getDeep(s:String):VirtualSteps
		{
			var p:Array = s.split("/") ;
			var l:int = p.length ;
			if (l == 1) {
				return functions ;
			}else {
				var parent:VirtualSteps = getDeep(String(p.shift())) ;
				var child:VirtualSteps ;
				var childName:String ;
				l = p.length ;
				for (var i:int = 0 ; i < l ; i++ ) {
					parent = child || parent ;
					childName = p[i] ;
					child = getAt(parent, childName) ;
				}
			}
			return child ;
		}
		
		//public function removeFrom(_idParent:Object,_id:Object,_onOpen:ICommand,_onClose:ICommand):IStep
		//{
			//return null ;
		//}
		
		public function removeAllFrom(_idParent:Object):void
		{
			for (var i:String in functions.gates) {
				if (i == _idParent) {
					var v:VirtualSteps = VirtualSteps(functions.gates[i]) ;
					v.removeAll() ;
				}
			}
		}
		
		public function remove(_id:Object):IStep
		{
			return IStep(functions.remove(_id)) ;
		}
		
		public function check(...rest:Array):Boolean
		{
			var condition:Boolean ;
			var p:VirtualSteps = functions ;
			condition = rest.every(function(el:*, i:int, arr:Array):Boolean {
				var ref:String = String(el) ;
				var step:IStep = getAt(p, ref) ;
				return step is IStep ;
			})
			//return condition ;
			return true ;
		}
		
		public function redistribute(rest:Array):void
		{
			if (__currentCommand && __currentCommand.isCancellableNow) {
				__currentCommand.cancel() ;
			}
			__swfAddressChanger.debug_tf.appendText("\nrest array : " + String(rest)) ;
			launchDeep(rest) ;
		}
		
		private function launchDeep(pathes:Array):void
		{
			launchingPathes = [];
			__commandQueue = new CommandQueue() ;
			
			__commandQueue.addEventListener(Event.COMPLETE,onWalkingCommandComplete) ;
			launchingPathes = formulateCommand(pathes) ;
			if(!__isSimple) __commandQueue.autoExecute = __autoExec ;
			if(!__commandQueue.autoExecute) __commandQueue.addEventListener(CommandQueueEvent.READY, onReady) ;	
			
			if (__commandQueue.length > 0) __commandQueue.execute() ;
		}
		
		public function dispatchReady(e:Event = null):void
		{
			if(stopped) __commandQueue.dispatchEvent(new CommandQueueEvent("ready")) ;
		}
		
		private function onReady(e:CommandQueueEvent):void 
		{
			__commandQueue.continueProcess() ;
		}
		
		private function onWalkingCommandComplete(e:Event):void 
		{
			__oldPathes = launchingPathes ;
			__swfAddressChanger.formerAddress = specialSplit(launchingPathes.join('__')) ;
		}
		
		private function specialSplit(s:String):String
		{
			var p:Array = s.split('__') ;
			p.forEach(function(el:String, i:int, arr:Array):void {
				p[i] = el.split("/").pop() ;
			}) ;
			return p.join('/') ;
		}
		
		private function formulateCommand(pathes:Array,former:Array = null):Array
		{
			var finalPathes:Array = [] ;
			var __index:int = 0 ;
			var c:CommandQueue = __commandQueue ;
			var curC:ICommand ;
			var rightCommand:Command ;
			var l:int = pathes.length ;
			var basePath:String = String(functions.id) || "ALL" //pathes[0] ;
			var path:String = basePath ;
			__steps = [] ;
			__isSimple = false ;
			for (var i:int = 0; i < l; i++ ) {
				var curPath = pathes[i] ;
				// autres fois que 1eres fois
				rightCommand = new Command(this, function(pth:String, str:String, ind:int) {
					var actual:String = pth + '/' + str ;
					var executer:VirtualSteps = getDeep(pth) ;
					var launched:VirtualSteps = getDeep(actual) ;
					__currentPath = actual ;
						//1ere fois
					if (!Boolean(__oldPathes as Array)) {
						execute(executer, launched) ;
					}else {
						// fois suivantes
						var skipable:Boolean = __oldPathes[ind] == actual ;
						if (__oldPathes[ind + 1]) {
							if (!launchingPathes[ind + 1] ) {
								if (launched.currentStep) {
									launched.currentStep.stop() ;
								}
							}
						}
						execute(executer, launched, skipable) ;
					}
				},path,curPath,i) ;
				curC = new CommandQueue(Wait(1),rightCommand) ;
				c.add(curC) ;
				path = path + "/" + curPath ;
				finalPathes.push(path) ;
			}
			if (Boolean(__oldPathes as Array)) {
				__isSimple = checkIsSimple(__oldPathes, finalPathes) ;
			}
			return finalPathes ;
		}
		
		private function checkIsSimple(old:Array, recent:Array):Boolean
		{
			var p:Array = [].concat(old) , p1:Array;
			var d:Array = [].concat(recent) , p2:Array;
			function rep(el):*{ return el.replace(/^\w+\//i, '') }
			p = p.map(rep) ;
			d = d.map(rep) ;

			if (d.length > p.length) {
				if (p[p.length - 1] == d[d.length - 2]) {
					return true ;
				}
			}else if (d.length < p.length) {
				if (d[d.length - 1] == p[p.length - 2]) {
					return true ;
				}
			}
			
			return false ;
		}
		
		private function execute(executer:VirtualSteps, launched:VirtualSteps, skipable:Boolean = false):void
		{
			if (skipable) {
				//
			}else {
				try 
				{
					__steps.push(__currentPath) ;
					executer.launch(launched.id) ;
				}catch (e:Error)
				{
					trace("Must be a problem with the ID requested, or the supposed to exist step, perhaps it is NOT added in this level's VStep ... "+ this) ;
					throw(e) ;
				}
				
			}
		}
		public function get depth():int { return __steps.length }
		public function get delay():Number { return __delay }
		public function set delay(value:Number):void 
		{ __delay = value }
		
		public function get stopped():Boolean { return __commandQueue.stopped }
		public function get autoExec():Boolean { return __autoExec }
		public function set autoExec(value:Boolean):void 
		{ __autoExec =  value }
		
		public function get isSimple():Boolean { return __isSimple }
	}
}