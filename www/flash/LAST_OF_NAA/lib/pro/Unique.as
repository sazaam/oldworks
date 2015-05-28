package pro
{
	import asSist.as3Query;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import of.app.required.commands.Command;
	import of.app.required.context.XContext;
	import of.app.required.dialog.AddressHierarchy;
	import of.app.required.dialog.XExternalDialoger;
	import of.app.required.steps.I.IStep;
	import of.app.required.steps.VirtualSteps;
	import of.app.Root;
	import of.app.XPlugin;
	import of.app.XUnique;
	import pro.navigation.navmain.OverallNavigation;
	import pro.steps.CustomNavStep;
	import pro.steps.CustomStep;
	import pro.steps.NavHierarchy;
	import pro.steps.StepXMLAdder;
	import tools.grafix.Draw;
	import tools.layer.Layer;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Unique extends XUnique
	{
		public function Unique() 
		{
			super('ALL', new Command(this, onSite)) ;
		}
		
		private function onHome(cond:Boolean = true):void
		{
			var layer:Layer
			if (cond) {
				trace("opening home") ;
				layer = XContext.$get(Layer).attr( { id:"LAYER_"+path, name:"LAYER" } )[0] ;
				Draw.draw("rect", { g:layer.graphics, color:0xFFFFFF, alpha:.15 }, 0, 0, 600, 400) ;
				XContext.$get('#content')[0].addChild(layer) ;
				layer.addEventListener(MouseEvent.CLICK, onLayerClicked) ;
			}else {
				trace("closing home") ;
				layer = XContext.$get("#LAYER_"+path).remove()[0] ;
				layer.removeEventListener(MouseEvent.CLICK, onLayerClicked) ;
			}
		}
		
		private function onLayerClicked(e:MouseEvent):void 
		{
			trace(this)
		}
		private function onSite():void
		{
			initXML() ;
			initNav() ;
			initHome() ;
			addSteps() ;
			
			//addNav() ;
		}
		
		private function initHome():void 
		{
			var home:VirtualSteps = add(new VirtualSteps("HOME", new Command(this, onHome, true), new Command(this, onHome, false))) ;
			NavHierarchy.instance.functions.add(new VirtualSteps(home.id)) ;
		}
		
		private function addNav():void 
		{
			//var plugin:XPlugin = new XPlugin()
			//plugin.plug = function(step:IStep):void {
				//trace('victory') ;
				//trace(step) ;
			//}
			//plugin.plug.apply(null, [gates.merged[0]]) ;
			//trace(plugin.step)
			
			
			//OverallNavigation.instance.init(XContext.$get("#nav")[0], this) ;
			//OverallNavigation.instance.update(this) ;
		}
		
		private function initXML():void
		{
			xml = Root.user.data.loaded["XML"]["sections"] ;
		}
		private function addSteps():void 
		{
			if(xml.child('section').length() != 0){
				for each(var s:XML in xml.child('section')) {
					var c:CustomStep = CustomStep(add(new CustomStep(s.attribute('id').toXMLString(), s))) ;
					NavHierarchy.instance.functions.add(new CustomNavStep(c, s)) ;
				}
			}	
		}
		private function initNav():void
		{
			var navHierarchy:NavHierarchy = NavHierarchy.instance.setAll(new UniqueNav(xml)).play() ;
			AddressHierarchy.instance.asynchronious = true ;
			AddressHierarchy.instance.commandQueue.addEventListener(Event.COMPLETE, onAddressQueueComplete) ;
		}
		
		private function onAddressQueueComplete(e:Event):void 
		{
			NavHierarchy.instance.changer.value = AddressHierarchy.instance.changer.value ;
		}
	}
}