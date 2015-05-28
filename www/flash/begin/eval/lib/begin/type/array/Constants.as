package begin.type.array {
	import begin.type.Constant;

	/**
	 * @author aime
	 */
	dynamic public class Constants extends Array {
		public function Constants(... constants : Array) {
			var constant : Constant;
			var len : int = constants.length;
			while(len--) {
				constant = Constant(constants[len]);
				this[len] = constant;
			}			
		}
		
		public function getConstant(name : String) : Constant {
			var constant : Constant;
			var len : int = length;
			while(len--) {
				constant = Constant(this[len]);
				if (constant.name == name)
					return constant;
			}
			return null;			 
		}
	}
}
