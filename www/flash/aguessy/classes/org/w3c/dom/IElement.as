package org.w3c.dom 
{
	import org.w3c.dom.INode;
	/**
	 * ...
	 * @author A. Biendo
	 */
	public interface IElement extends INode
	{
		//Retrieves an attribute value by name.
		function getAttribute(name:String):String;
		
		function getAttributeNode(name:String):IAttr; 
	}
	
}