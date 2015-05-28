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

	public class Interface extends Descriptor {
		public function Interface(declaringType : Type, name : String, metadatas : Array = null) {
			super(declaringType, name);
			_metadatas = metadatas || [];
			var m:int= Modifier.INTERFACE;
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
			return Type.getClassByName(name);
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

		public function get modifiers() : Modifier {
			return _modifiers;
		}
		
		public function set modifiers(modifier : Modifier) : void {
			_modifiers = modifier;
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

		private var _metadatas : Array;
		private var _modifiers : Modifier;		
	}
}