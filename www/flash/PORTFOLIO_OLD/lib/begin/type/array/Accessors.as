package begin.type.array {
	import begin.type.Accessor;

	/**
	 * @author aime
	 */
	dynamic public class Accessors extends Array {
		public function Accessors(... accessors : Array) {
			var accessor : Accessor;
			var len : int = accessors.length;
			while(len--) {
				accessor = Accessor(accessors[len]);
				this[len] = accessor;
			}			
		}
		
		public function getAccessor(name : String) : Accessor {
			var accessor : Accessor;
			var len : int = length;
			while(len--) {
				accessor = Accessor(this[len]);
				if (accessor.name == name)
					return accessor;
			}
			return null;			 
		}
	}
}
