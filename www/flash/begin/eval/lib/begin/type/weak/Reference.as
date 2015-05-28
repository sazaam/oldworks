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
package begin.type.weak {
	import begin.type.Type;

	/**
	 * ...
	 * @author abiendo@gmail.com
	 */
	public final class Reference extends Object {
		/**
		 * 
		 * @param	key
		 * @param	value
		 */
		public function Reference(alias : String, ref : Class, description : XML, isDynamic : Boolean = false, isFinal : Boolean = false, isStatic : Boolean = false) {
			super();
			_alias = alias;
			_ref = ref;
			_description = description;
			_isDynamic = isDynamic;
			_isFinal = isFinal;
			_isStatic = isStatic;
		}

		public static function create(alias : String, ref : Class, classDesc : XML, isDynamic : Boolean = false, isFinal : Boolean = false, isStatic : Boolean = false) : Reference {
			classDesc.@isDynamic = isDynamic;
			classDesc.@isFinal = isFinal;
			classDesc.@isStatic = isStatic;
			return new Reference(alias, ref, classDesc, isDynamic, isFinal, isStatic);
		}

		public static function exist(element : *) : Boolean {
			return Type.hasReference(element);
		}

		/**
		 * register the class in the current domain application
		 */
		public static function registerInstance(instance : *, isDynamic : Boolean = false, isFinal : Boolean = false, isStatic : Boolean = false) : Boolean {
			return Type.register(instance, null, isDynamic, isFinal, isStatic);
		}

		/**
		 * 
		 * @param	key
		 * @param	owner
		 */
		public static function unregisterInstance(instance : *) : Boolean {
			return Boolean(Type.unregister(instance));
		}

		/**
		 * @return String - the class version
		 */
		public function get alias() : String {
			return _alias;
		}

		/**
		 * @return String - the class version
		 */
		public function get description() : XML {
			return _description;
		}

		public function set description(value : XML) : void {
			_description = value;
		}

		public function get instanceDescription() : XML {
			return _instanceDescription;
		}

		public function set instanceDescription(value : XML) : void {
			_instanceDescription = value;
		}

		public function get isDynamic() : Boolean {
			return _isDynamic;
		}

		public function get isFinal() : Boolean {
			return _isFinal;
		}

		public function get isStatic() : Boolean {
			return _isStatic;
		}

		public function get ref() : Class {
			return _ref;
		}

		private var _alias : String; 
		private var _description : XML; 
		private var _instanceDescription : XML;
		private var _isDynamic : Boolean;
		private var _isFinal : Boolean;
		private var _isStatic : Boolean;
		private var _ref : Class;
	}
}