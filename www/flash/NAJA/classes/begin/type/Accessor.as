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
	 * An Accessor provides information about, and dynamic access to, a single field of a class or an interface. 
	 * The reflected field may be a class (static) field or an instance field. 
	 * A Field permits widening conversions to occur during a get or set access operation, but throws an 
	 * IllegalArgumentException if a narrowing conversion would occur. 
	 * 
	 * @author abiendo@gmail.com
	 */
	public class Accessor extends Variable {
		/**
		 * 
		 * @param	type
		 * @param	name
		 * @param	type
		 * @param	isStatic
		 * @param	metadatas
		 */
		public function Accessor(declaringType : Type, name : String, access : String, type : String, isStatic : Boolean, metadatas : Array = null) {
			super(declaringType, name, type, isStatic, metadatas);
			_access = access;
		}

		/**
		 * 
		 * @return
		 */
		override public function toString() : String {
			return Type.format(this, null, ["declaringType", "name", "access", "isStatic", "metadatas", "type", "value"]);
		}

		public function get access() : String { 
			return _access; 
		}

		public function set access(value : String) : void {
			_access = value;
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
		override public function set value(value : *) : void {
			if (declaringType.isDynamic || access != Type.READONLY)
				declaringType.source[name] = value;
		}

		/**
		 * @return String - the class version
		 */
		//override public function get version() : String {
			//return upgrade(10.1);
		//}
//
		private var _access : String;		
	}
}