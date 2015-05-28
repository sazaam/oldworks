package modules.patterns.proxies
{
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import modules.foundation.Type;
	import modules.foundation.io.Serializable;
	import modules.patterns.Prototype;
	
	use namespace flash_proxy;
	/**
	 * DynamicProxy provides static methods for creating dynamic proxy classes and instances, and it is also the superclass 
	 * of all dynamic proxy classes created by those methods. 
	 * A dynamic proxy class (simply referred to as a proxy class below) is a class that implements a list of interfaces 
	 * specified at runtime when the class is created, with behavior as described below. A proxy interface is such an interface 
	 * that is implemented by a proxy class. A proxy instance is an instance of a proxy class. Each proxy instance has an 
	 * associated proxy handler object, which implements the interface ProxyHandler
	 */
	public dynamic class DynamicProxy extends Proxy implements Prototype, Serializable
	{
		/**
		 * Constructs a new Proxy instance from a subclass (typically, a dynamic proxy class) with the specified 
		 * value for its Proxy handler.
		 * @param	DynamicProxy ProxyHandler - The proxy handler for this proxy instance
		 */
		public function DynamicProxy(behavior:ProxyHandler=null) 
		{
			_behavior = behavior || new Handler();//default array behavior
			
			var hashTable:Object = getHashTable();
			_definition = { methods:hashTable.dict,
							methodsList:hashTable.list,
							methodsLength:hashTable.list.length };
			super();
		}
		
		public function clone(prototype:Object=null):Object
		{
			return Type.clone(this);
		}
										
		public function equals(T:Object):Boolean
		{
			if (T == this)
				return true;
			if(!(T is DynamicProxy))
				return false;
			var type:DynamicProxy = T as DynamicProxy;
			return hashCode() ==  type.hashCode();
		}
		
		public function finalize(prototype:Object=null):void
		{
			
		}
		
		public function getClass():Type
		{
			return Type.getDefinition(this);
		}

		/**
		 * 
		 * @param	alias
		 * @param	contextDomain
		 * @return
		 */
		public static function getProxyClass(alias:String, contextDomain:ApplicationDomain=null):Class
		{
			return Type.getClassByName(alias, contextDomain);
		}
		
		/**
		 * Returns an instance of a proxy class for the specified interfaces that dispatches method invocations to the specified 
		 * invocation handler. 
		 This method is equivalent to: 
		 * @param	handler ProxyHanler - The proxy handler to dispatch method invocations to 
		 * @return	DynamicProxy - a proxy instance with the specified invocation handler of a proxy class that is defined by 
		 * 							the specified class loader and that implements the specified interfaces 
		 */
		public static function getProxyInstance(behavior:ProxyHandler=null):DynamicProxy
		{
			return Type.getInstance(DynamicProxy, behavior) as DynamicProxy;
		}
				
		public function hashCode():int
		{
			return getClass().defaultHashCode;
		}
		
		/**
		 * Returns true if and only if the specified class was dynamically generated to be a proxy class using the getProxyClass 
		 * method or the newProxyInstance method. 
		 * The reliability of this method is important for the ability to use it to make security decisions, so its implementation 
		 * should not just test if the class in question extends DynamicProxy. 
		 * @param	T Class - The class to test 
		 * @return	Boolean - True if the class is a proxy class and false otherwise 
		 */
		public static function isProxyType(T:Object):Boolean
		{
			return Type.instanceOf(T, DynamicProxy);
		}	
		
		/**
		 * 
		 * @param	input
		 */
		public function readExternal(input:IDataInput):void
		{
	        _behavior = input.readObject();
		}
		
		/**
		 * 
		 * @return
		 */
		public function toSource():String
		{
			return null;
		}
				
		/**
		 * 
		 * @return
		 */
		public function toString():String
		{
			return "[object DynamicProxy : (behavior :"+ _behavior +")]";
		}
		
		public function valueOf():Object
		{
			return this;
		}
		
		/**
		 * 
		 * @param	output
		 */
		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject(_behavior);
		}
		
		public function get behavior():ProxyHandler 
		{ 
			return _behavior; 
		}
		
		public function set behavior(value:ProxyHandler):void 
		{
			_behavior = value;
		}
				
		/**
		 * 
		 * @param	name
		 * @param	...parameters
		 * @return
		 */
		override flash_proxy function callProperty(name:*, ...parameters:Array):*
		{
	        if (name is QName)
	            name = name.localName;
			var methods:Dictionary = _definition.methods;
			if (name in methods)
				return _behavior.invoke.apply(_behavior, [null, name].concat(parameters));
			return this[name].apply(this, [].concat(parameters));
		}
		
	    /**
	     *  @private
	     */			
		//override flash_proxy function deleteProperty(name:*):Boolean 
		//{
			//var n:Number = parseInt(String(name));
			//var index:int = -1;
			//if (!isNaN(n))
			   //index = int(n);
	        //return removeAt(index) != null;
		//}
		
	    /**
		 *  @private
		 *  Attempts to call getItemAt(), converting the property name into an int.
	     */	 		
		override flash_proxy function getProperty(name:*):*
		{
	        if (name is QName)
	            name = name.localName;
			return (_behavior is Handler ? Handler(_behavior).aspect[name] : _behavior[name]) || this[name];  
		}
	    /*
	flash_proxy override function getProperty(name:*):*
	{
		function anonymous(...args) : *
		{
			return flash_proxy::callProperty.apply(this, new Array(name).concat(args));
		}

         	return anonymous;
     	}
 This basically returns an anonymous function for use when calling a  
method with an undefined arity (this is not exactly good design, but  
useful none the less) as shown below:

	var methodName:String = 'registerTransport';
	var arguments:Array = [new Foot, new PogoStick, new Car, new  
JeffersonAirplane, new JeffersonStarship];

	var token:HessianToken = (hessianProxy[methodName] as  
Function).apply(this, arguments);

Note that the above example is identical to calling:

	var token:HessianToken = hessianProxy.registerTransport(new Foot, new  
PogoStick, new Car, new JeffersonAirplane, new JeffersonStarship);

	    */
	    /**
	     *  @private
	     *  This is an internal function.
	     *  The VM will call this method for code like <code>"foo" in bar</code>
	     *  
	     *  @param name The property name that should be tested for existence.
	     */		
		override flash_proxy function hasProperty(name:*):Boolean
		{
	        if (name is QName)
	            name = name.localName;
			if (_behavior is Handler)
				return  Handler(_behavior).aspect[name] != null;
			return _behavior[name] != null;
		}

	    /**
	     *  @private
	     */			
		override flash_proxy function nextName(index:int):String
		{
        	return (index - 1).toString();
		}
	
	    /**
	     *  @private
	     */		
		override flash_proxy function nextNameIndex(index:int):int
		{
			return  index < _definition.methods.length ? index + 1 : 0;
		}	
	    
	    /**
	     *  @private
	     */		
		override flash_proxy function nextValue(index:int):*
		{
       		return resolve()[_definition.methods[index - 1].name];
		}		
	    
	    /**
		 *  @private
		 *  Attempts to call setItemAt(), converting the property name into an int.
	     */		
		override flash_proxy function setProperty(name:*, value:*):void
		{
	        if (name is QName)
	            name = name.localName;
	
	        var index:int = -1;
	        try {
	            // If caller passed in a number such as 5.5, it will be floored.
	            var n:Number = parseInt(String(name));
	            if (!isNaN(n)) {
	                index = int(n);
					_behavior[index] = value;
					return;
				}
	        } catch (e:Error) { }// localName was not a number			
	        _behavior[name] = value;
		}

		protected function getHashTable():Object
		{
			var list:Array = toDefinition().methods;
			var methods:Dictionary = new Dictionary();
			list.forEach(function(el:*, i:int, arr:Array):void { 
				methods[el.name] = resolve()[el.name];
			} );
			return {dict:methods, list:list};
		}
		
		protected function resolve():Object
		{
			return _behavior is Handler ? Handler(_behavior).aspect : _behavior;
		}
		
		protected function toDefinition():Type
		{
			return Type.getDefinition(resolve());
		}
		
		protected var _behavior:ProxyHandler;	
		protected var _definition:Object;
	}
}