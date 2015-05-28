package org.w3c.dom
{
	public interface INode
	{
		function ancestor(name:String=null):INode
		function appendChild(node:INode):INode;
		function cloneNode(deep:Boolean):INode;
		function getAttributes():INamedNodeMap;
		function getBaseURI():String;
		function getChildNodes():INodeList;
		function getFirstChild():INode;
		function getIndex():int;
		function getChildIndex(node:INode):int;
		function getLastChild():INode;
		function getLocalName():String;
		function getNamespaceURI():String;
		function getNodeName():String;
		function getNodeType():int;
		function getNodeValue():String;
		function getOwnerDocument():IDocument;
		function getParentNode():INode;
		function getPrefix():String;
		function getPreviousSibling():INode;
		function getNextSibling():INode;
		function getTextContent():String;
		function hasAncestor():Boolean;
		function hasTypicAncestor(name:String):Boolean;
		function hasAttributes():Boolean;
		function hasAttribute(name:String):Boolean;
		function hasComplexNode():Boolean;
		function hasChildNodes():Boolean;
		function hasSingleNode():Boolean;
		function insertAfter(newChild:INode, refChild:INode):INode;
		function insertBefore(newChild:INode, refChild:INode):INode;
		function insertBottom(newChild:INode, refChild:*):INode;
		function insertTop(newChild:INode, refChild:*):INode;
		function isEqualNode(arg:INode):Boolean;
		function normalize():void;
		function removeChild(oldChild:INode):INode;
		function replaceChild(newChild:INode, oldChild:INode):INode;
		function setAttribute(name:String, value:*):void;
		function setChildIndex(node:INode, index:int):void;
		function setNodeValue(nodeValue:String):void;
		function setPrefix(prefix:String):void;
		function setTextContent(textContent:String):void;
		function setCDATAContent(textContent:String):void;
	}
}