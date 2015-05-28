package pro.steps 
{
	import flash.events.Event;
	import of.app.required.commands.Command;
	import of.app.required.commands.DifferedCommand;
	import of.app.required.context.XContext;
	import of.app.required.loading.XLoader;
	import of.app.required.steps.VirtualSteps;
	import of.app.Root;
	import pro.exec.modules.HomeModule;
	import tools.grafix.Draw;
	import tools.layer.Layer;
	/**
	 * ...
	 * @author saz
	 */
	public class HomeStep extends CustomStep
	{
		private var __homeModule:HomeModule;
		
		public function HomeStep(__id:String, __xmlSections:XML) 
		{
			super( __id , __xmlSections) ;
		}
		
		override public function resume(cond:Boolean = true):void 
		{
			var layer:Layer ;
			if (cond) {
				if(!Boolean(__homeModule)) __homeModule = new HomeModule() ;
				if (!Boolean(contents as XML)) {
					loadHome() ;
				}else {
					resumeHome() ;
				}
			}else {
				__homeModule.launch(this, false) ;
			}
		}
		
		private function loadHome():void 
		{
			var loader:XLoader = new XLoader() ;
			var url:String = '../xml/' + xml.attribute('content')[0].toXMLString() ;
			loader.addRequestByUrl(url) ;
			loader.addEventListener(Event.COMPLETE, function(e:Event):void {
				loader.removeEventListener(e.type, arguments.callee) ;
				contents = loader.getAllResponses()[0] ;
				resumeHome() ;
			}) ;
			loader.load() ;
		}
		
		private function resumeHome():void 
		{
			__homeModule.launch(this) ;
		}
		
		public function dispatchHomeComplete():void 
		{
			DifferedCommand(commandOpen).dispatchComplete() ;
		}
	}

}