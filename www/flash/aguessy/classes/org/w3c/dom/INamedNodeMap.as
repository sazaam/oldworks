package org.w3c.dom
{
	public interface INamedNodeMap
	{
		function getLength():int;
		function getNamedItem(name:String):INode;
		function getNamedItemNS(namespaceURI:String, localName:String):INode;
		function item(index:int):INode;
		function removeNamedItem(name:String):INode;
		function removeNamedItemNS(namespaceURI:String, localName:String):INode;
		function setNamedItem(arg:INode):INode;
		function setNamedItemNS(arg:INode):INode; 	
	}
}