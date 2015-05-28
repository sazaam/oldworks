package naja.model.data.lists 
{
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	/**
	 * ...
	 * @author ...
	 */
	dynamic public class Gathering extends Proxy
	{
		protected var _stock:Dictionary ;
		protected var _list:Array ;
		protected var _dict:Array ;
		protected var count:int ;
///////////////////////////////////////////////////////////////////////////CONSTRUCTOR
		public function Gathering() 
		{
			_stock = new Dictionary() ;
			count = 0 ;
			_list = [] ;
			_dict = [] ;
		}
///////////////////////////////////////////////////////////////////////////FLASH PROXY
		override flash_proxy function getProperty(name:*):* 
		{
			//trace("getting  >>  " + name)
			if (name is QName) {
				name = name.localName ;
				return _stock[name] || _list[name] ;
			}else {
				trace("getting  >>  " + name)
				return !isNaN(name) ? _list[int(name)] : _stock[name] ;
			}
		}
		override flash_proxy function setProperty(name:*, value:*):void
		{
			//trace("setting  >>  " + name)
		}
		override flash_proxy function callProperty(name:*, ...rest):*{
			trace("calling  >>  " + name)
			//return function(name,...rest){_list[name].apply(_list[name],rest) }
			return _list[name].apply(_list[name],rest) ;
		}
		override flash_proxy function nextNameIndex(index:int):int 
		{
			return  index < (length) ? index + 1 : 0;
		}
		override flash_proxy function nextName(index:int):String 
		{
			return String(index-1) ;
		}
		override flash_proxy function nextValue(index:int):* 
		{
			return list[index-1] ;
		}
///////////////////////////////////////////////////////////////////////////ADD
		public function add(_item:*, _ref:* = null):int {
			if(Boolean(_stock[_item])) throw new Error("already registered in here ...Gathering")
			if (_ref) {
				//stock into Dictionary
				_stock[_ref] = _item ;
				count--
				_list[count] = _ref ;
				return _dict.push(_item) ;
			}else {
				//stock into Array
				_stock[_item] = _item ;
				return _list.push(_item) ;
			}
			return null ;
		}
///////////////////////////////////////////////////////////////////////////REMOVE
		public function remove(_ref:Object = null):* {
			var item:* ;
			//trace(_ref)
			if (_ref is int) {
				//trace("Ref is int")
				if(!Boolean(_list[int(_ref)])) throw (new ReferenceError("index is out of bounds!...  Gathering"))
				//talks to the array
				item = _list[_ref] ;
				erase(item) ;
			}else {
				if (_ref == null) {
					//trace("Ref is null") ;
					item = _list.pop() ;
					erase(item) ;
				}else {
					//trace("Ref is a ref") ;
					if (Boolean(_stock[_ref])) {
						//if is originally stocked in Array
						item = _stock[_ref] ;
						for (var i:String in _list) {
							if (item == _stock[_list[i]]) {
								item = _list.splice(int(_ref), int(_ref) + 1)[0] ;
								erase(item, item) ;
							}
						}
					}
					else {
						//if is originally stocked in Dictionary
						for (var j:String in _list) {
							if (_ref == _stock[_list[j]]) {
								item = _stock[_list[j]] ;
								erase(item, j) ;
							}
						}
					}
				}
			}
			return item;
		}
		private function erase(item:Object,_ref:* = null):void
		{
			if (_ref == null) {
				var next:Array = _list.splice(_list.indexOf(item) + 1, _list.length) ;
				_list.pop() ;
				_list.push.apply(_list,next) ;
				_stock[item] = null ;
				delete _stock[item] ;
			}else {
				if (_ref in list) {
					var k:int = _dict.indexOf(item) ;
					_stock[list[_ref]] = null ;
					delete _stock[list[_ref]] ;
					list[_ref] = null ;
					delete list[_ref] ;
					_dict.splice(int(k), int(k) + 1) ;
				}else {
					//trace(_ref)
					_stock[_ref] = null ;
					delete _stock[_ref] ;
					_list[count] = null ;
					delete _list[count] ;
				}
				//this[count] = null ;
				count++ ;
				//reattributeIntRefs() ;
			}
		}
		
		public function getKey(o:*):*{
			//trace(o)
			//trace($ref(_list,o))
			var obj:Object = { } ;
			if ($ref(_dict, o) != -1) obj.index = $ref(_dict, o) ; 
			if ($ref(_list, o) != -1) obj.key = $ref(_list, o) ; //_list[$ref(_list,o)])
			//trace("SALUT "+$ref(_stock,o))
			return obj ;
		}
		
		internal function $ref(d:*,o:*):*
		{
			
			if (d != null) {
				if (d is Dictionary) {
					trace("DICTIONARY ASKED")
					return $keyFromFakeArrValue(d[o]) ;
				}else if (d is Array) {
					if(d.indexOf(o)!=-1)
						return d.indexOf(o)
					else {
						return $keyFromFakeArrValue(o)
					}
				}else if (d is Gathering) {
					trace("GATHERING " + d[o]) ;
					
				}
			}else {
				
			}
		}
		
		private function $keyFromFakeArrValue(o:*):*
		{
			for (var i:int = count; i < 0 ; i++ ) {
				if(_list[i] in _stock && _stock[_list[i]] == o)
				return _list[i] ;
			}
		}
///////////////////////////////////////////////////////////////////////////GETTER & SETTERS
		public function get dict():Array { return _dict }
		public function get stock():Dictionary { return _stock }
		public function get list():Array { return _list }
		public function get length():int { return _list.length }
///////////////////////////////////////////////////////////////////////////TOSTRING
		public function toString():String {
			return "[ Object Gathering ["+_list+"]]" ;
		}
	}
	
}