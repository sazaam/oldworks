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
	 * ...
	 * @author abiendo@gmail.com
	 */
	public class Descriptor extends Object {
		/**
		 * Create a new Descriptor instance from the specified type parameter.
		 * 
		 * @param	type Type - the type of the Descriptor instance.
		 * @param	name
		 */
		public function Descriptor(type : Type, name : String) {
			super();
			_declaringType = type;
			_name = name;
		}

		/**
		 * Creates and returns a copy of this object. The precise meaning of "copy" may depend on the class of the object. 
		 * The general intent is that, for any object Cloneable(x), the expression:
		 * Cloneable(x).clone() != x will be true, 
		 * and that the expression:
		 * Equal(Cloneable(x).clone().getType()).equals(x.getType()) will be true, but these are not absolute requirements. 
		 * While it is typically the case that:
		 * Equal(Cloneable(x).clone()).equals(x) will be true, this is not an absolute requirement.
		 * By convention, the object returned by this method should be independent of this object (which is being cloned). 
		 * To achieve this independence, it may be necessary to modify one or more fields of the object returned by super.clone 
		 * before returning it. Typically, this means copying any mutable objects that comprise the internal "deep structure" of 
		 * the object being cloned and replacing the references to these objects with references to the copies. 
		 * If a class contains only primitive fields or references to immutable objects, then it is usually the case that no fields 
		 * in the object returned by super.clone need to be modified.
		 * The method clone for Cloneable class performs a specific cloning operation. First, if the class of this object does not 
		 * support the clone method then a CloneNotSupportedException is thrown. Note that a lot of Boa object are considered to 
		 * implement the interface Cloneable. Otherwise, this method creates a new instance of the class of this object 
		 * and initializes all its fields with exactly the contents of the corresponding fields of this object, as if by assignment; 
		 * the contents of the fields are not themselves cloned. Thus, this method performs a "shallow copy" of this object, 
		 * not a "deep copy" operation.
		 * The Base class implements itself the interface Cloneable, but calling the clone method on an object whose class 
		 * is Base will result in a throwing a CloneNotSupportedException Because this method is supposed to be overriden in subclasses.
		 * 
		 * @param properties * (default = null) - Properties to pass to the clone instance.
		 * @return Object - The clone instance of the specified object.
		 */
		public function clone(source : Object = null) : Object {
			if (source != null)
				return Instance.create(this, source["declaringType"] || declaringType, source["name"] || name);
			return Instance.create(this, declaringType.clone(), name);
		}

		/**
		 * The equals method implements an equivalence relation on non-null object references: 
		 * It is reflexive: for any non-null reference value Equal(x), Equal(x).equals(x) should return true. 
		 * It is symmetric: for any non-null reference values Equal(x) and Equal(y), Equal(x).equals(y) should return true 
		 * if and only if Equal(y).equals(x) returns true. 
		 * It is transitive: for any non-null reference values Equal(x), Equal(y), and Equal(z), if Equal(x).equals(y) returns true 
		 * and Equal(y).equals(z) returns true, then Equal(x).equals(z) should return true. 
		 * It is consistent: for any non-null reference values Equal(x) and Equal(y), multiple invocations of Equal(x).equals(y) 
		 * consistently return true or consistently return false, provided no information used in equals 
		 * comparisons on the objects is modified. 
		 * For any non-null reference value Equal(x), Equal(x).equals(null) should return false. 
		 * The equals method for class Object implements the most discriminating possible equivalence relation 
		 * on objects; that is, for any non-null reference values Equal(x) and Equal(y), this method returns true 
		 * if and only if x and y refer to the same object (x == y has the value true). 
		 * Note that it is generally necessary to implements the hashCode method of the Hashable interface whenever this method is overridden, 
		 * so as to maintain the general contract for the hashCode method, which states that equal objects 
		 * must have equal hash codes. 
		 * 
		 * @param	o Object - The reference object with which to compare. 
		 * @return	Boolean - True if this object is the same as the obj argument; false otherwise.
		 */
		public function equals(o : Object) : Boolean {
			return Boolean(declaringType == Descriptor(o).declaringType && name == Descriptor(o).name);
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
		public function toGenericClass() : Class {
			return Type.getClassByName(name);
		}

		/**
		 * 
		 * @return
		 */
		public function toGenericString() : String {
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
		public function toGenericType() : Type {
			return Type.getDefinition(toGenericClass());
		}

		/**
		 * 
		 * @return
		 */
		public function toString() : String {
			return Type.format(this, null, ["declaringType", "name"]);
		}			

		public function get name() : String {
			return _name;
		}

		public function set name(value : String) : void {
			_name = value;
		}

		public function get declaringType() : Type { 
			return _declaringType; 
		}

		public function set declaringType(value : Type) : void {
			_declaringType = value;
		}
		
		public function getType():Type {
			if (_definition == null)
				_definition = new Type(this);
			return _definition;
		}
	
		protected function getModifiers() : Object {
			return {
				isDynamic:false, 
				isFinal:false, 
				isStatic:false
			};	
		}
		
		private var _definition:Type;
		private var _declaringType : Type;
		private var _name : String;		 
	}
}