package pro.navigation.navmain 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import of.app.required.data.Gates;
	import of.app.required.dialog.XExternalDialoger;
	import of.app.required.loading.XLoader;
	import of.app.required.steps.E.StepEvent;
	import of.app.required.steps.VirtualSteps;
	import of.app.Root;
	import of.app.XConsole;
	import pro.steps.CustomStep;
	
	public class OverallNavigation 
	{
		//////////////////////////////////////////////////////// VARS
		static private var __instance:OverallNavigation ;
		private var __target:Sprite;
		private var __u:VirtualSteps;
		private var __xml:XML;
		private var __view:NavigationGraphics;
		private var __openedStep:VirtualSteps;
		private var __focusedItem:Sprite;
		private var __choiceSets:Array;
		
		
		
		//////////////////////////////////////////////////////// CTOR
		public function OverallNavigation() 
		{
			__instance = this ;
		}
		//	INIT
		public function init(tg:Sprite, unique:VirtualSteps):OverallNavigation
		{
			define(tg, unique) ;
			create() ;
			return this ;
		}
		//	DEFINE
		private function define(tg:Sprite, u:VirtualSteps):void 
		{
			__target  = tg ;
			__u = u ;
			__xml = __u.xml ;
			__view = new NavigationGraphics(this) ;
			__choiceSets = [] ;
		}
		private function create():void 
		{
			__view.createNavGraphics() ;
			__view.home.addEventListener(MouseEvent.CLICK, onHome) ;
		}
		
		private function onHome(e:MouseEvent):void 
		{
			XExternalDialoger.instance.swfAddress.value = 'HOME' ;
		}
		
		public function update(step:VirtualSteps, cond:Boolean = true):void 
		{
			if (cond) {
				build(step) ;
			}else {
				unbuild(step) ;
			}
		}
		
		//	BUILD & UNBUILD
		private function build(step:VirtualSteps):void
		{
			fill(step) ;
			__openedStep = step ;
			enableChoiceSet(step.userData.choiceStep) ;
		}
		
		private function fill(step:VirtualSteps):void 
		{
			step.userData.choiceStep = addChoiceSet(step) ;
			var xml:XML = step.xml ;
			for each(var section:XML in xml.child('section')) {
				var id:String = section.attribute('id').toXMLString() ;
				var path:String = step.path ;
				var label:String = section.attribute('label').toXMLString() ;
				__view.createNewChoice(path, id, label) ;
			}
			
		}
		private function unbuild(step:VirtualSteps):void
		{
			enableChoiceSet(removeChoiceSet(step), false) ;
			__openedStep = null ;
		}
		private function addChoiceSet(step:VirtualSteps):Sprite 
		{
			return __view.addChoiceSet(step.path) ;
		}
		private function removeChoiceSet(step:VirtualSteps):Sprite 
		{
			return __view.removeChoiceSet(step.path) ;
		}
		
		
		

		
		public function enableChoiceSet(step:Sprite, cond:Boolean = true):Sprite 
		{
			// block ChoiceSet
			var bcs:Sprite ;
			bcs = step ;
			
			var closure:String ;
			closure = cond ? 'addEventListener' : 'removeEventListener' ;
			
			bcs[closure](KeyboardEvent.KEY_DOWN, onBlockKey, true) ;
			bcs[closure](FocusEvent.FOCUS_IN, onBlockFocus, true) ;
			bcs[closure](FocusEvent.FOCUS_OUT, onBlockFocus, true) ;
			bcs[closure](MouseEvent.ROLL_OVER, onBlockRoll) ;
			bcs[closure](MouseEvent.ROLL_OUT, onBlockRoll) ;
			bcs[closure](MouseEvent.MOUSE_OVER, onBlockMouseOver, true) ;
			bcs[closure](MouseEvent.MOUSE_OUT, onBlockMouseOver, true) ;
			bcs[closure](MouseEvent.CLICK, onClick, true) ;
			
			return bcs ;
		}
		
		private function onBlockKey(e:KeyboardEvent):void 
		{
			switch(e.keyCode) {
				case Keyboard.TAB:
					trace(e.target.name)
					return ;
				break ;
				case Keyboard.DOWN:
					nextFocus() ;
				break ;
				case Keyboard.UP:
					prevFocus() ;
				break ;
				case Keyboard.LEFT:
					
				break ;
				case Keyboard.ESCAPE:
				
				break ;
				case Keyboard.RIGHT:
					
				break ;
				case Keyboard.ENTER:
					go(e.target.name) ;
				break ;
			}
			
			XConsole.log(e.eventPhase) ;
			XConsole.log(e.keyCode, e.target.name) ;
			XConsole.log('-------------------------') ;
			
			trace('ksduvbkdvbkdshbsdkbv')
		}
		
		private function go(path:String):void 
		{
			trace('PATH >>>>> ', path) ;
			XExternalDialoger.instance.swfAddress.value = path.replace('item_NAV/', '') ;
		}
		private function nextFocus():void 
		{
			var arr:Array = __openedStep.userData.focuses ;
			var ind:int = loopUp(arr, arr.indexOf(__focusedItem)) ;
			var item:Sprite = arr[ind] ;
			item.stage.focus = item ;
		}
		private function prevFocus():void 
		{
			var arr:Array = __openedStep.userData.focuses ;
			var ind:int = loopDown(arr, arr.indexOf(__focusedItem)) ;
			var item:Sprite = arr[ind] ;
			item.stage.focus = item ;
		}
		
		private function loopUp(arr:Array, focusIndex:int):int
		{
			return Boolean(arr[focusIndex + 1] as Sprite) ? focusIndex + 1 : 0 ;
		}
		
		private function loopDown(arr:Array, focusIndex:int):int 
		{
			return Boolean(arr[focusIndex - 1] as Sprite) ? focusIndex - 1 : arr.length - Array.length ;
		}
		
		private function onBlockRoll(e:MouseEvent):void 
		{
			Sprite(e.target).alpha = e.type == MouseEvent.ROLL_OVER ? 1 : .7 ;
		}
		
		private function onBlockMouseOver(e:MouseEvent):void 
		{
			if (e.target is Sprite) {
				//trace( e.target.name, e.target)  ;
				__view.execOver(e.target, e.type == MouseEvent.MOUSE_OVER) ;
			}
		}
		private function onBlockFocus(e:FocusEvent):void 
		{
			__view.execOver(e.target, e.type == FocusEvent.FOCUS_IN) ;
			__focusedItem = e.target ;
		}
		private function onItemRoll(e:Event):void 
		{
			execOver(e.target, e.type == MouseEvent.ROLL_OVER) ;
		}		
		private function onClick(e:MouseEvent):void 
		{
			if (e.target.name.indexOf('__futureChoice__') != -1) {
				return ;
			}else {
				XExternalDialoger.instance.swfAddress.value = e.target.name.replace('item_NAV/', '') ;
			}
		}
		
		///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get hasInstance():Boolean { return Boolean(__instance is OverallNavigation) }
		static public function get instance():OverallNavigation { return __instance || new OverallNavigation() }
		static public function init(tg:Sprite):OverallNavigation { return instance.init(tg) }
		
		public function get enabled():Boolean { return enabled }
		public function get target():Sprite { return __target }
		public function get unique():VirtualSteps 
		{ return __u }
		
		public function get openedStep():VirtualSteps 
		{ return __openedStep }
	}
}