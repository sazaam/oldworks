package of.app.required.steps 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author saz
	 */
	public class SectionsController
	{
		private static var __instance:SectionsController;
		private var __root:String;
		private var __steps:Dictionary;
		private var __pathes:Dictionary;
		
		public function SectionsController(...args:Array) 
		{
			__instance = this ;
		}
		public function init():SectionsController
		{
			trace(this, ' inited...') ;
			
			return this ;
		}
		
		public function enable(unique:VirtualSteps, xml:XML):void 
		{
			__root = unique.id ;
			unique.xml = xml ;
			__steps = new Dictionary() ;
			__pathes = new Dictionary() ;
			// hack for the root
			__steps[__root] = unique ;
			trace(unique) ;
		}
		
		public function register(xml:XML, p:VirtualSteps):VirtualSteps 
		{
			
			var step:VirtualSteps = p.add(new VirtualSteps(xml.attribute('id')[0].toXMLString())) ;
			//step.xml = xml ;
			__steps[xml] = step ;
			__pathes[step.path] = step ;
			//here detect if needs Loading
			step.userData.needsLoading = step.xml.attribute('section').length() != 0;
			//and is final
			step.userData.isFinal = !step.needsLoading && step.xml.child('section').length() == 0 ;
			return step ;
		}
		
		public function exists(xml:XML):Boolean {
			return Boolean(__steps[xml]) ;
		}
		
		public function createInnerSteps(u:VirtualSteps):void 
		{
			var xml:XML = u.xml ;
			
			for each(var section:XML in xml) {
				//trace(section.toXMLString()) ;
				createInnerSteps(register(section, u)) ;
			}
		}
		static public function get hasInstance():Boolean { return Boolean(__instance as SectionsController) }
		static public function init(...rest:Array):SectionsController { return instance.init.apply(instance, [].concat(rest)) }
		static public function get instance():SectionsController { return hasInstance? __instance :  new SectionsController() }
	}
}