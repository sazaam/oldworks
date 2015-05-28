package saz.helpers.math 
{
	
	import flash.errors.IllegalOperationError;
	
	
	public class Random {

		public function Random() {
			throw new IllegalOperationError("Illegal instantiation: Random.");
		}

		// just alias
		public static function random():Number {
			return Math.random();
		}

		public static function randomPair():Array {
			return [random(), random()];
		}

		public static function uniform():Number {
			return 2.0 * Math.random() - 1.0;
		}

		public static function uniformPair():Array {
			return [uniform(), uniform()];
		}


		public static function gaussian():Number {
			return gaussianPair()[0];
		}

		public static function gaussianPair():Array {
			var x1:Number, x2:Number, w:Number;

			do {
			x1 = uniform();
			x2 = uniform();
			w = x1 * x1 + x2 * x2;
			} while (w >= 1.0)

			w = Math.sqrt(-2.0 * Math.log(w) / w);

			return [x1 * w, x2 * w];
		}


		public static function spherical():Array {
			var theta:Number = 2.0 * Math.PI * Math.random();
			var z:Number = uniform();

			var c:Number = Math.sqrt(1 - z * z);

			var x:Number = c * Math.cos(theta);
			var y:Number = c * Math.sin(theta);

			return [x, y, z];
		}
	}
}
