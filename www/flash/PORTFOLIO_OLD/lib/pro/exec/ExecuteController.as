package pro.exec 
{
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import of.app.required.dialog.AddressHierarchy;
	import of.app.required.steps.VirtualSteps;
	import pro.steps.HomeStep;
	import tools.fl.sprites.Smart;
	/**
	 * ...
	 * @author saz
	 */
	public class ExecuteController 
	{
		private var __view:ExecuteView;
		private var __model:ExecuteModel;
		private static var __instance:ExecuteController;
		
		public function ExecuteController() 
		{
			__instance = this ;
		}
		
		public function init():ExecuteController 
		{
			__model = new ExecuteModel() ;
			__view = new ExecuteView() ;
			__view.init(__model) ;
			
			enableCore() ;
			
			return this ;
		}
		
		private function enableCore():void 
		{
			__view.target.addEventListener(FocusEvent.FOCUS_IN, onFocus, true) ;
			__view.target.addEventListener(FocusEvent.FOCUS_OUT, onFocus, true) ;
			__view.basicNav.addEventListener(MouseEvent.CLICK, onBasicNavItemClick, true) ;
			__view.basicNav.addEventListener(MouseEvent.ROLL_OVER, onBasicNavItemOver, true) ;
			__view.basicNav.addEventListener(MouseEvent.ROLL_OUT, onBasicNavItemOver, true) ;
			__view.render() ;
		}
		
		private function onFocus(e:FocusEvent):void 
		{
			Smart(e.target).properties.over(e.type == FocusEvent.FOCUS_IN) ;
		}
		
		private function onBasicNavItemOver(e:MouseEvent):void 
		{
			var s:Smart = Smart(e.target) ;
			var n:String = s.name ;
			switch(n) {
				case 'logo':
					__view.execLogoOver(e.type == MouseEvent.ROLL_OVER) ;
				break ;
				default :
					if (n.indexOf(__model.simpleNav.item.name) != -1) {
						__view.execBasicNavOver(s, e.type == MouseEvent.ROLL_OVER) ;
					}
				break ;
			}
		}
		
		private function onBasicNavItemClick(e:MouseEvent):void 
		{
			var url:String = '' ;
			var s:Smart = Smart(e.target) ;
			var n:String = s.name ;
			switch(n) {
				case 'logo':
					url = 'HOME' ;
				break ;
				default :
					if (n.indexOf(__model.simpleNav.item.name) != -1) url = n.replace(__model.simpleNav.item.name, '') ;
				break ;
			}
			AddressHierarchy.instance.changer.value = url ;
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////// HOME
		public function home(step:HomeStep, cond:Boolean):void 
		{
			if (cond) {
				var contents:XML = step.contents ;
				var dependancies:XML = contents.child('dependancies')[0] ;
				var articles:XML = contents.child('articles')[0] ;
				
				__view.home() ;
				__view.fillHome(articles) ;
				enableHome(step, cond) ;
				
				step.dispatchHomeComplete() ;
			}else {
				__view.home(false) ;
			}
		}
		
		private function enableHome(step:HomeStep, cond:Boolean):void 
		{
			if (cond) {
				__view.frame.addEventListener(MouseEvent.CLICK, onHomeArrowClick, true) ;
				//__view.setHomeCurrent(0) ;
			}else {
				__view.frame.removeEventListener(MouseEvent.CLICK, onHomeArrowClick, true) ;
			}
		}
		
		private function onHomeArrowClick(e:MouseEvent):void 
		{
			//if (!e.target is Smart) return ;
			
			
			trace(e.target) ;
		}
		
		
		
		
		
		static public function get hasInstance():Boolean { return Boolean(__instance as ExecuteController)}
		static public function get instance():ExecuteController { return __instance || new ExecuteController()}
		static public function init():ExecuteController { return instance.init() }
		
		
		
		public function get view():ExecuteView { return __view }
		public function get model():ExecuteModel { return __model }
	}

}