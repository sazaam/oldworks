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
	
	public class Copy {
		/**
		 * The Copy utility
		 * 
		 * @param  instance Object -
		 * @return * -   
		 * @throws  CloneNotSupportedException - 
		 * 
		 * @author abiendo@gmail.com
		 */
		public static function create(x : Object, ... parameters : Array) : * {
			if (canCopy(x)) {
				// create a "new" object or array depending on the type of obj  
				var tmp : Array = [x];
				var copy : * = Instance.create.apply(null, tmp.concat(parameters));   
				var i : *;
				// loop over all of the value in the object or the array to copy them  
				for(i in x) {  
					// assign a temporarity value for the data inside the object  
					var item : * = x[i];  
					var flag : Boolean = canCopy(item);
					// check to see if the data is complex or primitive  
					switch(flag) {  
						case true:  
							// if the data inside of the complex type is still complex, we need to  
							// break that down further, so call copyObject again on that complex  
							// item  
							copy[i] = create(item);  
							break;  
						default:  
							// the data inside is primitive, so just copy it (this is a value copy)
							copy[i] = item;
							break;
					}  
				}  
				return copy;
			}
			return null;
		}

		public static function canCopy(o : *) : Boolean {
			return Boolean(Type.isObjectObject(o) || Type.isArray(o) || Type.isDictionary(o));
		}
	}
}