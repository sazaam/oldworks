package pro.exec.modules 
{
	import flash.events.MouseEvent;
	import of.app.required.steps.VirtualSteps;
	import pro.exec.ExecuteController;
	import pro.exec.views.View;
	import tools.fl.sprites.Smart;
	/**
	 * ...
	 * @author saz
	 */
	public class Module 
	{
		private var __controller:ExecuteController;
		private var __view:View;
		private var __step:VirtualSteps;
		private var __workingStep:VirtualSteps;
		
		public function Module(customStep:VirtualSteps, view:View) 
		{
			__controller = ExecuteController.instance ;
			__step = customStep ;
			__view = view ;
		}
		public function goToCurrentItem():void 
		{
			if (__workingStep.userData.smarts is Array) {
				__view.setFocus(__workingStep.userData.smarts[__workingStep.gates.merged.indexOf(__workingStep.gates[__workingStep.currentStep.id])].properties.current.properties.link) ;
			}
		}
		public function arrowDown():void 
		{
			if (view.getFocus() == null) view.setFocus(View.lastFocused) ;
			__controller.launchDown(__controller.currentStep.module.workingStep.currentStep.id) ;
		}
		public function arrowUp():void 
		{
			__controller.launchUp() ;
		}
		public function arrowPrev():void 
		{
			if (__workingStep.prev() == -1) {
				__view.setFocus(View.lastFocused) 
			}
		}
		public function arrowNext():void 
		{
			if (__workingStep.next() == -1) {
				__view.setFocus(View.lastFocused) 
			}
		}
		public function destroy():Module 
		{
			__workingStep = null ;
			__controller = null ;
			__view = null ;
			return null ;
		}
		
		public function beforeModule(cond:Boolean):void 
		{
			//treatWorks() ;
		}
		
		public function get controller():ExecuteController { return __controller }
		public function get view():View { return __view }
		public function get step():VirtualSteps { return __step }
		public function get workingStep():VirtualSteps { return __workingStep }
		public function set workingStep(value:VirtualSteps):void { __workingStep = value }
	}
}