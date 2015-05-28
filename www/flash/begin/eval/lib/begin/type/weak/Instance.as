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
	 * 
	 * @author abiendo@gmail.com
	 */
	public final class Instance {
		/**
		 * The Instance utility
		 * 
		 * @param	x *
		 * @param	... parameters
		 */
		public static function create(x : *, ... parameters : Array) : * {
			var tmp : Array = [x];
			var len : int = parameters.length;
			var i : int;
			for (i = 0;i < len;i++)
				tmp.push(parameters[i]);
			return Type.getInstance.apply(null, tmp);
		}

		/**
		 * @private
		 * Test equalitry between to object.
		 * 
		 * @param o1 * - first object to test.
		 * @param o2 * - second object to test.
		 */
		public static function equals(o1 : Object, o2 : Object) : Boolean {
			return Boolean(o1 == null ? o2 == null : (o1.hasOwnProperty("equals") ? (o1["equals"] as Function).call(o1, o2) : (o1 == o2)));
		}

		/**
		 * 
		 */
		public static function hash(o : Object) : int {
			if (o as int) {
				return int(o);
			} else if (o as uint) {
				return uint(o);
			} else if (o as Number) {
				return Number(o);
			} else if (o.hasOwnProperty("hashCode")) {
				return (o["hashCode"] as Function).call(o);
			} else if (o as Object) {
				try {
					return new Type(o).defaultHashCode;
				} catch(ex : Error) {
					return 0;
				}
			}
			return 0;
		}
	}
}