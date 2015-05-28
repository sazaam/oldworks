package naja.model.control.dialog 
{
	import flash.events.Event;
	import naja.model.commands.Command;
	import naja.model.commands.CommandQueue;
	import naja.model.commands.I.ICommand;
	import naja.model.commands.Wait;
	import naja.model.steps.I.IStep;
	import naja.model.steps.Step;
	import naja.model.steps.VirtualSteps;
	import naja.model.data.lists.Gates ;
	
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
		
		public function AddressHierarchy()
		{
			functions = new VirtualSteps("ALL") ;
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
			
			if (__commandQueue.length > 0) __commandQueue.execute() ;
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
			var finalPathes = [] ;
			var c:CommandQueue = __commandQueue ;
			var curC:ICommand ;
			var rightCommand:Command ;
			var l:int = pathes.length ;
			var basePath:String = String(functions.id) || "ALL" //pathes[0] ;
			var path:String = basePath ;
			__steps = [] ;
			for (var i:int = 0; i < l; i++ ) {
				var curPath = pathes[i] ;
				rightCommand = new Command(this, function(pth:String, str:String, ind:int) {
					var actual:String = pth + '/' + str ;
					
					var executer:VirtualSteps = getDeep(pth) ;
					var launched:VirtualSteps = getDeep(actual) ;
					__currentPath = actual ;
					if (__oldPathes) {
						var skipable:Boolean = __oldPathes[ind] == actual ;
						if (__oldPathes[ind + 1]) {
							if (!launchingPathes[ind + 1] ) {
								if (launched.currentStep) {
									try 
									{
										launched.currentStep.stop() ;
									}catch (e:Error)
									{
										
									}
								}
							}else {
								
							}
						}else {
							
						}
						execute(executer, launched, skipable) ;
					}else {
						execute(executer, launched) ;
					}
					
				},path,curPath,i) ;
				
				curC = new CommandQueue(Wait(__delay),rightCommand) ;
				c.add(curC) ;
				
				path = path + "/" + curPath ;
				
				finalPathes.push(path) ;
			}
			return finalPathes ;
		}
		
		private function execute(executer:VirtualSteps, launched:VirtualSteps, skipable:Boolean = false):void
		{
			if (skipable) {
				
			}else {
				__steps.push(__currentPath) ;
				executer.launch(launched.id) ;
			}
		}
		public function get depth():int {
			return __steps.length ;
		}
		public function get delay():Number { return __delay }
		public function set delay(value:Number):void 
		{ __delay = value }
	}
}