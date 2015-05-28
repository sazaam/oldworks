package pro.steps 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import naja.model.control.context.Context;
	import naja.model.control.dialog.ExternalDialoger;
	import naja.model.Root;
	import naja.tools.api.geom.Draw;
	import naja.tools.commands.Command;
	import naja.tools.commands.CommandQueue;
	import naja.tools.steps.VirtualSteps;
	import pro.layer.Layer;
	import pro.navigation.saznav.Navigation;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Unique extends VirtualSteps
	{
		private var __nav:Navigation;
		
		public function Unique() 
		{
			super("ALL", new Command(this, onSite)) ;
			add(new VirtualSteps("HOME", new Command(this, onHome, true), new Command(this, onHome, false))) ;
		}
		
		private function onHome(cond:Boolean):void
		{
			var nav:Navigation = userData.nav ;
			var layer:Layer
			if (cond) {
				trace("opening home") ;
				layer = Context.$get(Layer).attr( { id:"LAYER", name:"LAYER" } )[0] ;
				Draw.draw("rect", { g:layer.graphics, color:0x0, alpha:.92 }, 0, 0, 600, 400) ;
				Root.root.addChild(layer) ;
				Root.root.addChildAt(layer, 0) ;
				layer.addEventListener(MouseEvent.CLICK, onLayerClicked) ;
			}else {
				trace("closing home") ;
				layer = Context.$get("#LAYER").remove()[0] ;
			}
		}
		
		private function onLayerClicked(e:MouseEvent):void 
		{
			ExternalDialoger.instance.swfAddress.value = "PORTFOLIO/1/EXAMPLE" ;
		}
		
		private function onSite():void
		{
			initXML() ;
			
			//
			initNav() ;
		}
		
		private function initXML():void
		{
			xml = Root.user.model.data.loaded["XML"]["sections"] ;
		}
		
		private function initNav():void
		{
			ExternalDialoger.instance.swfAddress.hierarchy.autoExec = false ;
			
			//
			__nav = new Navigation().init(Root.root) ;
			__nav.readOnce(this) ;
		}
	}
	
}