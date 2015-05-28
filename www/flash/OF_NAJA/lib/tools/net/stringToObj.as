package tools.net 
{
	/**
	 * ...
	 * @author saz-ornorm
	 */
	public function stringToObj(src:String):Object
	{
		var RE_ALL:RegExp = /.+$/mgi ;
		var RE_OPEN:RegExp = /{( [\w\d]+)?/i ;
		var RE_CLOSE:RegExp = /}/i ;
		
		var obj:Object = { }, par:Object, id:String, values:Array, type:String, arr:Array = src.match(RE_ALL) ;
		var l:int = arr.length ;
		var cur:Object = obj ;
		
		for(var i:int = 0 ; i < l ; i++ ){
			var s:String = arr[i] ;
			if(RE_OPEN.test(s)){
				values = s.split(' ') ;
				type = values[0].replace(/{/,'') ;
				id = values[1] ;
				par = cur ;
				par[id] = cur = type == 'Array'? [] : {} ;
				cur.parent = par ;
			}else if(RE_CLOSE.test(s)){
				par = cur.parent ;
				cur.parent = null ;
				delete cur.parent ;
				cur = par ;
			}else{
				values = s.split(':') ;
				id = values[0] ;
				if(type == 'Array')
					cur[int(id)] = values[1] ;
				else
					cur[id] = values[1] ;
			}
		}
		return obj ;
	}
}