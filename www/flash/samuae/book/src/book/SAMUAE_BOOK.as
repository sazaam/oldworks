package book 
{
	/**
	 * ...
	 * @author saz
	 */
	public class SAMUAE_BOOK 
	{
		//////////////////////////// VARS
		private var __root:Main ;
		
		//////////////////////////// CTOR
		function SAMUAE_BOOK(root:Main) 
		{
			__root = root ;
			trace(this, '>>', __root) ;
			
			// SETTING STRING SUCH AS REQUESTED SECTIONS FROM URL
			var ex:String = '/#/HOME/NEWS_AND_PRESS/2010/ARTICLE_8/' ;
			var neo:String = '/#/HOME/NEWS_AND_PRESS/2009/' ;
			
			// COMPARING THE TWO AND SLICING WHAT NEEDS IN A RESULTING HYBRID ARRAY/OBJECT
			var compareResult:Array = compareURLs(neo, ex) ;
			
			// DID IT WORKED ???
			trace(compareResult.ex, '\n	depth >>' , compareResult.ex.length - Array.length) ;
			trace(compareResult.neo, '\n	depth >>' , compareResult.neo.length - Array.length) ;
			trace(compareResult) ;
			trace('>>>',compareResult.extraSections) ;
			
		}
		
		private function compareURLs(neo:String, ex:String):Array
		{
			var sliceBySlash:RegExp = /[^\/]*[^\/]/g ;
			var exArr:Array = ex.match(sliceBySlash) ;
			var neoArr:Array = neo.match(sliceBySlash) ;
			
			var compared:Array = compareArrays(neoArr, exArr) ;
			compared.ex = exArr ;
			compared.neo = neoArr ;
			
			return compared ;
		}
		
		private function compareArrays(neo:Array, ex:Array):Array 
		{
			var s:Array = [neo, ex].sortOn('length', Array.DESCENDING) ;
			var resultArr:Array = [], longest:Array = s[0], shortest:Array = s[1], l:int = longest.length ;
			
			for (var i:int = 0 ; i < l ; i++ )
				resultArr.push(!Boolean(shortest[i]) || longest[i] != shortest[i]? 'kill' : ex[i]) ;
			
			var ind:int = resultArr.extraIndex = resultArr.indexOf('kill') ;
			resultArr.extraSections = neo.slice(ind, neo.length) ;
			
			return resultArr ;
		}
		///////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get root():Main { return __root }
	}
}