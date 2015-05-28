package aguessy.custom.launch 
{
	import aguessy.custom.launch.graph3D.Nav3D;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import gs.TweenLite;
	import naja.model.control.context.Context;
	import naja.model.control.dialog.ExternalDialoger;
	import naja.model.Root;
	import naja.model.XUser;
	import naja.model.commands.Command;
	import naja.model.commands.CommandQueue;
	import saz.helpers.sprites.Smart;
	import naja.model.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	public class PageSteps extends VirtualSteps
	{
		private var user:XUser ;
		public function PageSteps(_id:Object) 
		{
			super(_id, new CommandQueue(new Command(this, openPage)), new CommandQueue(new Command(this, closePage))) ;
			user = Root.user ;
		}
		
		private function openPage():void
		{
			var nav3D:Nav3D = user.model.data.objects["nav3D"] ;
			nav3D.stop() ;
			nav3D.levelOne() ;
			nav3D.fill(this) ;
			
			var ref:String ;
			if (id == "PORTFOLIO" || id == "PRESS") {
				///////////////// SUBSECTIONS
				for each(var sub:XML in xml.*) {
					ref = sub.@name.toXMLString().toUpperCase() ;
					if (!gates[ref]) {
						var p:PortfolioInsideSteps = new PortfolioInsideSteps(ref) ;
						p.xml = sub ;
						add(p) ;
					}
				}
			}
			if (id == "NEWS") {
				///////////////// SUBSECTIONS
				for each(var subnews:XML in xml.*) {
					ref = subnews.@name.toXMLString().toUpperCase() ;
					if (!gates[ref]) {
						var n:NewsInsideSteps = new NewsInsideSteps(ref) ;
						n.xml = subnews ;
						add(n) ;
					}
				}
			}
			if (id == "ABOUT") {
				///////////////// SUBSECTIONS
				for each(var about:XML in xml.*) {
					ref = about.@name.toXMLString().toUpperCase() ;
					if (!gates[ref]) {
						var a:AboutInsideSteps = new AboutInsideSteps(ref) ;
						a.xml = about ;
						add(a) ;
					}
				}
			}
			
			
			if (id == "CONTACTS") {
				onCurrent = onContactsCurrent ;
				nav3D.finalEvents(this) ;
				nav3D.appendText(this) ;
			}			
			
			////////////////////////////// NAV3D
			nav3D.reset() ;
			nav3D.evaluate(this) ;
			nav3D.play() ;
		}
		
		public var onCurrent:Function ;
		private var __mediasStep:MediasSteps;
		
		public function onContactsCurrent(arr:XML):void
		{
			var nav3D:Nav3D = user.model.data.objects["nav3D"] ;
			var ind:int = arr.childIndex() ;
			var mcInside:Sprite = Context.$get("#PAGEINSIDE")[0] ;
			var spr:Smart = Context.$get("#" + id + "_" + String(ind))[0] ;
			var r:Rectangle = mcInside.scrollRect ;
			var l:int = mcInside.numChildren ;
			TweenLite.to(mcInside,.2,{x:-int(spr.properties.x),onComplete:nav3D.g3D.__displayer.checkForContainedSprites})
		}
		
		
		private function closePage():void
		{
			var nav3D:Nav3D = user.model.data.objects["nav3D"] ;
			if (id == "CONTACTS") {
				onCurrent = null ;
				nav3D.finalEvents(this,false) ;
				nav3D.appendText(this,false) ;
			}
			
			nav3D.levelOne(false) ;
			nav3D.fill(this, false) ;
			nav3D.stop() ;
		}
	}
	
}