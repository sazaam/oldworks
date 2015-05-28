package pro.steps 
{
	import of.app.required.steps.Hierarchy;
	import of.app.required.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	public class NavHierarchy extends Hierarchy 
	{
		private static var __instance:NavHierarchy ;
		public function NavHierarchy() 
		{
			__instance = this ;
			super() ;
		}
		static public function init():NavHierarchy { return instance.init() }
		static public function get instance():NavHierarchy { return __instance || new NavHierarchy() }
		static public function get hasInstance():Boolean { return  Boolean(__instance as NavHierarchy) }
	}

}