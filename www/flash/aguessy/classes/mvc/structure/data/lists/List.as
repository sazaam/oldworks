package mvc.structure.data.lists 
{
	import flash.utils.Dictionary;
	import mvc.structure.data.I.IItem;
	import mvc.structure.data.I.IListable;
	import mvc.structure.data.items.Item;
	
	/**
	 * ...
	 * @author saz
	 */
	public class List implements IListable
	{
		public var list:Array = [] ;
		public var listD:Dictionary = new Dictionary ;
		public function List() 
		{
			
		}
//////////////////////////////////////////////////////////////////////////////////////ADD & REMOVE
		public function add(_item:Object):IItem
		{
			for each(var i:* in listD) {
					if (listD[i].item == _item) {
						throw(new Error("Already defined such Item in List")) ;
				}
			}
			var item:Item = new Item(_item,"loadz",list.length ) ;
			list.push(IItem(item)) ;
			listD[item] = IItem(item) ;
			return item ;
		}
		
		public function remove(id:Object):IItem
		{
			var item:IItem ;
			
			if (id is int) {
				item = $index(int(id));
			}
			else{
				if (id == null) return null;
				for each(var i:* in listD) {
					//trace(listD[i].item )
					if (listD[i].item == id) {
						item = listD[i] ;
					}else if (id is String) {
						item = $id(String(id)) ;
					}
				}
			}
			if ((!id || item == null ) && !(id is int)) {
				trace("unFound item ...") ;
				return null ;
			}
			//treat & clean array
			clean(item);
			//return the node
			return item ;
		}
		
		private function clean(item):void
		{
			var ind:int = list.indexOf(item) ;
			delete listD[item] ;
			delete list[ind] ;
			list = list.slice(0, ind).concat(list.slice(ind+1, list.length));
		}
		
		public function $id(id:String):*
		{
			var item:IItem ;
			for each(var i:* in listD) {
				if (listD[i].item.id == id) {
					item = listD[i] ;
				}
			}
			return item;
		}
		
		public function $index(id:int):*
		{
			var item:IItem = list[id] ;
			return item ;
		}
//////////////////////////////////////////////////////////////////////////////////////TOSTRING
		public function toString():String {
			return "[List length='"+list.length+"'\n "+list+"\n]" ;
		}
	}
	
}