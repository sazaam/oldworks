package mvc.structure.data.items 
{
	import mvc.structure.data.I.IItem;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Item implements IItem
	{
		public var item:Object;
		public var ref:String;
		public var index:int;
		
		public function Item(_node:Object,familyName:String = "item",_index:int = 0) 
		{
			item = _node ;
			index = _index ;
			ref = familyName + '_' + index ;
		}
		public function get type():String
		{
			return "Object" ;
		}
//////////////////////////////////////////////////////////////////////////////////////TOSTRING
		public function toString():String {
			return "[Item type='"+type+"' ref='" + ref + "']" ;
		}
	}
	
}