package org.w3c.dom 
{
	import org.w3c.dom.INamedNodeMap;
	import org.w3c.dom.INode;
	/**
	 * ...
	 * @author Biendo Aimé
	 */
	public interface IDocumentType extends INode
	{
		//A INamedNodeMap containing the general entities, both external and internal, declared in the DTD.
		function getEntities():INamedNodeMap;
		
		//The internal subset as a string, or null if there is none.
		function getInternalSubset():String;
		
		//The name of DTD; i.e., the name immediately following the DOCTYPE keyword.
		function getName():String;
		
		//A INamedNodeMap containing the notations declared in the DTD.
		function getNotations():INamedNodeMap;
		
		//The public identifier of the external subset.
		function getPublicId():String;
		
		//The system identifier of the external subset.
		function getSystemId():String;
	}
	
}