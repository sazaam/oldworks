package mvc.structure.data.I 
{
	import mvc.structure.data.items.Item;
	
	/**
	 * ...
	 * @author saz
	 */
	public interface IListable
	{
		function add(_item:Object):IItem
		function remove(_id:Object):IItem
	}
	
}