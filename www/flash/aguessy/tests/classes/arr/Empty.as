package arr 
{
	
	/**
	 * ...
	 * @author saz
	 */
	public class Empty 
	{
		private static var __count:int = 0 ;
		private const __id:int  = __count ;
		private var __value:* ;
		public function Empty() 
		{
			__count ++ ;
			__value = __id ;
		}
		
		public function toString():String 
		{
			return String(__id) ;
		}
		
		public function get value():* { return __value; }
		public function set value(_value:*):void 
		{
			__value = _value ;
		}
	}
	
}