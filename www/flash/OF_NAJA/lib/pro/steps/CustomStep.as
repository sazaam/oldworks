package pro.steps
{
	import of.app.required.commands.Command;
	import of.app.required.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class CustomStep extends VirtualSteps
	{
		
		public function CustomStep(__id:String = null) 
		{
			super(__id, new Command(this, onStep, true), new Command(this, onStep, false)) ;
		}
		
		private function onStep(cond:Boolean):void
		{
			if (cond) {
				trace("opening step", id) ;
				
				
			}else {
				trace("closing step", id) ;
				
				
			}
		}
	}
}