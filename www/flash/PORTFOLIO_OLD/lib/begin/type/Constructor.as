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
	import begin.type.weak.Instance;
	/**
	 * Constructor provides information about, and access to, a single constructor for a class. 
	 * Constructor permits widening conversions to occur when matching the actual parameters to newInstance() 
	 * with the underlying constructor's formal parameters, but throws an IllegalArgumentException if a narrowing 
	 * conversion would occur. 
	 * 
	 * @author abiendo@gmail.com
	 */
	public class Constructor extends Descriptor {
		/**
	     * Constructor used by Type to enable
	     * instantiation of these objects in Bava code from the Boa.lang
	     * package via boa.lang.reflect.Type.
	     * 
		 * @param name
		 * @param declaringClass
		 * @param parameters
		 * @param metadatas
		 */
		public function Constructor(declaringType : Type, name : String, parameters : Array = null, metadatas : Array = null) {
			super(declaringType, name);
			_metadatas = metadatas || [];
			_parameters = parameters || [];
			var m:int= Modifier.PUBLIC;
			_modifiers = new Modifier(declaringType, Modifier.toString(m), m);			
		}
		
		/**
	     * Package-private routine (exposed to boa.lang.reflect via
	     * Type) which returns a copy of this Constructor. The copy's
	     * "root" field points to this Constructor.
	     */
		public function copy():Constructor {
			return new Constructor(declaringType, name, parameters, metadatas);
		}
		
		/**
		 * Uses the constructor represented by this Constructor object to create and initialize a new instance of the 
		 * constructor's declaring class, with the specified initialization parameters. Individual parameters are automatically 
		 * unwrapped to match primitive formal parameters, and both primitive and reference parameters are subject to method 
		 * invocation conversions as necessary. 
		 * If the number of formal parameters required by the underlying constructor is 0, the supplied initargs array may be 
		 * of length 0 or null. 
		 * If the constructor's declaring class is an inner class in a non-static context, the first argument to the constructor 
		 * needs to be the enclosing instance; see The Java Language Specification, section 15.9.3. 
		 * If the required access and argument checks succeed and the instantiation will proceed, the constructor's declaring 
		 * class is initialized if it has not already been initialized. 
		 * If the constructor completes normally, returns the newly created and initialized instance
		 * 
		 * @param	... initargs Array - array of objects to be passed as arguments to the constructor call;
		 * 									values of primitive types are wrapped in a wrapper object of the appropriate type
		 * @return	* - a new object created by calling the constructor this object represents  
		 */
		public function getInstance(... initargs : Array) : * {
			var tmp : Array = [toGenericClass()];
			return Instance.create.apply(null, tmp.concat(initargs));
		}
		/**
		 * 
		 */
		public function getParameterTypes():Array {
			var tmp:Array = [];
			var len:int = parameters.length;
			while(len--)
				tmp.push(Parameter(parameters[len]).declaringType.declaringClass);
			return tmp;
		}
		
	    /**
	     * Returns <tt>true</tt> if this constructor is a synthetic
	     * constructor; returns <tt>false</tt> otherwise.
	     *
	     * @return true if and only if this constructor is a synthetic
	     * constructor as defined by the Java Language Specification.
	     * @since 1.5
	     */
	    public function isSynthetic():Boolean {
	        return Modifier.isSynthetic(modifiers.value);
	    }
	    		
	    /**
	     * Returns <tt>true</tt> if this constructor was declared to take
	     * a variable number of arguments; returns <tt>false</tt>
	     * otherwise.
	     *
	     * @return <tt>true</tt> if an only if this constructor was declared to
	     * take a variable number of arguments.
	     * @since 1.5
	     */
	    public function isVarArgs():Boolean {
	        return (modifiers.value & Modifier.VARARGS) != 0;
	    }
	    
		/**
		 * 
		 */
		public function setParameterValueAt(index : int, value : *) : void {
			if (index >= 0 && index < parameters.length)
				Parameter(parameters[index]).value = value;
			else
				throw new Error("index : " + index);
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
			return declaringType.declaringClass;
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

		/**
		 * 
		 */
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

		private var _metadatas : Array;
		private var _parameters : Array;
		private var _modifiers:Modifier;
	}
}