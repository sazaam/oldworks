package of.app.required.steps 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import of.app.required.commands.Command;
	import of.app.required.commands.CommandQueue;
	import of.app.required.commands.DifferedCommand;
	import of.app.required.commands.E.CommandQueueEvent;
	import of.app.required.commands.I.ICommand;
	import of.app.required.steps.E.StepEvent;
	import of.app.required.steps.I.IStep;
	import of.app.required.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class Hierarchy
	{
		////////////////////////////////////////////////////// VARS
		protected var __functions:VirtualSteps ;
		protected var __commandQueue:CommandQueue;
		protected var __exPath:String;
		protected var __neoPath:String;
		protected var __stepPathes:Dictionary;
		protected var __changer:AddressChanger;
		protected var __commands:Dictionary;
		protected var __asynchronious:Boolean;
		////////////////////////////////////////////////////// CTOR
		public function Hierarchy() 
		{
			__commands = new Dictionary() ;
			__asynchronious = false ;
		}
//////////////////////////////////////////////////////////////////////////////////////////////// INIT
		public function init():Hierarchy
		{
			trace(this, 'inited...') ;
			return this ;
		}
		//////////////////////////////////////////////////////////////////////////////////////////////// SETS
		public function setAll(f:VirtualSteps, addressChanger:AddressChanger = null):VirtualSteps
		{
			__functions = f ;
			__functions.setUnique() ;
			__functions.hierarchies[__functions.id][__functions.id] = __functions ;
			__changer = addressChanger || new AddressChanger() ;
			__changer.setHierarchy(this) ;
			
			__commandQueue = new CommandQueue() ;
			return f ;
		}
		//////////////////////////////////////////////////////////////////////////////////////////////// ADD
		public function add(step:VirtualSteps, at:String = null):IStep
		{
			return IStep( Boolean(at)? getDeep(at).add(step) : __functions.add(step)) ;
		}
		//////////////////////////////////////////////////////////////////////////////////////////////// REMOVE
		public function remove(id:Object, at:String):IStep
		{
			return IStep( Boolean(at)? getDeep(at).remove(id) : __functions.remove(id)) ;
		}
		//////////////////////////////////////////////////////////////////////////////////////////////// GET DEEP
		public function getDeep(path:String):VirtualSteps
		{
			return VirtualSteps.hierarchies[__functions.id][path] ;
		}
		//////////////////////////////////////////////////////////////////////////////////////////////// STATIC GET DEEP
		static public function getDeepAt(referenceHierarchy:String, path:String):VirtualSteps
		{
			return VirtualSteps.hierarchies[referenceHierarchy][path] ;
		}
//////////////////////////////////////////////////////////////////////////////////////////////// CORE FUNC
		//////////////////////////////////////////////////////////////////////////////////////////////// REDISTRIBUTE
		public function redistribute(path:String):void
		{
			launchDeep(path) ;
		}
		//////////////////////////////////////////////////////////////////////////////////////////////// LAUNCH DEEP
		protected function launchDeep(path:String):void
		{
			if (__commandQueue.isCancellableNow) {
				__commandQueue.cancel() ;
			}
			__commandQueue.reset() ;
			formulate(path) ;
			trace(path, functions.id, __commandQueue.length)
			__commandQueue.addEventListener(Event.COMPLETE, onCommandQueueFinish) ;
			__commandQueue.execute() ;
		}
		//////////////////////////////////////////////////////////////////////////////////////////////// FORMULATE
		private function formulate(path:String):void
		{
			var declared:String ;
			if (path == __exPath) return ;
			if (Boolean(__exPath)) declared = __exPath ;
			else declared = '' ;
			var commands:Array = [] ;
			var useful:Array ;
			var removables:Array ;
			var addables:Array ;
			var removablesLength:int ;
			var addablesLength:int ;
			useful = comparePaths(path, declared) ;
			removables = useful.removables ;
			removablesLength = removables.length ;
			addables = useful.addables ;
			addablesLength = addables.length ;
			for (var i:int = 0 ; i < removablesLength ; i++ ) 
				commands.push(createCommandClose(removables[i])) ;
			for (var j:int = 0 ; j < addablesLength ; j++ ) 
				commands.push(createCommandOpen(addables[j])) ;
			__exPath = path ;
			
			__commandQueue.init.apply(null, commands) ;
		}
		//////////////////////////////////////////////////////////////////////////////////////////////// COMMANDS
		private function createCommandOpen(path:String):Command 
		{
			var c:DifferedCommand = new DifferedCommand(null, openCommand) ;
			c.params = [path, c] ;
			return c ;
		}
		private function openCommand(path:String, command:DifferedCommand):void 
		{
			var st:VirtualSteps = getDeep(__functions.id + '/' + path) ;
			if (st.commandOpen) {
				//if (!asynchronious) {
					//st.commandOpen.addEventListener(Event.COMPLETE, function(e:Event):void {
						//st.commandOpen.removeEventListener(e.type, arguments.callee) ;
						//command.dispatchComplete() ;
					//}) ;
					
					st.addEventListener(StepEvent.OPEN, function(e:StepEvent):void {
						st.removeEventListener(e.type, arguments.callee) ;
						command.dispatchComplete() ;
					})
				//}else {
					//command.dispatchComplete() ;
				//}
			}else {
				command.dispatchComplete() ;
			}
			st.parent.launch(st.id) ;
		}
		
		private function dump():void 
		{
			for each(var i:* in VirtualSteps.hierarchies[__functions.id]) {
				trace(i)
			}
		}
		private function createCommandClose(path:String):Command 
		{
			var c:DifferedCommand =  new DifferedCommand(null, closeCommand) ;
			c.params = [path, c] ;
			return c ;
		}
		private function closeCommand(path:String, command:DifferedCommand):void 
		{
			var st:VirtualSteps = getDeep(__functions.id + '/' + path) ;
			if (!__asynchronious) {
				st.addEventListener(StepEvent.CLOSE, function(e:StepEvent):void {
					command.dispatchComplete() ;
				})
				st.close() ;
			}else {
				st.close() ;
				command.dispatchComplete() ;
			}
		}
		//////////////////////////////////////////////////////////////////////////////////////////////// EVENTS
		private function onCommandQueueReadyToContinue(e:HierarchyEvent):void 
		{
			__commandQueue.continueProcess() ;
		}
		private function onCommandQueueFinish(e:Event):void 
		{
			e.target.removeEventListener(e.type, onCommandQueueFinish) ;
		}
//////////////////////////////////////////////////////////////////////////////////////////////// HELPERS
		private function compareArrays(neo:Array, ex:Array):Array 
		{
			var s:Array = [neo, ex].sortOn('length', Array.DESCENDING), resultArr:Array = [], longest:Array = s[0], shortest:Array = s[1], l:int = longest.length ;
			var path:String = '' ;
			var index:int = -1;
			for (var i:int = 0 ; i < l ; i++ ) {
				var o:String ;
				if (!Boolean(shortest[i])) o = shortest == neo? 'remove_'+ longest[i] : 'add_'+ longest[i] ;
				else {
					if (longest[i] != shortest[i]) o = shortest == neo ? 'remove_' + longest[i] : 'add_' + longest[i] ;
					else {
						o = 'keep' ;
						index = i ;
					}
				}
				resultArr.push(o) ;
			}
			
			var ind:int = resultArr.lastIndexOf('keep') ;
			var removables:Array = ex.splice(index == -1 ? 1 : ind + 1, ex.length) ;
			var addables:Array = neo.splice(ind + 1, neo.length) ;
			removables = joinPath(removables, ex.join('/')).reverse() ;
			addables = joinPath(addables, neo.join('/')) ;
			resultArr.removables = removables ;
			resultArr.addables = addables ;
			return resultArr ;
		}
		private function comparePaths(neo:String, ex:String):Array
		{
			var exArr:Array = pathToArray(ex) ;
			var neoArr:Array = pathToArray(neo) ;
			var compared:Array = compareArrays(neoArr, exArr) ;
			compared.ex = exArr ;
			compared.neo = neoArr ;
			return compared ;
		}
		private function joinPath(p:Array, startPath:String = null):Array 
		{
			var paths:Array = [], base:String = !Boolean(startPath) ? '' : startPath + '/' , result:String, cur:String, l:int = p.length ;
			for (var i:int = 0 ;  i < l ; i++ ) {
				cur = p[i] ;
				paths.push(i == 0 ?  base+ cur : paths[i - 1] + '/' + cur) ;
			}
			return paths ;
		}
		private function pathToArray(path:String):Array
		{
			var sliceBySlash:RegExp = /[^\/]*[^\/]/g ;
			return path.match(sliceBySlash) ;
		}
		private function arrayToPath(pathes:Array):String 
		{
			return pathes.join('/') ;
		}
//////////////////////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get functions():VirtualSteps { return __functions }
		public function get changer():AddressChanger { return __changer }
		public function get commandQueue():CommandQueue { return __commandQueue }
		
		public function get asynchronious():Boolean { return __asynchronious }
		public function set asynchronious(value:Boolean):void { __asynchronious = value }
	}
}