package pro.exec.modules 
{
	import flash.utils.setTimeout;
	import of.app.required.commands.Command;
	import of.app.required.dialog.AddressHierarchy;
	import of.app.required.steps.VirtualSteps;
	import pro.exec.ExecuteController;
	import pro.exec.views.HomeView;
	import pro.exec.views.WorksView;
	import pro.exec.steps.CustomStep;
	import pro.exec.steps.HomeStep;
	import pro.exec.steps.WorksInsideStep;
	import pro.exec.steps.WorksStep;
	import tools.fl.sprites.Smart;
	/**
	 * ...
	 * @author saz
	 */
	public class WorksModule extends Module
	{
		private var __fakeStep:VirtualSteps;
		private var __currentSmart:Smart;
		
		public function WorksModule(worksStep:WorksStep) 
		{
			super(worksStep, new WorksView(this)) ;
		}
		
		public function launch(cond:Boolean = true):void 
		{
			works(cond) ;
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////// WORKS
		private function works(cond:Boolean = true):void 
		{
			if (cond) {
				WorksView(view).works() ;
				WorksView(view).arrowTop() ;
				WorksView(view).addToDepthNav() ;
				WorksView(view).arrowPrev() ;
				launchFakeStep() ;
				WorksView(view).setFocus('enterWorks_' + __fakeStep.currentStep.id) ;
				WorksView(view).arrowNext() ;
				WorksView(view).arrowBottom() ;
				WorksStep(step).dispatchWorksComplete() ;
			}else {
				launchFakeStep(false) ;
				WorksView(view).addToDepthNav(false) ;
				WorksView(view).removeArrows() ;
				WorksView(view).works(false) ;
			}
		}
		private function launchFakeStep(cond:Boolean = true):void 
		{
			if (cond) {
				__fakeStep = new VirtualSteps('WORKSMODULE').setUnique() ;
				__fakeStep.looping = true ;
				__fakeStep.userData.smarts = [] ;
				workingStep = __fakeStep ;
				var contents:XML = step.contents ;
				var articles:XML = contents.child('articles')[0] ;
				__fakeStep.userData.smarts = [] ;
				for each(var article:XML in articles.*) {
					var smart:Smart = createSmart(article) ;
					__fakeStep.userData.smarts.push(smart) ;
					var id:String = article.attribute('id')[0].toXMLString() ;
					var label:String = article.attribute('label')[0].toXMLString() ;
					var accroche:String = article.child('h3')[0] ;
					var childStep:VirtualSteps = VirtualSteps(workingStep.add(new VirtualSteps(id, new Command(this, onArticle, smart, true), new Command(this, onArticle, smart, false)))) ;
					childStep.userData.label = label ;
					childStep.userData.accroche = accroche ;
				}
				__fakeStep.next() ;
			}else {
				__fakeStep.playhead = -1 ;
				__fakeStep.currentStep.close() ;
				__fakeStep.userData.smarts.forEach(function(el:Smart, i:int, arr:Array):void {
					Smart(el).destroy() ;
				})
				__fakeStep = workingStep = __fakeStep.destroy() ;
			}
		}
		private function createSmart(article:XML):Smart 
		{
			var id:String = article.attribute('id')[0].toXMLString() ;
			var smart:Smart = new Smart({id:'worksSmart_'+id, name:'worksSmart_'+id}) ;
			smart.properties.step = workingStep ;
			return WorksView(view).boostSmart(article, smart)  ;
		}
		private function onArticle(smart:Smart, cond:Boolean = true):void 
		{
			if (cond) {
				smart.properties.show(true) ;
			}else {
				smart.properties.show(false) ;
			}
		}
	}
}