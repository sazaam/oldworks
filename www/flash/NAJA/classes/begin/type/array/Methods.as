package begin.type.array {

	import begin.type.Method;
	/**
	 * @author aime
	 */
	dynamic public class Methods extends Array {
		public function Methods(... methods : Array) {
			var method : Method;
			var len : int = methods.length;
			while(len--) {
				method = Method(methods[len]);
				this[len] = method;
			}			
		}
		
		public function getMethod(name : String) : Method {
			var method : Method;
			var len : int = length;
			while(len--) {
				method = Method(this[len]);
				if (method.name == name)
					return method;
			}
			return null;			 
		}
	}
}
