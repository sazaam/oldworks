package saz.lists 
{
	import flash.utils.Dictionary;
	import org.libspark.utils.DictionaryUtil;
	
	/**
	 * ...
	 * @author saz
	 */
	dynamic public class Gates extends Dictionary
	{
		private var _numeric:Array
		private var _keys:Array
		private var references:Dictionary;
		
		public function Gates() 
		{
			_numeric = [] ;
			_keys = [] ;
			references = new Dictionary() ;
		}
		///////////////////////////////////////////////////////////////////////// ADDING
		public function add(...o:*):*
		{
			
			if (o.length <1)  throw(new ArgumentError("added Object is null..."))
			else if (o.length == 1) {
				register(Object(o[0])) ;
			}else if(o.length == 2){
				register(o[0], o[1]) ;
			}else {
				trace("BITCH, trying to push...") ;
			}
		}
		
		internal function register(o:Object, ref:* = null):void
		{
			if (ref == null) {
				//	numerical entry
				_numeric.push(o) ;
				register(o, _numeric.length - 1) ;
			}else if (ref is String) {
				//	String reference entry
				this[ref] = o ;
				references[o] = o ;
				_keys.push(o) ;
			}else if (ref is int) {
				//	int reference entry
				this[ref] = o ;
				references[o] = o ;
			}else {
				//	Object reference entry
				this[ref] = o ;
				references[ref] = o ;
				_keys.push(o) ;
			}
		}
		///////////////////////////////////////////////////////////////////////// REMOVING
		public function remove(ref:* = null):*
		{
			if (ref == null) {
				return _numeric.pop() ;
			}
			else {
				var o:Object ;
				
				if(Boolean(this[ref])) 
				{//trace('testing in this')
					o = this[ref] ;
					clean(this, o, ref) ;
					//erase()
				}else
				{//trace('testing in references')
					if(Boolean(references[ref])) 
					{
						o = references[ref] ;
						clean(references, o, ref) ;
						clean(this,o,$ref(this,ref)) ;
					}
				}
				if (_keys.indexOf(o)!=-1) erase(_keys, _keys.indexOf(o)) ;
				if (ref is int) erase (_numeric, ref) ;
				if (_numeric.indexOf(ref) != -1) erase(_numeric, _numeric.indexOf(ref)) ;
				return o ;
			}
		}
		internal function clean(d:Dictionary,o:*,ref:* = null):void
		{
			if (ref!=null) {
				if (Boolean(this[o])) {
					erase(this,o) ;
				}else if(Boolean(this[ref])){
					erase(this,ref) ;
				}else if(Boolean(references[o])){
					erase(references,o) ;
				}else if(Boolean(references[ref])){
					erase(references,ref) ;
				}
			}
			else {
				
			}
		}
		private function erase(el:*,o:*):void
		{
			if (el is Array) {
				el[o] = null ;
				delete el[o] ;
				if (el == _numeric) {
					_numeric = el.slice(0, o).concat(el.slice(o + 1, el.length)) ;
				}else {
					_keys = el.slice(0, o).concat(el.slice(o + 1, el.length)) ;
				}
			}else {
				el[o] = null ;
				delete el[o] ;
			}
		}
		///////////////////////////////////////////////////////////////////////// HELPERS
		static internal function $ref(d:Dictionary,value:*):*
		{
			for (var key:Object in d)
				if (d[key] == value) return key;
		}
		public function getKeyReference(value:*):*
		{
			return $ref(this, value) ;
		}
		static public function getKeyFromDictionary(d:Dictionary,value:*):*
		{
			return $ref(d,value) ;
		}
		///////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get merged():Array { return [].concat(numeric).concat(keys) }
		public function get numeric():Array { return _numeric }
		public function set numeric(value:Array):void 
		{ _numeric = value }
		public function get keys():Array { return _keys }
		public function set keys(value:Array):void 
		{ _keys = value }
		///////////////////////////////////////////////////////////////////////// TO STRING
		public function toString():String {
			var str:String = "" ;
			merged.forEach(function(el, i, arr):void { str+= "\n    " + el + " >> " + i + " >>> " + getKeyReference(el)} ) ;
			return "[ Object Gates ["+str+"\n]]" ;
		}
	}
	
}