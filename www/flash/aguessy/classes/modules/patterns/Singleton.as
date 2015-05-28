package modules.patterns 
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	import modules.foundation.Type;	
	/**
	 * Singleton pattern implementation.
	 * 
	 * @author biendo@fullsix.com
	 */
	public class Singleton 
	{
		
		public static const LOCK_METHOD:String = "getInstance";
		
		/**
		 * Construct a new Singleton object instance and maintain the main application Singleton instances
		 * @param	lock Function (default = null) - you can' instanciate directly a new Singleton object call getInstance() 
		 * 			with no parameters
		 */
		public function Singleton(lock:Function=null) 
		{
			super();
			assertLockException(lock == Type.getClass(this)[LOCK_METHOD]);
		}
		
		/**
		 * Get a new Singleton instance or a registered instance of Singleton subclass
		 * @param	T Class (default = null) - The Subcalss of Singleton you want to instanciate if null default Singleton is returned
		 * @param	parameters Array (default = null) - Otionals parameters to pass to Singleton instance;
		 * @return	Singleton - The specified Singleton instance.
		 */
		public static function getInstance(T:Class=null, parameters:Array=null):Singleton
		{
			if (T == null)
				return _instance ||= new Singleton(arguments.callee);
			var qualified:String = Type.getQualifiedName(T);
			if (hasReference(qualified))
				return getReference(qualified);
			var T:Class = Type.getClassByName(qualified);
			var instance:Singleton = Type.getInstance.apply(null, [T].concat(parameters || [T[LOCK_METHOD]])) as Singleton;
			return registerInstance(qualified, instance) ? instance : null;
		}
		
		/**
		 * Get a referenced Singleton instance
		 * @param	qualifiedClassName String - The qualified class of the specified singleton
		 * @return	Singleton - The specified Singleton instance.
		 */
		public static function getReference(qualifiedClassName:String):Singleton
		{
			return hasReference(qualifiedClassName) ? getMultiton()[qualifiedClassName] : null;
		}
		
		/**
		 * Test if the specified Singleton is referenced
		 * @param	qualifiedClassName String - The qualified class of the specified singleton
		 * @return	Boolean - True if the specified Suingleton instance is referenced.
		 */
		public static function hasReference(qualifiedClassName:String):Boolean
		{
			return getMultiton()[qualifiedClassName] != null;
		}
		
		/**
		 * 
		 * @param	qualifiedClassName
		 * @return
		 */
		protected static function removeReference(qualifiedClassName:String):Boolean
		{
			if (!getMultiton()[qualifiedClassName]) 
				return false;
			_multiton[qualifiedClassName] = null;
			return true;
		}
		
		/**
		 * 
		 * @param	qualifiedClassName 	String 		-	 
		 * @param	instance			Singleton 	-
		 * 
		 */
		protected static function registerInstance(qualifiedClassName:String, instance:Singleton):Boolean
		{
			if (getMultiton()[qualifiedClassName] != null) 
				return false;
			_multiton[qualifiedClassName] = instance;
			return true;
		}
		
		/**
		 * 
		 * @param	lock
		 */
		private function assertLockException(lock:Boolean):void
		{
			if (!lock)
				throw new TypeError("Runtime instanciation of " + Type.getClassPath(this) + "is disallowed");
		}
		
		/**
		 * Retrieve the references table
		 * @return Dictionary - The reference table of Singleton objects instances
		 */
		private static function getMultiton():Dictionary
		{
			if (_multiton == null)
				_multiton = new Dictionary();
			return _multiton;
		}
				
		private static var _instance:Singleton;
		private static var _multiton:Dictionary;
	}	
}