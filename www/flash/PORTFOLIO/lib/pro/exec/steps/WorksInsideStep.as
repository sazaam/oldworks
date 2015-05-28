package pro.exec.steps 
{
	import flash.events.Event;
	import of.app.required.commands.DifferedCommand;
	import of.app.required.loading.XLoader;
	import pro.exec.ExecuteController;
	import pro.exec.modules.WorksInsideModule;
	
	/**
	 * ...
	 * @author saz
	 */
	public class WorksInsideStep extends CustomStep 
	{
		
		public function WorksInsideStep(__id:String, __xmlSections:XML) 
		{
			super( __id , __xmlSections) ;
		}
		
		override public function resume(cond:Boolean = true):void 
		{
			if (cond) {
				module = new WorksInsideModule(this) ;
				//if (!Boolean(contents as XML)) {
					//loadWorksInside() ;
				//}else {
					resumeWorksInside() ;
				//}
				//checkBackground() ;
			}else {
				//checkBackground(false) ;
				resumeWorksInside(false) ;
				//contents = null ;
				module = module.destroy() ;
			}
		}
		
		private function loadWorksInside():void 
		{
			//var loader:XLoader = new XLoader() ;
			//var url:String = '../xml/' + xml.attribute('content')[0].toXMLString() ;
			//loader.addRequestByUrl(url) ;
			//loader.addEventListener(Event.COMPLETE, function(e:Event):void {
				//loader.removeEventListener(e.type, arguments.callee) ;
				//contents = loader.getAllResponses()[0] ;
				//loader.destroy() ;
				//
			//}) ;
			//loader.load() ;
			resumeWorksInside() ;
		}
		
		private function resumeWorksInside(cond:Boolean = true):void 
		{
			ExecuteController.instance.startModule(module, cond) ;
		}
		
		public function dispatchWorksInsideComplete():void 
		{
			DifferedCommand(commandOpen).dispatchComplete() ;
		}
	}
}