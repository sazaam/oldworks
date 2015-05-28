package org.w3c.dom 
{
	
	/**
	 * ...
	 * @author Biendo Aimé
	 */
	public interface IDOMError 
	{
		//The location of the error.
		function getLocation():IDOMLocator;
		
		//An implementation specific string describing the error that occurred.
		function getMessage():String;
		
		//The related DOMError.type dependent data if any.
		function getRelatedData():Object;
		
		//The severity of the error, either SEVERITY_WARNING, SEVERITY_ERROR, or SEVERITY_FATAL_ERROR.
		function getSeverity():String;
		
		//A DOMString indicating which related data is expected in relatedData.
		function getType():String;
	}
	
}