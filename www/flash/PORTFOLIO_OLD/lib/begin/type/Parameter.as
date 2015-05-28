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
	public class Parameter extends Descriptor {
		/**
		 * 
		 * @param	declaringClass
		 * @param	name
		 * @param	type
		 * @param	optional
		 * @param	value
		 */
		public function Parameter(declaringType : Type, name : String, type : String, optional : Boolean, value : *=  null) {
			super(declaringType, name);
			initValue(value);
			_optional = optional;
			_type = type;
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
		 
		override public function toString():String
		{
		return Type.format(this, null, ["declaringClass", "name", "optional", "type", "value"]);
		}	
		 */
		/**
		 * 
		 */
		public function get optional() : Boolean { 
			return _optional; 
		}

		public function set optional(value : Boolean) : void {
			_optional = value;
		}		

		public function get type() : String { 
			return _type; 
		}

		public function set type(value : String) : void {
			_type = value;
		}

		public function get value() : * { 
			return _value; 
		}

		public function set value(value : *) : void {
			_value = value;
		}

		/**
		 * @return String - the class version
		 */
		//override public function get version() : String {
			//return upgrade(10.1);
		//}

		/*
		 * 
		 */

		protected function initValue(val : *=  null) : void {	
			if (val == null) {
				switch(type) {
					case "int":
						value = 0;
						break;
					case "Number":
						value = NaN;
						break;
					case "String":
						value = null;
						break;
					case "uint":
						value = 0;
						break;
					default:
						value = null;
						break;				
				}
			} else {
				value = val;
			}
		}

		private var _optional : Boolean;
		private var _type : String;
		private var _value : *;
	}
}