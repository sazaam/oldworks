package of.app.required.dialog 
{
	import of.app.required.dialog.SWFAddressChanger;
	import of.app.required.steps.AddressChanger;
	import of.app.required.steps.Hierarchy;
	import of.app.required.steps.VirtualSteps;

	/**
	 * ...
	 * @author saz
	 */
	public class AddressHierarchy extends Hierarchy
	{
		private static var __instance:AddressHierarchy ;
		
		public function AddressHierarchy()
		{
			__instance = this ;
			trace(this, 'inited...') ;
		}
		//////////////////////////////////////////////////////////////////////////////////////////////// REDISTRIBUTE
		override public function redistribute(path:String):void
		{
			// hack for the default start value wanted
			if (path == '/' && __changer.home != path) {
				path = __changer.home ;
				//__changer.value = path ;
				__changer.value = 'WORKS/1/EXAMPLE' ;
			}else {
				launchDeep(path.replace(/^\//, '')) ;
			}
		}
//////////////////////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function init():AddressHierarchy { return instance.init() }
		static public function get instance():AddressHierarchy { return __instance || new AddressHierarchy() }
		static public function get hasInstance():Boolean { return  Boolean(__instance as AddressHierarchy) }
	}
}