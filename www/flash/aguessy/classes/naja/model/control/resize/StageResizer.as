package naja.model.control.resize
{
	import saz.helpers.stage.StageResize;
	
	/**
	 * ...
	 * @author saz
	 */
	public class StageResizer extends StageResize
	{
//////////////////////////////////////////////////////// VARS
		static private var __instance:StageResizer ;
//////////////////////////////////////////////////////// CTOR
		public function StageResizer() {
			__instance = this ;
			super() ;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get instance():StageResizer	{ return  __instance || new StageResizer() }
		static public function get hasInstance():Boolean { return  Boolean(__instance) }
	}
}