package arr
{
	import flash.utils.Proxy ;
	import flash.utils.flash_proxy ;
	
	/**
	 * ...
	 * @author saz
	 */
	dynamic public class LimitedArr extends Proxy
	{
		internal var __arr:Array ;
		private var __limit:int;
		private var __startIndex:int;
		public function LimitedArr(_limit:int = -1, _startIndex:int = 0) 
		{
			__startIndex = _startIndex ;
			
			__limit = (_limit != -1)? _limit : 100 ;
			__arr = [] ;
			
			for (var i:int = 0; i < _startIndex ; i++ ) {
				this["push"](new Empty()) ;
			}
		}
		public function translate(dif:int):void
		{
			__arr.unshift.apply(__arr, __arr.splice(dif)) ;
		}
////////////////////////////////////////////////////////////////////////////////FLASH PROXY
		override flash_proxy function getProperty(name:*):* 
		{
			trace("getting prop >>  " + name) ;
			var i:int ;
			if (name is QName) {
				if (int(name) != 0) {
					trace('taputez')
					return  __arr[name] ;
				}else {
					name = name.localName ;
					return  __arr[name] ;
				}
			}else {
				//trace("getting  >>  " + name) ;
				if (name is int) {
					i = int(name) ;
					
					if ( i < __limit) {
						return  __arr[int(name)] ;
					}else {
						trace("Index out of range of Limited Array while setting...") ;
					}
				}else
				return  __arr[name] ;
			}
		}
		override flash_proxy function setProperty(name:*, value:*):void
		{
			var i:int ;
			if (name is QName) {
				if (int(name) != 0) {
					i = int(name) ;
					if ( i < __limit) {
						__arr[i] = value ;
					}else {
						trace("Index out of range of Limited Array") ;
					}
				}else {
					name = name.localName ;
					__arr[name] = value ;
				}
			}else {
				trace("setting prop >>  " + name) ;
				if (name is int) {
					i = int(name) ;
					if ( i < __limit) {
						__arr[i] = value ;
					}else {
						trace("Index out of range of Limited Array") ;
					}
					__arr[name] = value ;
				}
			}
		}
		override flash_proxy function callProperty(name:*, ...rest):*
		{
			trace("calling prop >>  " + name) ;
			return __arr[name].apply(__arr[name],rest) ;
		}
		/////////////////////////////////////////////////////////////////////////TOSTRING
		public function toString():String 
		{
			return __arr.toString() ;
		}
		
		public function get output():Array { return __arr }
		
		public function get startIndex():int { return __startIndex }
	}
	
}