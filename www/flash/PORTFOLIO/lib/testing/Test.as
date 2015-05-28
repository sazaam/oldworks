package testing 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	import of.app.required.commands.Command;
	import of.app.required.commands.CommandQueue;
	import of.app.required.steps.E.StepEvent;
	import of.app.required.steps.Hierarchy;
	import of.app.required.steps.VirtualSteps;
	//import of.app.required.loading.XLoader;
	//import of.app.required.steps.VirtualSteps;
	/**
	 * ...
	 * @author saz
	 */
	public class Test extends Sprite
	{
		private var h:Hierarchy;
		private var unique:VirtualSteps;
		private var step1:VirtualSteps;
		private var step2:VirtualSteps;
		private var step3:VirtualSteps;
		private var __ind:int = -1 ;
		private var steps:Array;
		
		public function Test() 
		{
			unique = new VirtualSteps('ALL', new Command(this, cOUnique)) ;
			//unique.setUnique() ;
			//unique.play() ;
			
			
			h = new Hierarchy() ;
			h.setAll(unique)
			h.commandQueue.addEventListener(Event.COMPLETE, onQueueComplete) ;
			unique.play() ;
			//var c:DifferedCommand = new DifferedCommand(unique, onOpen, true) ;
			//var cQ:CommandQueue = new CommandQueue().init(c, c, c) ;
			//cQ.addEventListener(Event.COMPLETE, onQueueComplete) ;
			//cQ.execute() ;
		}
		
		private function onQueueComplete(e:Event):void 
		{
			trace('!!!! definitively complete !!!!')
		}
		
		//private function onComplete(e:Event):void 
		//{
			//trace('COMPLETE')
		//}
		//
		private function cOUnique():void 
		{	
			var cO:DifferedCommand = new DifferedCommand(this, onOpen) ;
			//var cO2:Command = new Command(this, onOpenFake) ;
			var cC:Command = new Command(this, onOpen, false) ;
			
			step1 = unique.add(new VirtualSteps('PORTFOLIO', cO, cC)) ;
			//step2 = VirtualSteps(step1.add(new VirtualSteps('1', cO2, cC))) ;
			step2 = VirtualSteps(step1.add(new VirtualSteps('1', cO, cC))) ;
			step3 = VirtualSteps(step2.add(new VirtualSteps('EXAMPLE', cO, cC))) ;
			
			steps = [step1, step2, step3] ;
			
			
			h.redistribute('PORTFOLIO/1/EXAMPLE') ;
			
			
			setTimeout(h.redistribute, 1000, 'PORTFOLIO') ;
		}
		
		private function onOpenFake():void 
		{
			trace('onOpenFake') ;
			__ind ++ ;
		}
		
		private function onOpen(cond:Boolean = true):void 
		{
			if (cond) {
				trace('A new Step is opening')
				__ind ++ ;
				var index:int = __ind ;
				var loader:URLLoader = new URLLoader() ;
				loader.dataFormat = URLLoaderDataFormat.BINARY ;
				var url:String = '../xml/sections/portfolio.xml' ;
				loader.addEventListener(Event.COMPLETE, function(e:Event):void {
					loader.removeEventListener(e.type, arguments.callee) ;
					var response:XML = XML(e.target.data) ;
					resume(response, index) ;
				}) ;
				loader.load(new URLRequest(url)) ;
				//trace('STEP OPENED') ;
			}else {
				__ind -- ;
				//trace('STEP CLOSED') ;
				
				
				trace('A Step is closing')
			}
		}
		
		private function resume(xml:XML, index:int):void 
		{
			var step:VirtualSteps = VirtualSteps(steps[index]) ;
			step.xml = xml ;
			trace(step.xml) ;
			DifferedCommand(step.commandOpen).dispatchComplete() ;
		}
	}
}