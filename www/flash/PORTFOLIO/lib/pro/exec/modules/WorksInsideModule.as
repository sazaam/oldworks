package pro.exec.modules 
{
	import flash.utils.setTimeout;
	import of.app.required.commands.Command;
	import of.app.required.steps.VirtualSteps;
	import pro.exec.views.WorksInsideView;
	import pro.exec.steps.CustomStep;
	import pro.exec.steps.WorksInsideStep;
	import tools.fl.sprites.Smart;
	/**
	 * ...
	 * @author saz
	 */
	public class WorksInsideModule extends Module 
	{
		private var __fakeStep:VirtualSteps;
		private var __currentSmart:Smart;
		
		public function WorksInsideModule(worksInsideStep:WorksInsideStep) 
		{
			super(worksInsideStep, new WorksInsideView(this)) ;
		}
		
		public function launch(cond:Boolean = true):void 
		{
			worksInside(cond) ;
		}
		private function worksInside(cond:Boolean = true):void 
		{
			if (cond) {
				WorksInsideView(view).worksInside() ;
				WorksInsideView(view).addToDepthNav() ;
				//CustomStep(step).checkBackground() ;
				launchFakeStep() ;
			}else {
				launchFakeStep(false) ;
				//CustomStep(step).checkBackground(false) ;
				WorksInsideView(view).addToDepthNav(false) ;
				WorksInsideView(view).worksInside(false) ;
			}
		}
		private function treatWorks(cond:Boolean = true):void 
		{
			if (cond) {
				WorksInsideView(view).treatWorks() ;
			}else {
				WorksInsideView(view).treatWorks(false) ;
			}
		}
		override public function beforeModule(cond:Boolean):void 
		{
			treatWorks(cond) ;
		}
		private function launchFakeStep(cond:Boolean = true):void 
		{
			if (cond) {
				__fakeStep = new VirtualSteps('WORKSINSIDEMODULE').setUnique() ;
				__fakeStep.looping = true ;
				workingStep = __fakeStep ;
				
				WorksInsideView(view).showGrid() ;
				var sections:XML = step.xml ;
				for each(var item:XML in sections.*) {
					var index:int = item.childIndex() ;
					var id:String = item.attribute('id')[0].toXMLString() ;
					if (index < (view.execModel.grid.rows * view.execModel.grid.cols)) {
						var smart:Smart = __fakeStep.userData.wraps[index] ;
						smart.properties.enable() ;
						smart.properties.fillXML(item) ;
					}
					var childStep:VirtualSteps = VirtualSteps(__fakeStep.add(new VirtualSteps(id, new Command(this, onItem, item, index, smart, true), new Command(this, onItem, item, index, smart, false)))) ;
				}
				WorksInsideView(view).initGrid(index) ;
				__fakeStep.next() ;
				WorksInsideStep(step).dispatchWorksInsideComplete() ;
			}else {
				__fakeStep.playhead = -1 ;
				__fakeStep.currentStep.close() ;
				__fakeStep.userData.wraps.map(function(el:Smart, i:int, arr:Array):Smart {
					return Smart(el).destroy() ;
				})
				__fakeStep.userData.wraps = null ;
				__fakeStep = workingStep = __fakeStep.destroy() ;
				
				WorksInsideView(view).showGrid(false) ;
			}
		}
		private function onItem( item:XML,  index:int, smart:Smart, cond:Boolean = true):void 
		{
			if (cond) {
				smart.properties.select(item, index) ;
			}else {
				smart.properties.select(item, index, false) ;
			}
		}
	}

}