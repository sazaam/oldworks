package naja.model 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Root extends Sprite
	{
//////////////////////////////////////////////////////// VARS
		internal static var __instance:Root ;
		internal static var __user:XUser ;
//////////////////////////////////////////////////////// CTOR
		public function Root() 
		{
			trace("CTOR > ROOT")
			__instance = this ;
			__user = new XUser() ;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get root():Root { return __instance }
		static public function get user():XUser { return __user }
	}
}