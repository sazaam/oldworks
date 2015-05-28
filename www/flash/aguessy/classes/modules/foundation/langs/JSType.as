package modules.foundation.langs
{
	import modules.foundation.Type;
	
	public class JSType
	{
		public static const METHODS:Array = ['constructor', 'toString', 'toLocaleString', 'isPrototypeOf', 'propertyIsEnumerable', 'hasOwnProperty', 'valueOf'];
		
		/**
		 * 
		 * @param	... list
		 */
		public function JSType(... list:Array)
		{
			var len:int = list.length;
			var i:int;
			for (i = 0; i < len; i++)
				parameters.push(list[i]);
			trace(parameters.length);
		}
 		
		/**
		 * 
		 * @param	receiver
		 * @param	supplier
		 * @param	shadow
		 * @param	replace
		 */
        public static function borrow(receiver:Object, supplier:Object, shadow:Boolean=false, replace:Boolean=false):void
        {      
            // Throw an error if supplier or receiver is not an Object or a Function.
            if (typeof supplier != 'object' && typeof supplier != 'function') 
                throw new TypeError('borrow failed: supplier not an object or function: ' + typeof supplier);
            
            if (typeof receiver != 'object' && typeof receiver != 'function') 
                throw new TypeError('borrow failed: receiver not an object or function: ' + typeof supplier);
                
            var p:String;           
            for (p in supplier) {           	
                var rp:* = receiver[p];               
                if (rp === supplier[p] || !supplier.hasOwnProperty(p)) 
                    continue;               
                // User must explicitly copy this over.
                if (p == 'constructor') 
                    continue;                
                if (shadow && replace)// shadow and replace 
                    receiver[p] = supplier[p];
                else if (shadow && !receiver.hasOwnProperty(p))// shadow, don't replace
                   	receiver[p] = supplier[p];
                else if (replace && (receiver.hasOwnProperty(p) && !receiver.constructor.prototype[p]))// replace, don't shadow
                    receiver[p] = supplier[p];
                else 
                	if (!receiver[p])// don't shadow, don't replace          
                     	receiver[p] = supplier[p];// don't shadow, don't replace.
            }
            if (shadow) 
                dontEnum(receiver, supplier, replace);
        }
 		
 		/**
 		 * 
 		 * @param	r
 		 * @param	s
 		 * @param	replace
 		 */              		
		public static function dontEnum(r:Object, s:Object, replace:Boolean=false):void
		{       
            // JScript goes wrong here.
            var enums:Array = [].concat(METHODS);           
            if (s is Function && typeof s.call == 'function') 
                enums.push('call', 'apply', 'prototype');
            var l:int = enums.length, i:int = 0, p:String;
            do {
                p = enums[i];
                if (!s.hasOwnProperty(p) || r[p] === s[p]) 
                    continue;
                if (replace || !r.hasOwnProperty(p)) 
                    r[p] = s[p];
            }
            while (i++ < enums.length)
        }
        	
 		/**
 		 * 
 		 * @param	...parameters
 		 * @return
 		 */ 
 		public static function getConstructor(...parameters:Array):Function
 		{
 			return function():Function {
            	return function(...parameters:Array):void
            	{
                	if (this.superclass != null) {
						this.superclass.apply(this, parameters);
						
						
					}
                };
            }();
 		}
 		 			
 		/**
 		 * 
 		 * @param	o
 		 * @return
 		 */        
        public static function getImplementationCount(o:Object):int
        {
            var i:int = 0;
            for (var p:String in o) 
                if (hasOwnMethod(o, p)) 
                    i++;
            return i;
        }
 				
 		/**
 		 * 
 		 * @param	...parameters
 		 * @return
 		 */
		public static function getInstance(...parameters:Array):JSType
		{
            return Type.getInstance.apply(null, [JSType].concat(parameters));
        }
          		
 		/**
 		 * 
 		 * @param	T
 		 * @param	o
 		 * @return
 		 */
        public static function hasImplementation(T:Object, o:Object):Boolean
        {
            if (T is Function) {
                var i:int = 0, p:String;
                for (p in o) 
                    if (!hasOwnMethod(o, p) && T.prototype[p]) 
                        i++;
                return i == getImplementationCount(o);
            }
            return false;
        }
  		
 		/**
 		 * 
 		 * @param	o
 		 * @param	p
 		 * @return
 		 */      
        public static function hasOwnMethod(o:Object, p:String):Boolean
        {
            return o.hasOwnProperty(p) && o[p] is Function && !(o[p] == 'constructor' || o[p] == 'toString' || o[p] == 'valueOf' || o[p] == 'hasOwnProperty' || o[p] == 'extend');
        }
 		
 		/**
 		 * 
 		 * @param	T
 		 * @param	o
 		 */        		
		public static function implementMethods(T:Object, o:Object):void
		{
			var p:String;
            for (p in o) {
                if (hasOwnMethod(o, p)) {
                    if (!T[p]) 
                        T[p] = o[p];
                }
            }
        }      
 		
 		/**
 		 * 
 		 * @param	T
 		 * @return
 		 */             
        public static function isEmptyPrototype(T:Object):Boolean
        {
            var i:int = 0, p:String, o:Object = resolve(T).prototype;
            for (p in o) 
                if (!isNonEnumerable(p, true))
                    i++;
            return i == 0;
        }
        
 		/**
 		 * 
 		 * @param	constructor
 		 * @return
 		 */  
        public static function isNativeJavascript(constructor:Function):Boolean
        {
            return false;//(new RegExp("/^\s*function[^{]+{\s*\[native code\]\s*}\s*$/")).test(constructor);
        } 
         		
 		/**
 		 * 
 		 * @param	p
 		 * @param	asFunction
 		 */ 
        public static function isNonEnumerable(p:String, asFunction:Boolean=false)
        {
            var enums:Array = [].concat(METHODS);            
            if (asFunction) 
                enums.push('call', 'apply', 'prototype');                
            var l:int = enums.length, i:int = 0, prop:String;           
            do {
                prop = enums[i];                
                if (p == prop) 
                    return true;
            }
            while (i++ < enums.length)
            return false;
        }
 		
 		/**
 		 * 
 		 * @param	o
 		 * @param	p
 		 * @return
 		 */       
        public static function isPropertyEnumerable(o:Object, p:String):Boolean
        {
            return o.propertyIsEnumerable(p);
        }
 		
 		/**
 		 * @param	T Object (default = null) - Resolve the specified type object reference.
 		 */        		
		public static function resolve(T:Object=null):*
		{
			return (T == null) ? getConstructor() : (T is Function) ? T : T.constructor;
		}
 		
 		/**
		 * Promote a function to be a pseudo class.
 		 * @param	T Object (default=null) - 
		 * @return 	Object - The pseudo class specified.
 		 */		
		public static function promote(T:Object=null):Object
		{
            var c:*;
            c = T || resolve();//register the pseudo class condtructor
            c = (c is Function) ? c : c.constructor;//or if T is an object get is constructor
            if (!(c.extend && c.implement)) {//does the pseudo class constructor contains the extends static method or implement static method
                c.extend = function(superclass:*, proto:Object=null):Object//so create the static extend method
                {                   	
                    var subclassprototype:Object = !JSType.isEmptyPrototype(this) ? this.prototype : null;//is the prototype of the pseudo class empty?                        
                    if (superclass is Function) {//is superclass parameters a pseudo class constructor                     
                        var F:Function = function():void {};//create a clean prototype                      
                        F.prototype = (superclass as Function).prototype;//retrieve the superclass prototype                          
                        this.prototype = new F;//affect the safe prototype		
                        this.prototype.superclass = function():Function//declare the superclass method 
                        {
                           return function(...parameters:Array):Object {//tricks the compiler : execute an anonymous function that return the real function 
									if (parameters.length > 0) {//we are trying to call a method of our super class 
                           				var method:* = parameters[0];//is this the name of our super class method
                           				var superprototype:Object = superclass.prototype;//record the superclass prototype
                           				if (method is String && superprototype[method] != null) {//is the specified super class method exist
											
											//.apply(this, parameters.slice(1, parameters.length));
                           					return superprototype[method].apply(superprototype[method], parameters.slice(1, parameters.length))//return the specified superclass method
											
										}
                           			}   
									//throw new ReferenceError("c'ant resolve specified method reference " + method);//enable to resolve the specified reference
                                	return superclass.apply(this, parameters);//return the superclass after applying parameters
                           		};
                        }();                               
                    } else if (superclass is Object && subclassprototype == null) {                         	
                   		JSType.setImplementation(this, superclass);                           		
                	} else {                        		
                    	throw new TypeError('Invalid type arguments');                          	
                 	}
                    if (proto != null && subclassprototype != null) 
                        throw new TypeError("Multiple inheritance not allowed use interface instead");  
                    if (proto != null) {
                        JSType.setImplementation(this, proto);
                    } else {
                        if (subclassprototype != null) 
                            JSType.setImplementation(this, subclassprototype);
                    }
                    return this.prototype.constructor = this; 
                };                   
                c.implement = function():Object
                {
                	/*
                    if (arguments.length > 0) {
                        var l = arguments.length;
                        while (l--) 
                            Prototype.setImplementation(this, arguments[l]);
                    }
                    */
                    return this;
                };                    
            } else if (!c.extend) {
                /*
                -----------------| interfaces
                c = T;
                
                c.extend = function(T:Object):Object { 
                	return Prototype.setImplementation(this, T); 
                }
                
                */                   
            } else {            
          		throw new TypeError('Cast exception');         		
            }       	
            if (c.prototype.constructor === Object) 
                c.prototype.constructor = c; 
        	return c as Function;
        }
 		
 		/**
 		 * 
 		 * @param	T
 		 * @param	o
 		 * @return
 		 */       
        public static function setImplementation(T:Object, o:Object):Object
        {
			try {
				switch(T) {
					case (T is Function) :
						T = T.prototype;
		                implementMethods(T, o);
						break;
					/*case (Type.isObject(o) && Type.isInterface(o)) :
						if (Type.isInterface(T)) 
		                    T = T;
		                else 
		                    if (Type.isFunction(T)) 
		                        T = T.prototype;
		                    else 
		                        throw new Error('type must be an interface or a function');
		                Type.implementMethods(T, o);
						break;
					case (Type.isObject(o) && Type.isStatic(o)) :
						if (!Type.isFunction(T)) 
		                	throw new Error('type function construtor requiered');
		                Type.implementMethods(T, o);
						break;
					default :
						if (o is Object && T is Function) {
							if (T is Function) {
								for (var p:String in o) 
									if (p !== 'constructor') 
										T.prototype[p] = o[p];
								if (o.hasOwnProperty('toString')) 
									T.prototype.toString = o.toString;
								if (o.hasOwnProperty('valueOf')) 
									T.prototype.valueOf = o.valueOf;
							} else {
		                		throw new TypeError('type must be a function constructor');
		     				}
						}
						break;	
					*/			
				}			
			} catch(ex:Error) {
				trace(ex.message);
			} finally {
				return T;
			}
	    }
	    
	    public function get parameters():Array
	    {
	    	return _parameters;
	    }
	    
	    public function set parameters(value:Array):void
	    {
	    	_parameters = value;
	    }
	    	    
	    private var _parameters:Array;
	}
}
/*
			var isNative:Function = function (func):Boolean
			{
				return new RegExp("/^\s*function[^{]+{\s*\[native code\]\s*}\s*$/").test(func);
			}
			trace(isNative(Array.prototype.push));
*/