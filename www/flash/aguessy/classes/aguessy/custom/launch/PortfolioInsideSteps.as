package aguessy.custom.launch 
{
	import aguessy.custom.launch.graph3D.Nav3D;
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
	public class PortfolioInsideSteps extends VirtualSteps
	{
		private var user:XUser;
		
		public function PortfolioInsideSteps(_id:Object) 
		{
			super(_id, new CommandQueue(new Command(this, openPortfolioInside,true)), new CommandQueue(new Command(this, openPortfolioInside, false))) ;
			user = Root.user ;
		}
		
		private function openPortfolioInside(cond:Boolean):void
		{
			var nav3D:Nav3D = user.model.data.objects["nav3D"] ;
			if (cond) {
				addSteps() ;
				nav3D.stop() ;
				nav3D.reset() ;
				nav3D.evaluate(this) ;
				nav3D.play() ;
				nav3D.addSubSection(this) ;
			}else {
				nav3D.addSubSection(this, false) ;
				nav3D.stop() ;
				nav3D.reset() ;
				nav3D.evaluate(parent) ;
				nav3D.play() ;
			}
		}
		
		private function addSteps():void
		{
			for each(var sub:XML in xml.*) {
				var ref:String = sub.@id.toXMLString().toUpperCase() ;
				if (!Boolean(gates[ref])) {
					var n:PortfolioItemSteps = new PortfolioItemSteps(ref) ;
					if (sub.hasOwnProperty('informations')) {
						var s:XML = sub.informations[0] ;
						n.infos = s ;
						delete sub.informations[0] ;
					}
					n.xml = sub ;
					add(n) ;
				}
			}
			
		}
	}
}