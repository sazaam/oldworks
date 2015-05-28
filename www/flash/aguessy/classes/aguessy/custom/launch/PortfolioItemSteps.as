package aguessy.custom.launch 
{
	import aguessy.custom.launch.graph3D.Nav3D;
	import aguessy.custom.launch.visuals.FLVManager;
	import aguessy.custom.launch.visuals.VisualManager;
	import flash.display.Sprite;
	import naja.model.control.context.Context;
	import naja.model.control.dialog.ExternalDialoger;
	import naja.model.Root;
	import naja.model.XUser;
	import naja.model.commands.Command;
	import naja.model.commands.CommandQueue;
	import naja.model.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	public class PortfolioItemSteps extends VirtualSteps
	{
		protected var user:XUser;
		public var infos:XML;
		protected var oldIndex:int;
		
		public function PortfolioItemSteps(_id:Object) 
		{
			super(_id, new CommandQueue(new Command(this, openPortfolioItem, true)), new CommandQueue(new Command(this, openPortfolioItem, false))) ;
			user = Root.user ;
		}
		
		
		
		private function openPortfolioItem(cond:Boolean):void
		{
			var nav3D:Nav3D = user.model.data.objects["nav3D"] ;
			if (cond) {
				addSteps() ;
				nav3D.stop() ;
				nav3D.reset() ;
				nav3D.evaluate(this) ;
				nav3D.play() ;
				nav3D.finalEvents(this) ;
				addInfos() ;
				
				var ref:Object = gates.merged[oldIndex || 0].id ;
				gates.merged[oldIndex || 0].play() ;
			}else {
				if (Boolean(currentStep)) oldIndex = currentStep.index ;
				if (FLVManager.instance.opened)	FLVManager.instance.close() ;
				nav3D.stop() ;
				addInfos(false) ;
				nav3D.finalEvents(this,false) ;
				nav3D.reset() ;
				nav3D.evaluate(parent) ;
				nav3D.play() ;
			}
		}
		
		protected function addInfos(cond:Boolean = true):void
		{
			var nav3D:Nav3D = user.model.data.objects["nav3D"] ;
			nav3D.fillInfos(this,cond) ;
		}
		
		private function addSteps():void
		{
			for each(var sub:XML in xml.*) {
				var ref:String = String(sub.childIndex()+1) ;
				if (!Boolean(gates[ref])) {
					var n:LoadingSteps = new LoadingSteps(ref) ;
					n.xml = sub ;
					add(n) ;
				}
			}
		}
	}
}