package tools.fl.sprites 
{
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;

		
	/**
	 * ...
	 * @author saz
	 */
	
	public class Smart extends Sprite
	{
		private var __properties:Object = { } ;
		//////////////////////////////////////////////////////// VARS

		//////////////////////////////////////////////////////// CTOR
		public function Smart(__props:Object = null) 
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
		
		override public function toString():String { return '[object '+getQualifiedClassName(this) + '] >> name:'+ name}
		
		public function get properties():Object { return __properties }
		public function set properties(value:Object):void { __properties = value }
	}
}