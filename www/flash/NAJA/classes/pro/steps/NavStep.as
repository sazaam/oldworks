package pro.steps 
{
	import naja.tools.commands.Command;
	import naja.tools.commands.CommandQueue;
	import naja.tools.steps.VirtualSteps;
	import pro.navigation.saznav.Navigation;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class NavStep extends VirtualSteps
	{
		
		public function NavStep(__id:String = null) 
		{
			super(__id, new Command(this, onStep, true), new Command(this, onStep, false)) ;
		}
		
		private function onStep(cond:Boolean):void
		{
			var nav:Navigation = Navigation.instance ;
			if (cond) {
				trace("opening step", id) ;
				nav.read(this) ;
			}else {
				trace("closing step", id) ;
				nav.unread(this) ;
			}
		}
	}
}