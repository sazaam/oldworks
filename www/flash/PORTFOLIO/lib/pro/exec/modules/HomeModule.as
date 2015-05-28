package pro.exec.modules 
{
	import flash.utils.setTimeout;
	import of.app.required.commands.Command;
	import of.app.required.steps.VirtualSteps;
	import pro.exec.ExecuteController;
	import pro.exec.views.HomeView;
	import pro.exec.steps.HomeStep;
	import tools.fl.sprites.Smart;
	/**
	 * ...
	 * @author saz
	 */
	public class HomeModule extends Module
	{
		private var __fakeStep:VirtualSteps;
		
		public function HomeModule(homeStep:HomeStep) 
		{
			super(homeStep, new HomeView(this)) ;
		}
		
		public function launch(cond:Boolean = true):void 
		{
			home(cond) ;
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////// HOME
		private function home(cond:Boolean = true):void 
		{
			if (cond) {
				HomeView(view).home() ;
				HomeView(view).arrowPrev() ;
				HomeView(view).backVisualFrame() ;
				launchFakeStep() ;
				HomeView(view).screen() ;
				HomeView(view).arrowNext() ;
				HomeView(view).arrowBottom() ;
				HomeStep(step).dispatchHomeComplete() ;
			}else {
				
				launchFakeStep(false) ;
				HomeView(view).removeArrows() ;
				HomeView(view).home(false) ;
				HomeView(view).screen(false) ;
				HomeView(view).backVisualFrame(false) ;
			}
		}
		private function launchFakeStep(cond:Boolean = true):void 
		{
			if (cond) {
				__fakeStep = new VirtualSteps('HOMEMODULE').setUnique() ;
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
					var url:String = article.child('hidden')[0].child('link')[0].attribute('url')[0].toXMLString() ;
					var accroche:String = article.child('h3')[0] ;
					var childStep:VirtualSteps = VirtualSteps(__fakeStep.add(new VirtualSteps(id, new Command(this, onArticle, smart, true), new Command(this, onArticle, smart, false)))) ;
					childStep.userData.smart = smart ;
					childStep.userData.label = label.toUpperCase() ;
					childStep.userData.accroche = accroche ;
					childStep.userData.url = url ;
				}
				setTimeout(__fakeStep.next, 60) ;
			}else {
				__fakeStep.playhead = -1 ;
				__fakeStep.currentStep.close() ;
				__fakeStep.userData.smarts.forEach(function(el:Smart, i:int, arr:Array):void {
					Smart(el).destroy() ;
				})
				__fakeStep = workingStep = __fakeStep.destroy() ;
			}
		}
		
		override public function arrowDown():void 
		{
			controller.launchSection(workingStep.currentStep.userData.url) ;
		}
		
		private function createSmart(article:XML):Smart 
		{
			var smart:Smart = new Smart() ;
			smart.properties.step = workingStep ;
			return HomeView(view).boostSmart(article, smart)  ;
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