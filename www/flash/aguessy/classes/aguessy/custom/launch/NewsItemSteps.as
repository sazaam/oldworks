package aguessy.custom.launch 
{
	import aguessy.custom.launch.graph3D.Nav3D;
	import aguessy.custom.launch.visuals.FLVManager;
	import naja.model.Root;
	import naja.model.XUser;
	import naja.model.commands.Command;
	import naja.model.commands.CommandQueue;
	import naja.model.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	public class NewsItemSteps extends VirtualSteps
	{
		protected var user:XUser;
		public var infos:XML;
		protected var oldIndex:int;
		public function NewsItemSteps(_id:Object) 
		{
			super(_id, new CommandQueue(new Command(this, openNewsItem, true)), new CommandQueue(new Command(this, openNewsItem, false))) ;
			user = Root.user ;
		}
		
		private function openNewsItem(cond:Boolean):void
		{
			var nav3D:Nav3D = user.model.data.objects["nav3D"] ;
			if (cond) {
				addSteps() ;
				nav3D.stop() ;
				nav3D.reset() ;
				nav3D.evaluate(this) ;
				nav3D.play() ;
				nav3D.finalEvents(this) ;
				addNews() ;
				
				var ref:Object = gates.merged[oldIndex || 0].id ;
				gates.merged[oldIndex || 0].play() ;
			}else {
				if (currentStep) oldIndex = currentStep.index ;
				if (FLVManager.instance.opened)	FLVManager.instance.close() ;
				nav3D.stop() ;
				addNews(false) ;
				nav3D.finalEvents(this, false) ;
				nav3D.reset() ;
				nav3D.evaluate(parent) ;
				nav3D.play() ;
			}
			
		}
		
		protected function addNews(cond:Boolean = true):void
		{
			var nav3D:Nav3D = user.model.data.objects["nav3D"] ;
			nav3D.fillNews(this,cond) ;
		}
		
		private function addSteps():void
		{
			for each(var sub:XML in xml.*) {
				var ref:String = String(sub.childIndex()+1) ;
				if (!gates[ref]) {
					var n:LoadingSteps = new LoadingSteps(ref) ;
					n.xml = sub ;
					add(n) ;
				}
			}
		}
	}
	
}