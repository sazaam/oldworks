package naja.model.control.resize
{
	import flash.display.Stage;
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
		override public function init(stage:Stage):StageResize 
		{
			return super.init(stage) ;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function init(stage:Stage):StageResizer	{ return  StageResizer(instance.init(stage)) }
		static public function get instance():StageResizer	{ return  __instance || new StageResizer() }
	}
}