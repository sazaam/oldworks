package pro.navigation.navmain 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import of.app.required.data.Gates;
	import of.app.required.steps.VirtualSteps;
	
	public class OverallNavigation 
	{
		//////////////////////////////////////////////////////// VARS
		static private var __instance:OverallNavigation ;
		private var __target:Sprite;
		private var __u:VirtualSteps;
		private var __xml:XML;
		private var __cswitch:ContextSwitcher;
		private var __gr:NavigationGraphics;
		private var __openedStep:VirtualSteps;
		private var __potentialStep:VirtualSteps;
		private var __sg:Gates;
		
		
		//////////////////////////////////////////////////////// CTOR
		public function OverallNavigation() 
		{
			__instance = this ;
		}
		public function init(tg:Sprite, step:VirtualSteps):OverallNavigation
		{
			define(tg, step) ;
			create() ;
			return this ;
		}
		private function define(tg:Sprite, step:VirtualSteps):void 
		{
			__target  = tg ;
			__u = step ;
			__xml = __u.xml ;
			__gr = new NavigationGraphics(this) ;
			__cswitch = new ContextSwitcher() ;
			__sg = new Gates() ;
		}
		private function create():void 
		{
			__gr.createNavGraphics() ;
			buildOnce() ;
		}
		
		private function buildOnce():void 
		{
			build(__u) ;
		}
		
		private function build(step:VirtualSteps):void 
		{
			__openedStep = step ;
			
			var stepXML:XML = step.xml ;
			var pid:String = step.id ;
			__gr.createNewChoiceSet(pid, pid)
			for each(var sectionXML:XML in stepXML.child('section')) {
				var id:String = pid +'/'+ sectionXML.attribute('id').toXMLString() ;
				var label:String = sectionXML.attribute('label').toXMLString() ;
				__gr.eventsItem(__gr.createNewChoice(id, label)) ;
			}
			__sg.add(__gr.brothers, pid) ;
			
			enableChoiceSet(pid) ;
		}
		
		private function enableChoiceSet(choiceSetId:String):void 
		{
			__gr.eventsChoiceSet(choiceSetId) ;
			__target.stage.focus = __gr.brothers[0] ;
		}
		///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get hasInstance():Boolean { return Boolean(__instance is OverallNavigation) }
		static public function get instance():OverallNavigation { return __instance || new OverallNavigation() }
		static public function init(tg:Sprite):OverallNavigation { return instance.init(tg) }
		
		public function get enabled():Boolean { return enabled }
		public function get target():Sprite { return __target }
		
		public function get openedStep():VirtualSteps { return __openedStep }
		
		public function get unique():VirtualSteps 
		{
			return __u;
		}
	}
}