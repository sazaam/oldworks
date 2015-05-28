package naja.model.data.loaders.I 
{
	import mvc.structure.data.I.IItem;
	import naja.model.data.loaders.MultiLoader;
	
	/**
	 * ...
	 * @author saz
	 */
	public interface IXLoader 
	{
		function add(_item:Object):* ;
		function remove(_id:Object):* ;
		function loadAll():void ;
		function clearSpecialEvents():void ;
		function get loader():MultiLoader ;
	}
	
}