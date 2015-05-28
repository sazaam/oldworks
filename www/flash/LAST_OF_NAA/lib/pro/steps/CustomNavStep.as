package pro.steps
{
	import of.app.required.commands.Command;
	import of.app.required.steps.VirtualSteps;
	import of.app.XConsole;
	import pro.navigation.navmain.OverallNavigation;

	
	/**
	 * ...
	 * @author saz
	 */
	
	public class CustomNavStep extends VirtualSteps
	{
		
		public function CustomNavStep(step:VirtualSteps, __xmlSections:XML) 
		{
			super(step.id, new Command(this, onStep, true), new Command(this, onStep, false)) ;
			xml = __xmlSections ;
		}
		
		private function onStep(cond:Boolean):void
		{
			if (cond) {
				trace('opening navStep id : ' + id + '   >>> path : ' + path)
				XConsole.log('opening navStep id : ' + id + '   >>> path : ' + path)
				OverallNavigation.instance.update(this) ;
			}else {
				OverallNavigation.instance.update(this, false) ;
				trace('closing navStep id : ' + id + '   >>> path : ' + path)
				XConsole.log('closing navStep id : ' + id + '   >>> path : ' + path)
			}
		}
		
	}
}