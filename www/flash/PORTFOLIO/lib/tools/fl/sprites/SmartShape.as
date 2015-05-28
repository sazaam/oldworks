package tools.fl.sprites 
{
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class SmartShape extends Shape
	{
		private var __properties:Object = { } ;
		//////////////////////////////////////////////////////// VARS

		//////////////////////////////////////////////////////// CTOR
		public function SmartShape(__props:Object = null) 
		{
			if (__props) {
				merge(__props) ;
			}
			super() ;
		}
		
		private function merge(...restObjects:Array):void
		{
			__properties = Smart.merge.apply(this, [__properties].concat(restObjects)) ;
		}
		
		static public function merge(object:Object, ...restObjects:Array):Object
		{
			var l:int = restObjects.length ;
			for (var i:int = 0 ; i < l ; i++ ) {
				var o:Object = restObjects[i] ;
				for (var s:String in o) {
					object[s] = o[s] ;
				}
			}
			return object ;
		}
		
		public function get properties():Object
		{
			return __properties ;
		}
	}
}