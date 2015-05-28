package begin.eval.dump {

	public class Util {

		public static function assert(cond : Boolean) : void {
			if (!cond)
	            throw "Assertion failed!";
		}
		
		public static function print(...args : Array):void {
			var s:String = args.join(" - ");
			trace(s);
		}
		
		public static function copyArray(c : Array) : Array {
			var a : Array = new Array;
			for (var i : int = 0 ;i < c.length ;i++ )
	            a[i] = c[i];
			return a;
		}

		public static function forEach(fn : Function, a : Array) : void {
			for ( var i : int = 0 ;i < a.length ;i++ ) {
				if (i in a)
	                fn(a[i]);
			}
		}

		public static function map(fn : Function, a : Array) : Array {
			var b : Array = [];
			for ( var i : int = 0 ;i < a.length ;i++ ) {
				if (i in a)
	                b[i] = fn(a[i]);
			}
			return b;
		}

		public static function memberOf(x : *, ys : Array) : Boolean {
			for ( var i : int = 0 ;i < ys.length ;i++ ) {
				if (ys[i] === x)
	                return true;
			}
			return false;
		}

		public static function toUint(x : *) : uint {
			return uint(x);
		}
	}
}