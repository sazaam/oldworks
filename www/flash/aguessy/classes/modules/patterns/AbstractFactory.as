package modules.patterns
{
	import flash.utils.Dictionary;
	
	import modules.foundation.ADT;
	import modules.foundation.Type;

	public class AbstractFactory 
	{
		public function AbstractFactory(concrete:Boolean=false)
		{
			_concrete = concrete;
			if (!_concrete)//subclass can decide of let them abstract or concrete for ex: put _concrete to true in the subclass constructor before calling super. 
				ADT.assertAbstractTypeError(this, Type.getClass(this));//By default all Factory subClass are abstract		
			super();
		}
		
		/**
		 * @param
		 * @param
		 * @param
		 * @return
		 */
		public static function call(alias:String, creationMethod:String, ... parameters):*
		{
			return getCreationMethod(alias, creationMethod).apply(null, parameters);
		} 
		
		/**
		 * 
		 * @param	alias
		 * @return
		 */
		public static function getConcreteFactory(alias:String):AbstractFactory
		{
			var o:Object;				
			for each(o in DICTIONARY) {
				if (o.alias == alias)
					return o.factory as AbstractFactory;
			}
			return null;
		}
		
		/**
		 * @param
		 * @param
		 * @return
		 */		
		public static function getCreationMethod(alias:String, creationMethod:String):Function
		{
			var T:AbstractFactory = getConcreteFactory(alias);
			if (T != null) {
				var methods:Array = DICTIONARY[T].methods;
				var len:int = methods.length;
				while(len--)
					if (methods[len] == creationMethod)
						return Type.getClass(T)[creationMethod];	
			}
			return null;
		} 	
		
		/**
		 * @param
		 * @param
		 * @return
		 */			
		public static function getInstance(alias:String, ... parameters):AbstractFactory
		{
			var T:AbstractFactory = getConcreteFactory(alias);
			if (T != null)
				return Type.getInstance.apply(null, [T].concat(parameters)) as AbstractFactory;
			return null;
		}
		
		/**
		 * @param
		 * @return
		 */				
		public static function hasFactory(alias:String):Boolean
		{
			return getConcreteFactory(alias) in DICTIONARY;
		}	
		
		/**
		 * @param
		 * @param
		 * @return
		 */		
		public static function hasCreationMethod(alias:String, creationMethod:String):Boolean
		{
			var T:AbstractFactory = getConcreteFactory(alias);
			if (T != null) {
				var methods:Array = DICTIONARY[T].methods;
				var len:int = methods.length;
				while(len--)
					if (methods[len] == creationMethod)
						return true;	
			}
			return false;	
		}
		
		/**
		 * @param
		 * @param
		 * @return
		 */									
		public static function register(T:Object, ... creationMethods:Array):Boolean
		{
			if (!(T is AbstractFactory))
				throw new TypeError("type error");
			var alias:String = Type.getClassPath(T);
			if (hasFactory(alias)) {
				return true;
			} else {
				var factory:Class = Type.getClass(T);
				var len:int = creationMethods.length;
				var methods:Array = [];
				while(len--) {
					var method:String = creationMethods[len];
					if (factory[method] == null)
						throw new TypeError("static " + method + " method not implemented by "+ alias + " Concrete Factory class");
					methods.push(method);
				}
				DICTIONARY[T] = {methods:methods, alias:alias, factory:T};
				return true;
			}
			return false;
		}
		
		/**
		 * 
		 * @return
		 */
		public function toString():String 
		{
			return Type.format(this);
		} 
		
		/**
		 * @param
		 * @return
		 */			
		public static function unregister(T:Object):Boolean
		{
			if (!(T is AbstractFactory))
				throw new TypeError("type error");
			var alias:String = Type.getClassPath(T);
			if (hasFactory(alias)) {
				delete DICTIONARY[T];
				return true;
			}
			return false;			
		}	

		protected static var DICTIONARY:Dictionary;			
		protected var _concrete:Boolean;
		
		//static initializer
		{
			DICTIONARY = new Dictionary(false);
		}
	}
}