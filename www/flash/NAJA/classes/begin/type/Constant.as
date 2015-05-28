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

	public class Constant extends Descriptor {
		/**
		 * 
		 * @param	declaringClass
		 * @param	name
		 * @param	type
		 * @param	isStatic
		 */	
		public function Constant(declaringType : Type, name : String, type : String, isStatic : Boolean) {
			super(declaringType, name);
			_type = type;
			_isStatic = isStatic;
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
			if (isStatic)
				return Type.getDefinition(declaringType.declaringClass[name]);
			return Type.getDefinition(declaringType.source[name]);
		}

		/**
		 * 
		 * @return
		 */
		override public function toString() : String {
			return Type.format(this, null, ["declaringType", "name", "isStatic", "type"]);
		}

		/**
		 * 
		 */
		public function get isStatic() : Boolean { 
			return _isStatic; 
		}

		public function set isStatic(value : Boolean) : void {
			_isStatic = value;
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

		public function get value() : * {
			if (isStatic)
				return declaringType.declaringClass[name];
			return declaringType.source[name];
		}

		private var _isStatic : Boolean;
		private var _type : String;		
		private var _modifiers:Modifier;

	}
}