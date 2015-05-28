package pro.exec.modules 
{
	import flash.utils.setTimeout;
	import of.app.required.commands.Command;
	import of.app.required.steps.VirtualSteps;
	import pro.exec.views.ProjectView;
	import pro.exec.steps.CustomStep;
	import pro.exec.steps.ProjectInsideStep;
	import pro.exec.steps.ProjectStep;
	import tools.fl.sprites.Smart;
	/**
	 * ...
	 * @author saz
	 */
	public class ProjectModule extends Module 
	{
		private var __fakeStep:VirtualSteps;
		private var __currentSmart:Smart;
		
		public function ProjectModule(projectStep:ProjectStep) 
		{
			super(projectStep, new ProjectView(this)) ;
		}
		
		public function launch(cond:Boolean = true):void 
		{
			project(cond) ;
		}
		private function project(cond:Boolean = true):void 
		{
			if (cond) {
				ProjectView(view).project() ;
				ProjectView(view).addToDepthNav() ;
				ProjectView(view).backProject() ;
				ProjectView(view).navProject() ;
				launchFakeStep() ;
			}else {
				launchFakeStep(false) ;
				ProjectView(view).navProject(false) ;
				ProjectView(view).backProject(false) ;
				ProjectView(view).addToDepthNav(false) ;
				ProjectView(view).project(false) ;
			}
		}
		override public function beforeModule(cond:Boolean):void 
		{
			treatWorksInside(cond) ;
		}
		private function treatWorksInside(cond:Boolean = true):void 
		{
			if (cond) {
				ProjectView(view).treatWorksInside() ;
			}else {
				ProjectView(view).treatWorksInside(false) ;
			}
		}

		private function launchFakeStep(cond:Boolean = true):void 
		{
			if (cond) {
				__fakeStep = new VirtualSteps('PROJECTMODULE').setUnique() ;
				//__fakeStep.looping = true ;
				workingStep = __fakeStep ;
				var sections:XML = step.contents ;
				__fakeStep.userData.smarts = [] ;
				var l:int = sections.*.length() ;
				for each(var panel:XML in sections.*) {
					var smart:Smart = createSmart(panel, l) ;
					__fakeStep.userData.smarts.push(smart) ;
					var id:String = panel.attribute('id')[0].toXMLString() ;
					var label:String = panel.attribute('label')[0].toXMLString() ;
					var index:int = panel.childIndex() ;
					var childStep:VirtualSteps = VirtualSteps(__fakeStep.add(new VirtualSteps(id, new Command(this, onPanel, true, smart, panel), new Command(this, onPanel, false, smart, panel)))) ;
				}
				ProjectView(view).initSmarts() ;
				
				ProjectStep(step).dispatchProjectComplete() ;
				__fakeStep.next() ;
				
				
			}else {
				
				//__fakeStep.userData.smarts[0].properties.loadBack(false) ;
				
				__fakeStep.playhead = -1 ;
				__fakeStep.currentStep.close() ;
				
				__fakeStep.userData.smarts.map(function(el:*, i:int, arr:Array):Smart {
					return Smart(el).destroy() ;
				})
				__fakeStep.userData.smarts = null ;
				__fakeStep = workingStep = __fakeStep.destroy() ;
			}
		}
		private function createSmart(panel:XML, total:int):Smart 
		{
			var id:String = panel.attribute('id')[0].toXMLString() ;
			var smart:Smart = new Smart({id:'projectSmart_'+id, name:'projectSmart_'+id}) ;
			smart.properties.step = workingStep ;
			return ProjectView(view).boostSmart(panel, smart, total)  ;
		}
		private function onPanel(cond:Boolean, smart:Smart, panel:XML ):void 
		{
			if (cond) {
				//trace('opening fameous step', smart, panel.toXMLString() ) ;
				smart.properties.select() ;
			}else {
				//trace('closing fameous step', smart, panel.toXMLString() ) ;
				smart.properties.select(false) ;
			}
		}
	}
}