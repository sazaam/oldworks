package naja.model.data.loadings
{
	import flash.utils.Dictionary;
	import naja.tools.lists.Gates;
	
	/**
	 * ...
	 * @author saz
	 */
	public class LoadedData 
	{
		static private var __list:Dictionary = $Dict() ;
		
		static public function dump(stock:Dictionary):void
		{
			for (var key:String in stock)
			{
				trace(key, stock[key]) ;
			}
		}
		
		static public function insert(stock:String,key:*,value:*):void
		{
			if (!__list[stock]) {
				__list[stock] = $Dict() ;
			}
			__list[stock][key] = value ;
		}
		static public function remove(stock:String,key:*):void
		{
			if (key in __list[stock]) {
				delete __list[stock][key] ;
			}
			else trace("couldn't found what asked to remove... LoadedData") ;
		}
		
		static public function retrieve(stock:String,key:*):*
		{
			if (key in __list[stock]) {
				return __list[stock][key] ;
			}else
			return Gates.getKeyFromObject(__list[stock],key) 
		}
		static public function empty(stock:String = null):Dictionary
		{
			return (!stock)? clean(__list) : clean(__list[stock]) ;
		}
		
		static public function clean(l:*):Dictionary
		{
			var d:Dictionary = $Dict() ;
			for (var key:String in l)
			{
				d[key] = l[key] ;
				delete l[key] ;
			}
			return d ;
		}
		
		static private function $Dict():Dictionary
		{
			return new Dictionary() ;
		}
		
		static public function get list():Dictionary { return __list }
	}
}