package naja.model.control.loading 
{
	import naja.model.data.loaders.AllLoader;
	
	/**
	 * ...
	 * @author saz
	 */
	public class GeneralLoader 
	{
//////////////////////////////////////////////////////// VARS
		static private var __instance:GeneralLoader ;
		
		private var __loader:AllLoader;
//////////////////////////////////////////////////////// CTOR
		public function GeneralLoader() 
		{
			trace("CTOR > " + this) ;
			__instance = this ;
			__loader = AllLoader.instance ;
		}
		
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get instance():GeneralLoader { return __instance || new GeneralLoader() }
		
		public function get loader():AllLoader { return __loader }
	}
}