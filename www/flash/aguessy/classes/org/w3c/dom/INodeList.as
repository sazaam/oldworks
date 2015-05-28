package org.w3c.dom 
{
	import org.w3c.dom.INode;
	/**
	 * ...
	 * @author Biendo Aimé;
	 */
	public interface INodeList 
	{
		//The number of nodes in the list.
		function getLength():int;
		
		//Returns the indexth item in the collection.
		function item(index:int):INode; 
	}
	
}