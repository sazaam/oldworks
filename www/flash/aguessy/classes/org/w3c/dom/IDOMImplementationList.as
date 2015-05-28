package org.w3c.dom 
{
	import org.w3c.dom.IDOMImplementation;
	/**
	 * ...
	 * @author Biendo Aimé
	 */
	public interface IDOMImplementationList 
	{
		//The number of DOMImplementations in the list.
		function getLength():int;
		
		//Returns the indexth item in the collection.
		function item(index:int):IDOMImplementation; 
	}
	
}