package naja.tools.lists 
{
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Compare 
	{
		public static function dump(src:*):void
		{
			for (var key:* in src)
				trace(key + " >> " + src[key]) ; 
		}
		public static function compareArrays(p:Array,v:Array,compareAsObject = false):Boolean
		{
			var k:int = p.length, l:int = v.length;
			if (k != l) return false ;
			if (compareAsObject) return compareObjects(p, v) ;
			while (k--) {
				var i:Object = p[k],j:Object = v[k] ;
				var c:Class = Object(i).constructor ;
				var c2:Class= Object(j).constructor ;
				if ( c != c2 ) return false ;
				if ( i != j ) return false ;
			}
			return true ;
		}
		///////////////////////////////////////////////////////////////////////////////// COMPAREOBJECT & DICTIONARIES
		/**
		 * Compares two Objects in order to assume their 'equality'.
		 * 
		 * @param x Object - First Object to compare
		 * @param y Object - Second Object to compare
		 * @return Boolean - the result of the check, if true, Objects are equal.
		 */	
		public static function compareObjects(x:Object, y:Object):Boolean
		{
			return checkProperties(x, y) && checkProperties(y, x);
		}
		public static function compareDictionaries(x:Dictionary, y:Dictionary):Boolean
		{
			return compareObjects(x, y) ;
		}
		///////////////////////////////////////////////////////////////////////////////// CHECKPROPERTIES
		/**
		 * Checks two Objects's properties in order of assuming the second object passed has, at least 
		 * the same properties than the first one.
		 * 
		 * @param x XData - Object to compare (the original),
		 * @param y XData - Object to be compared to
		 * @return Boolean - the result of the check, if true, XData objects are equal.
		 */	
		public static function checkProperties(x:Object, y:Object):Boolean
		{
			for (var p:* in x) {
				if (y.hasOwnProperty(p)) {
					if (y[p] != x[p]) {
						return false;
					}
				}else if(x.hasOwnProperty(p)){
					return false ;
				}
			}
			return true;
		}
		///////////////////////////////////////////////////////////////////////////////// COPYOBJECT
		/**
		 * Copies an Object
		 * 
		 * @param src Object - the Object to copy
		 * @return Object - the resulting Object
		 */	
		public static function copyObject(src:Object):Object
		{
			var d:Object = (src is Dictionary)? new Dictionary() : {};
			var k:*;
			for (k in src)
				d[k] = src[k];
			return d;
		}
		///////////////////////////////////////////////////////////////////////////////// COPYARRAY
		/**
		 * Copies an Array
		 * 
		 * @param source Array - the Array to copy
		 * @return Array - the resulting Array
		 */	
		public static function copyArray(src:Array):Array
		{
			return src.concat() ;
		}
		///////////////////////////////////////////////////////////////////////////////// COPYDICT
		/**
		 * Copies a Dictionary
		 * 
		 * @param source Dictionary - the Dictionary to copy
		 * @return Object - the resulting Dictionary
		 */	
		public static function copyDict(src:Dictionary):Dictionary
		{
			return Dictionary(copyObject(src));
		}
	}
}