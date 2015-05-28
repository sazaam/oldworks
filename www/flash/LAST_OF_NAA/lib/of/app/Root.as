package of.app 
{
	/**
	 * ...
	 * @author saz
	 */
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * The Root class is part of the Naja X API.
	 * 
	 * @see	naja.model.XUser
	 * @see	naja.model.XModel
	 * 
     * @version 1.0.0
	 */
	
	public class Root extends Sprite
	{
//////////////////////////////////////////////////////// VARS
		internal static var __instance:Root ;
		internal static var __scheme:Sprite ;
		internal static var __user:XUser ;
//////////////////////////////////////////////////////// CTOR
		/**
		 * Root is not to be constructed !!
		 * Root is suppose to be the main Document
		 */	
		public function Root() 
		{
			__instance = this ;
			__user = XFactor.register(XUser , 'user', this) ;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get root():Root { return __instance }
		static public function get user():XUser { return __user }
		static public function get scheme():Sprite { return __scheme }
		
		public function get user():XUser { return __user }
		public function get scheme():Sprite { return __scheme }
		public function set scheme(value:Sprite):void { __scheme = value }
	}
}