package of.app 
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author saz
	 */
	public class XFactor
	{
		// REQUIRED
		static private var __instance:XFactor ;
		//////////////////////////////////////// VARS
		private var __classPanel:Array
		//////////////////////////////////////// CTOR
		public function XFactor() 
		{
			__instance = this ;
		}
		//////////////////////////////////////// INIT
		protected function init():XFactor
		{
			__classPanel = [ ] ;
			trace(this, 'inited...') ;
			return this ;
		}
		//////////////////////////////////////// REGISTER / UNREGISTER
		public function register(c:Class, ref:String, ...rest:Array):*
		{
			var statclass:Class = getDefinitionByName(getQualifiedClassName(c)) ;
			__classPanel[ref] = new statclass().init.apply(statclass, rest) ;
			return __classPanel[ref] ;
		}
		public function unregister(c:Class = null, ref:String = null):*
		{
			if (c && !Boolean(ref)) {
				for (var s:String in __classPanel) {
					if (__classPanel[s] === c) {
						__classPanel[s] = null ;
						delete __classPanel[s] ;
					}else {
						throw(new ReferenceError("no such Class in ClassPanel")) ;
					}
				}
			}else if (ref && !Boolean(c)){
				__classPanel[ref] = null ;
				delete __classPanel[ref] ;
			} else {
				throw(new ArgumentError("Both class and reference shouldn't be passed at the same time in this function")) ;
			}
			return __classPanel[ref] ;
		}
		//////////////////////////////////////// TOSTRING
		public function toString():String
		{
			return '[object XFactor]' ;
		}
		///////////////////////////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function register(c:Class, ref:String, ...rest:Array):* {
			if (!hasInstance) instance.init() ;
			return __instance.register.apply(instance, [c, ref].concat(rest)) ;
		}
		static public function unregister(c:Class = null, ref:String = null):* { return __instance.unregister(c, ref) }
		static public function get classes():Array {return __instance.classes }
		static public function init():XFactor{ return instance.init() }
		static public function get hasInstance():Boolean { return Boolean(__instance as XFactor) }
		static public function get instance():XFactor{ return hasInstance? __instance :  new XFactor() }
		
		public function get classes():Array { return __classPanel }
	}
}