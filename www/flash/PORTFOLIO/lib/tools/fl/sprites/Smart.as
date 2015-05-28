package tools.fl.sprites 
{
	import flash.display.DisplayObject;
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
				applyProperties() ;
			}
			super() ;
		}
		
		public function applyProperties(props:Object = null):void 
		{
			var p:Object = props || __properties ;
			for (var i:String in p) {
				if (Object(this).hasOwnProperty(i)) {
					this[i] = p[i] ;
				}
			}
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
		public function destroy():void 
		{
			destroyChildren() ;
			properties = destroyProperties() ;
		}
		
		private function destroyProperties():Object 
		{
			for (var p:* in __properties) {
				delete properties[p] ;
			}
			return null ;
		}
		
		private function destroyChildren():void 
		{
			while (numChildren) {
				var child:DisplayObject = removeChildAt(0) ;
				if (child is Smart) {
					Smart(child).destroy() ;
				}
			}
		}
		override public function toString():String { return '[object '+getQualifiedClassName(this) + '] >> name:'+ name}
		
		public function dump():String
		{
			var str:String = 'start dump >> ' + this ;
			for (var i:String in __properties) {
				str += '\n		' + i + '  >>>  ' + String(__properties[i]) ;
			}
			str += '\n end dump'
			return str ;
		}
		
		public function get properties():Object { return __properties }
		public function set properties(value:Object):void { __properties = value }
	}
}