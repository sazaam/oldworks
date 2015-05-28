/**
 * BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
 * BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
 * 
 * BBBBBBBBBBBBBBB					  BBBBBBBBBBBBBB			        BBBBBBBBBBBB				
 * BBBBBBBBBBBBBBBBB			    BBBBBBBBBBBBBBBBBB			      BBBBBBBBBBBBBBBB				
 * BBBBBB	    BBBBBB			  BBBBBB		  BBBBBB		    BBBBBB	      BBBBBB	
 * BBBBBB	     BBBBBB			 BBBBBB		       BBBBBB		   BBBBBB	       BBBBBB
 * BBBBBB	    BBBBBB	   B	BBBBBB			    BBBBBB	  B	  BBBBBB	        BBBBBB
 * BBBBBBBBBBBBBBBBBB	  BBB  BBBBBB			     BBBBBB  BBB  BBBBBBBBBBBBBBBBBBBBBBBB
 * BBBBBBBBBBBBBBBBBBBB	  BBB  BBBBBB			     BBBBBB  BBB  BBBBBBBBBBBBBBBBBBBBBBBB
 * BBBBBB		  BBBBBB   B	BBBBBB			    BBBBBB	  B	  BBBBBB			BBBBBB
 * BBBBBB		   BBBBBB		 BBBBBB			   BBBBBB		  BBBBBB			BBBBBB
 * BBBBBB		  BBBBBB		  BBBBBB		  BBBBBB		  BBBBBB			BBBBBB
 * BBBBBBBBBBBBBBBBBBBB 			BBBBBBBBBBBBBBBBBB			  BBBBBB			BBBBBB
 * BBBBBBBBBBBBBBBBBB			      BBBBBBBBBBBBBB			  BBBBBB			BBBBBB
 * 
 * BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
 * BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
 */
package begin.type {

	/**
	 * A Method provides information about, and access to, a single method on a class or interface. 
	 * The reflected method may be a class method or an instance method (including an abstract method). 
	 * A Method permits widening conversions to occur when matching the actual parameters to invoke with 
	 * the underlying method's formal parameters, but it throws an IllegalArgumentException if a narrowing 
	 * conversion would occur. 
	 * 
	 * @author abiendo@gmail.com
	 */
	public class Method extends Descriptor {
		/**
		 * 
		 * @param	declaringClass
		 * @param	name
		 * @param	returnType
		 * @param	parameters
		 * @param	isStatic
		 * @param	metadata
		 */
		public function Method(declaringType : Type, name : String, returnType : String, isStatic : Boolean, parameters : Array = null, metadatas : Array = null) {
			super(declaringType, name);
			_returnType = returnType;
			_parameters = parameters;
			_isStatic = isStatic;	
			_metadatas = metadatas || [];
			if (_metadatas.length) {
				var len : int = _metadatas.length;
				while (len--)
					Metadata(_metadatas[len]).parent = this;
			}
			var m:int= isStatic ? Modifier.STATIC : Modifier.PUBLIC;
			_modifiers = new Modifier(declaringType, Modifier.toString(m), m);				
		}

		/**
		 * Invokes the underlying method represented by this Method object, on the specified object with the specified parameters. 
		 * Individual parameters are automatically unwrapped to match primitive formal parameters, and both primitive and reference 
		 * parameters are subject to method invocation conversions as necessary. 
		 * If the underlying method is static, then the specified obj argument is ignored. It may be null. 
		 * If the number of formal parameters required by the underlying method is 0, the supplied args array may be of 
		 * length 0 or null. 
		 * If the underlying method is an instance method, it is invoked using dynamic method lookup as documented in The 
		 * Java Language Specification, Second Edition, section 15.12.4.4; in particular, overriding based on the runtime type of 
		 * the target object will occur. 
		 * If the underlying method is static, the class that declared the method is initialized if it has not already 
		 * been initialized. 
		 * If the method completes normally, the value it returns is returned to the caller of invoke; if the value has a 
		 * primitive type, it is first appropriately wrapped in an object. However, if the value has the type of an array of a 
		 * primitive type, the elements of the array are not wrapped in objects; in other words, an array of primitive type is 
		 * returned. If the underlying method return 
		 * 
		 * @param	scope Object - the object the underlying method is invoked from
		 * @param	... args Array - the arguments used for the method call  
		 * @return  * - the result of dispatching the method represented by this object on obj with parameters args 
		 */
		public function invoke(... args : Array) : * {
			var o : Object = isStatic ? declaringType.declaringClass : declaringType.source;
			if (o[name] as Function) {
				var tmp : Array = [];
				var f : Function = o[name] as Function;				
				if (isStatic) {
					if (returnType == "void") {
						if (parameters.length == 0)
							f();
						else
							f.apply(null, tmp.concat(args));
						return;
					}
					if (parameters.length == 0)
						return f();
					return f.apply(null, tmp.concat(args));
				}
				if (returnType == "void") {
					if (parameters.length == 0)
						f.apply(o);
					else
						f.apply(o, tmp.concat(args));
					return;
				}
				if (parameters.length == 0)
					return f.call(o);
				return f.apply(o, tmp.concat(args));
			}
			throw new ArgumentError(name);
		}

		/**
		 * 
		 * @return
		 */
		public function isVarArgs() : Boolean {
			return false;
		}

		/**
		 * 
		 */
		public function getExceptionTypes() : Array {
			var list : Array = getParameterTypes();
			var len : int = list.length;
			var tmp : Array = [];
			var type : Type;
			while(len--) {
				type = Type(list[len]);
				if (Type.isAssignableFrom(type.declaringClass, Error))
					tmp.push(type.declaringClass);
			}
			return tmp;
		}

		/**
		 * 
		 * @return
		 */
		public function getParameterTypes() : Array {
			var param : Array = parameters;
			var len : int = param.length;
			var tmp : Array = [];		
			var p : Parameter;
			var c : Type;
			while(len--) {
				p = Parameter(param[len]);
				c = p.toGenericType();
				tmp[len] = c;
			}
			return tmp;
		}

		/**
		 * Returns a Class that represents the declared type for the field represented by this Field object. 
		 * If the Type is a parameterized type, the Type object returned must accurately reflect the actual type 
		 * parameters used in the source code. 
		 * If the type of the underlying field is a type variable or a parameterized type, it is created. Otherwise, 
		 * it is resolved. 
		 * 
		 * @return 	Class - a Class that represents the declared type for the field represented by this Field object
		 */
		override public function toGenericClass() : Class {
			return Type.getClassByName(returnType);
		}

		/**
		 * 
		 * @return
		 */
		public function toGenericReturnClass() : Class {
			return Type.getClassByName(returnType);
		}

		/**
		 * 
		 * @return
		 */
		public function toGenericReturnType() : Type {
			return new Type(Type.getClassByName(returnType));
		}

		/**
		 * 
		 * @return
		 */
		override public function toGenericString() : String {
			return Type.format(toGenericClass());
		}

		/**
		 * Returns a Type object that represents the declared type for the field represented by this Field object. 
		 * If the Type is a parameterized type, the Type object returned must accurately reflect the actual type parameters 
		 * used in the source code. 
		 * If the type of the underlying field is a type variable or a parameterized type, it is created. Otherwise, it is resolved. 
		 * 
		 * @return  Type - a Type object that represents the declared type for the field represented by this Field object 
		 */
		override public function toGenericType() : Type {
			return Type.getDefinition(toGenericClass());
		}

		
		public function get isStatic() : Boolean { 
			return _isStatic; 
		}

		public function set isStatic(value : Boolean) : void {
			_isStatic = value;
		}

		public function get metadatas() : Array { 
			return _metadatas; 
		}

		public function set metadatas(value : Array) : void {
			_metadatas = value;
		}

		public function get modifiers() : Modifier {
			return _modifiers;
		}
		
		public function set modifiers(modifier : Modifier) : void {
			_modifiers = modifier;
		}
		
		public function get parameters() : Array { 
			return _parameters; 
		}

		public function set parameters(value : Array) : void {
			_parameters = value;
		}

		public function get returnType() : String { 
			return _returnType; 
		}

		public function set returnType(value : String) : void {
			_returnType = value;
		}

		private var _isStatic : Boolean;
		private var _metadatas : Array;
		private var _modifiers : Modifier;		
		private var _parameters : Array;
		private var _returnType : String;
	}
}