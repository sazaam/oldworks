package pro.navigation.navmain 
{
	import of.app.required.data.Gates;
	import of.app.required.steps.VirtualSteps;
	/**
	 * ...
	 * @author ...
	 */
	public class ContextSwitcher 
	{
		
		public function ContextSwitcher() 
		{
			var g:Gates = new Gates() ;
			var v:VirtualSteps = new VirtualSteps('main_navigation', null, null, g) ;
			
			
			
		}
		
	}

}