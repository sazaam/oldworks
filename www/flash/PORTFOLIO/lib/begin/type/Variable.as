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
	 * ...
	 * @author abiendo@gmail.com
	 */
	public class Variable extends Descriptor {
		/**
		 * 
		 * @param	declaringClass
		 * @param	name
		 * @param	type
		 * @param	isStatic
		 * @param	metadatas
		 */
		public function Variable(declaringType : Type, name : String, type : String, isStatic : Boolean, metadatas : Array = null) {	
			super(declaringType, name);
			_type = type;
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
		 * Returns a Class that represents the declared type for the field represented by this Field object. 
		 * If the Type is a parameterized type, the Type object returned must accurately reflect the actual type 
		 * parameters used in the source code. 
		 * If the type of the underlying field is a type variable or a parameterized type, it is created. Otherwise, 
		 * it is resolved. 
		 * 
		 * @return 	Class - a Class that represents the declared type for the field represented by this Field object
		 */
		override public function toGenericClass() : Class {
			return Type.getClassByName(type);
		}

		/**
		 * 
		 * @return
		 */
		override public function toGenericString() : String {
			return Type.format(value);
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
			return Type.getDefinition(value);
		}

		/**
		 * 
		 * @return
		 */
		override public function toString() : String {
			return Type.format(this, null, ["declaringType", "name", "isStatic", "metadatas", "type", "value"]);
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
		
		public function get type() : String { 
			return _type; 
		}

		public function set type(value : String) : void {
			_type = value;
		}

		/**
		 * Returns the value of the field represented by this Field, on the specified object. The value is automatically 
		 * wrapped in an object if it has a primitive type. 
		 * The underlying field's value is obtained as follows: 
		 * If the underlying field is a static field, the obj argument is ignored; it may be null. 
		 * Otherwise, the underlying field is an instance field. If the specified obj argument is null, the method throws 
		 * a NullPointerException. If the specified object is not an instance of the class or interface declaring the u
		 * nderlying field, the method throws an IllegalArgumentException. 
		 * If this Field object enforces Java language access control, and the underlying field is inaccessible, the method 
		 * throws an IllegalAccessException. If the underlying field is static, the class that declared the field is 
		 * initialized if it has not already been initialized. 
		 * Otherwise, the value is retrieved from the underlying instance or static field. If the field has a primitive type, 
		 * the value is wrapped in an object before being returned, otherwise it is returned as is. 
		 * If the field is hidden in the type of obj, the field's value is obtained according to the preceding rules. 
		 * 
		 * @return  * - the value of the represented field in object obj; primitive values are wrapped in an appropriate object 
		 * 				before being returned  
		 */		
		public function get value() : * {
			return declaringType.source[name];
		}

		/**
		 * Sets the field represented by this Field object on the specified object argument to the specified new value. 
		 * The new value is automatically unwrapped if the underlying field has a primitive type. 
		 * The operation proceeds as follows: 
		 * If the underlying field is static, the obj argument is ignored; it may be null. 
		 * Otherwise the underlying field is an instance field. If the specified object argument is null, the method throws 
		 * a NullPointerException. If the specified object argument is not an instance of the class or interface declaring 
		 * the underlying field, the method throws an IllegalArgumentException. 
		 * If this Field object enforces Java language access control, and the underlying field is inaccessible, the method 
		 * throws an IllegalAccessException. 
		 * If the underlying field is final, the method throws an IllegalAccessException unless setAccessible(true) has 
		 * succeeded for this field and this field is non-static. Setting a final field in this way is meaningful only during 
		 * deserialization or reconstruction of instances of classes with blank final fields, before they are made available 
		 * for access by other parts of a program. Use in any other context may have unpredictable effects, including cases in 
		 * which other parts of a program continue to use the original value of this field. 
		 * If the underlying field is of a primitive type, an unwrapping conversion is attempted to convert the new value to a 
		 * value of a primitive type. If this attempt fails, the method throws an IllegalArgumentException. 
		 * If, after possible unwrapping, the new value cannot be converted to the type of the underlying field by an identity 
		 * or widening conversion, the method throws an IllegalArgumentException. 
		 * If the underlying field is static, the class that declared the field is initialized if it has not already been 
		 * initialized. 
		 * The field is set to the possibly unwrapped and widened new value. 
		 * If the field is hidden in the type of obj, the field's value is set according to the preceding rules. 
		 * 
		 * @param	value * - the new value for the field of obj being modified
		 */
		public function set value(value : *) : void {
			declaringType.source[name] = value;
		}

		/**
		 * @return String - the class version
		 */
		//override public function get version() : String {
			//return upgrade(10.1);
		//}

		private var _declaringClass : Class;
		private var _isStatic : Boolean;
		private var _metadatas : Array;
		private var _modifiers : Modifier;
		private var _type : String;
		
	}
}