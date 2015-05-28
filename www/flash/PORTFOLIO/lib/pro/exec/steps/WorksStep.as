package pro.exec.steps 
{
	import flash.events.Event;
	import of.app.required.commands.Command;
	import of.app.required.commands.DifferedCommand;
	import of.app.required.context.XContext;
	import of.app.required.loading.XLoader;
	import of.app.required.steps.VirtualSteps;
	import of.app.Root;
	import pro.exec.ExecuteController;
	import pro.exec.modules.WorksModule;
	import tools.fl.sprites.Smart;
	import tools.grafix.Draw;
	import tools.layer.Layer;
	/**
	 * ...
	 * @author saz
	 */
	public class WorksStep extends CustomStep
	{
		
		public function WorksStep(__id:String, __xmlSections:XML) 
		{
			super( __id , __xmlSections)  ;
		}
		
		override public function resume(cond:Boolean = true):void 
		{
			if (cond) {
				module = new WorksModule(this) ;
				if (!Boolean(contents as XML)) {
					loadWorks() ;
				}else {
					resumeWorks() ;
				}
				//checkBackground() ;
			}else {
				//checkBackground(false) ;
				resumeWorks(false) ;
				contents = null ;
				module = module.destroy() ;
			}
		}
		
		private function loadWorks():void 
		{
			var loader:XLoader = new XLoader() ;
			var url:String = '../xml/' + xml.attribute('content')[0].toXMLString() ;
			loader.addRequestByUrl(url) ;
			loader.addEventListener(Event.COMPLETE, function(e:Event):void {
				loader.removeEventListener(e.type, arguments.callee) ;
				contents = loader.getAllResponses()[0] ;
				loader.destroy() ;
				resumeWorks() ;
			}) ;
			loader.load() ;
		}
		
		private function resumeWorks(cond:Boolean = true):void 
		{
			ExecuteController.instance.startModule(module, cond) ;
		}
		
		public function dispatchWorksComplete():void 
		{
			DifferedCommand(commandOpen).dispatchComplete() ;
		}
	}

}