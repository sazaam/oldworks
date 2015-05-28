package pro.exec.steps 
{
	import flash.events.Event;
	import of.app.required.commands.DifferedCommand;
	import of.app.required.loading.XLoader;
	import pro.exec.ExecuteController;
	import pro.exec.modules.ProjectModule;
	
	/**
	 * ...
	 * @author saz
	 */
	public class ProjectStep extends CustomStep 
	{
		
		public function ProjectStep(__id:String, __xmlSections:XML) 
		{
			super( __id , __xmlSections) ;
		}
		
		override public function resume(cond:Boolean = true):void 
		{
			if (cond) {
				module = new ProjectModule(this) ;
				if (!Boolean(contents as XML)) {
					loadProject() ;
				}else {
					resumeProject() ;
				}
			}else {
				resumeProject(false) ;
				contents = null ;
				module = module.destroy() ;
			}
		}
		
		private function loadProject():void 
		{
			var loader:XLoader = new XLoader() ;
			var url:String = '../xml/' + xml.attribute('content')[0].toXMLString() ;
			loader.addRequestByUrl(url) ;
			loader.addEventListener(Event.COMPLETE, function(e:Event):void {
				loader.removeEventListener(e.type, arguments.callee) ;
				contents = loader.getAllResponses()[0] ;
				loader.destroy() ;
				resumeProject() ;
			}) ;
			loader.load() ;
		}
		
		private function resumeProject(cond:Boolean = true):void 
		{
			ExecuteController.instance.startModule(module, cond) ;
		}
		
		public function dispatchProjectComplete():void 
		{
			DifferedCommand(commandOpen).dispatchComplete() ;
		}
	}
}