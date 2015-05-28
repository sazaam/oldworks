package org.w3c.dom 
{
	import org.w3c.dom.INode;
	
	/**
	 * ...
	 * @author Bindo Aimé
	 */
	public interface IDocument extends INode
	{
		//Attempts to adopt a node from another document to this document.
		function adoptNode(source:INode):INode;
		
		//Creates an Attr of the given name.
		function createAttribute(name:String):IAttr;
		
		// Creates an attribute of the given qualified name and namespace URI.
		function createAttributeNS(namespaceURI:String, qualifiedName:String):IAttr;
		
		//Creates a CDATASection node whose value is the specified string.
		function createCDATASection(data:String):ICdataSection;
		
		// Creates a Comment node given the specified string.
		function createComment(data:String):IComment;
		
		//Creates an empty DocumentFragment object.
		function createDocumentFragment():IDocumentFragment;
		
		//Creates an element of the type specified.
		function createElement(tagName:String):IElement;
		
		// Creates an element of the given qualified name and namespace URI.
		function createElementNS(namespaceURI:String, qualifiedName:String):IElement; 
		
		// Creates an EntityReference object.
		function createEntityReference(name:String):IEntityReference;
		
		//Creates a ProcessingInstruction node given the specified name and data strings.
		function createProcessingInstruction(target:String, data:String):IProcessingInstruction;
		
		//Creates a Text node given the specified string.
		function createTextNode(data:String):IText;
		
		//The Document Type Declaration (see DocumentType) associated with this document.
		function getDoctype():IDocumentType;
		
		//This is a convenience attribute that allows direct access to the child node that is the document element of the document.
		function getDocumentElement():IElement;
		
		//The location of the document or null if undefined or if the Document was created using DOMImplementation.createDocument.
		function getDocumentURI():String;
		
		//The configuration used when Document.normalizeDocument() is invoked.
		function getDomConfig():IDOMConfiguration;
		
		//Returns the Element that has an ID attribute with the given value.
		function getElementById(elementId:String):IElement; 
		
		//Returns a NodeList of all the Elements in document order with a given tag name and are contained in the document.
		function getElementsByTagName(tagname:String):INodeList;
		
		//Returns a NodeList of all the Elements with a given local name and namespace URI in document order.
		function getElementsByTagNameNS(namespaceURI:String, localName:String):INodeList; 
		
		//The DOMImplementation object that handles this document.
		function getImplementation():IDOMImplementation;
		
		//An attribute specifying the encoding used for this document at the time of the parsing.
		function getInputEncoding():String;
		
		//An attribute specifying whether error checking is enforced or not.
		function getStrictErrorChecking():Boolean;
		
		//An attribute specifying, as part of the XML declaration, the encoding of this document.
		function getXmlEncoding():String;
		
		//An attribute specifying, as part of the XML declaration, whether this document is standalone.
		function getXmlStandalone():Boolean;
		
		// An attribute specifying, as part of the XML declaration, the version number of this document.
		function getXmlVersion():String;
		
		//Imports a node from another document to this document, without altering or removing the source node from the original document; 
		//this method creates a new copy of the source node.
		function importNode(importedNode:INode, deep:Boolean):INode;

		//Rename an existing node of type ELEMENT_NODE or ATTRIBUTE_NODE.
		function renameNode(node:INode, namespaceURI:String, qualifiedName:String):INode;
		
		//The location of the document or null if undefined or if the Document was created using IDOMImplementation.createDocument.
		function setDocumentURI(documentURI:String):void; 
		
		//An attribute specifying whether error checking is enforced or not.
		function setStrictErrorChecking(strictErrorChecking:Boolean):void;
		
		function setXmlStandalone(xmlStandalone:Boolean):void; 
		
		function setXmlVersion(xmlVersion:String):void; 
	}
	
}