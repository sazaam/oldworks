package pro
{
	import asSist.as3Query;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import of.app.required.commands.Command;
	import of.app.required.context.XContext;
	import of.app.required.dialog.XExternalDialoger;
	import of.app.required.steps.VirtualSteps;
	import of.app.Root;
	import of.app.XUnique;
	import pro.navigation.navmain.OverallNavigation;
	import tools.grafix.Draw;
	import tools.layer.Layer;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Unique extends XUnique
	{
		
		private var __nav:OverallNavigation;
		
		public function Unique() 
		{
			super("ALL", new Command(this, onSite)) ;
			add(new VirtualSteps("HOME", new Command(this, onHome, true), new Command(this, onHome, false))) ;
		}
		
		private function onHome(cond:Boolean):void
		{
			var nav:OverallNavigation = OverallNavigation.instance ;
			var layer:Layer
			if (cond) {
				trace("opening home") ;
				layer = XContext.$get(Layer).attr( { id:"LAYER", name:"LAYER" } )[0] ;
				Draw.draw("rect", { g:layer.graphics, color:0xFFFFFF, alpha:.23 }, 0, 0, 600, 400) ;
				//Root.root.addChildAt(layer, 0) ;
				
				
				
				layer.addEventListener(MouseEvent.CLICK, onLayerClicked) ;
				//nav.read(this) ;
			}else {
				trace("closing home") ;
				//layer = XContext.$get("#LAYER").remove()[0] ;
				//nav.unread(this) ;
			}
		}
		
		private function onLayerClicked(e:MouseEvent):void 
		{
			XExternalDialoger.instance.swfAddress.value = "PORTFOLIO/1/EXAMPLE" ;
		}
		
		private function onSite():void
		{
			initXML() ;
			
			//
			initNav() ;
		}
		
		private function initXML():void
		{
			xml = Root.user.data.loaded["XML"]["sections"] ;
		}
		
		private function initNav():void
		{
			XExternalDialoger.instance.swfAddress.hierarchy.autoExec = false ;
			OverallNavigation.instance.init(Root.root, this) ;
		}
	}
}