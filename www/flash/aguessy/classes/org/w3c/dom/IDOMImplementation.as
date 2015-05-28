package org.w3c.dom
{
	public interface IDOMImplementation
	{
		function createDocument(namespaceURI:String, qualifiedName:String, doctype:IDocumentType):IDocument;
		function createDocumentType(qualifiedName:String, publicId:String, systemId:String):IDocumentType; 
	}
}