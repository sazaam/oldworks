package begin.type.array {
	import begin.type.Variable;

	/**
	 * @author aime
	 */
	dynamic public class Variables extends Array {
		public function Variables(... variables : Array) {
			var variable : Variable;
			var len : int = variables.length;
			while(len--) {
				variable = Variable(variables[len]);
				this[len] = variable;
			}			
		}
		
		public function getVariable(name : String) : Variable {
			var variable : Variable;
			var len : int = length;
			while(len--) {
				variable = Variable(this[len]);
				if (variable.name == name)
					return variable;
			}
			return null;			 
		}
	}
}
