package org.w3c.dom 
{
	import org.w3c.dom.IDOMImplementation;
	import org.w3c.dom.IDOMImplementationList;
	/**
	 * ...
	 * @author Biendo Aimé
	 */
	public interface IDOMImplementationSource 
	{
		//A method to request the first DOM implementation that supports the specified features.
		function getDOMImplementation(features:String):IDOMImplementation;
		
		//A method to request a list of DOM implementations that support the specified features and versions, as specified in.
		function getDOMImplementationList(features:String):IDOMImplementationList;
	}
	
}