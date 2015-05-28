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
	import pro.exec.ExecuteController;
	import pro.exec.ExecuteModel;
	import pro.navigation.navmain.NavHierarchy;
	import pro.navigation.navmain.OverallNavigation;
	import pro.steps.CustomNavStep;
	import pro.steps.CustomStep;
	import pro.steps.HomeStep;
	import tools.grafix.Draw;
	import tools.layer.Layer;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Unique extends XUnique
	{
		private var __controller:ExecuteController;
		public function Unique() 
		{
			super('ALL', new Command(this, onSite)) ;
		}
		
		private function onSite():void
		{
			initXML() ;
			initNav() ;
			initHome() ;
			addSteps() ;
			
			
			initSite() ;
		}
		
		private function initSite():void 
		{
			__controller = new ExecuteController() ;
			__controller.init() ;
		}
		
		private function initHome():void 
		{
			//add(new HomeStep("HOME")) ;
			//NavHierarchy.instance.functions.add(new VirtualSteps(home.id)) ;
		}
		
		private function initXML():void
		{
			xml = Root.user.data.loaded["XML"]["sections"] ;
		}
		private function addSteps():void 
		{
			if(xml.child('section').length() != 0){
				for each(var s:XML in xml.child('section')) {
					var cl:Class ;
					if (Boolean(s.attribute('class')[0])) {
						cl = Root.root.loaderInfo.applicationDomain.getDefinition(s.attribute('class')[0].toXMLString()) ;
					}else {
						cl = CustomStep ;
					}
					add(new cl(s.attribute('id').toXMLString(), s)) ;
				}
			}
		}
		private function initNav():void
		{
			//var navHierarchy:NavHierarchy = NavHierarchy.instance.setAll(new UniqueNav(xml)).play() ;
			//AddressHierarchy.instance.asynchronious = true ;
			//AddressHierarchy.instance.commandQueue.addEventListener(Event.COMPLETE, onAddressQueueComplete) ;
		}
		
		//private function onAddressQueueComplete(e:Event):void 
		//{
			//NavHierarchy.instance.changer.value = AddressHierarchy.instance.changer.value ;
		//}
	}
}