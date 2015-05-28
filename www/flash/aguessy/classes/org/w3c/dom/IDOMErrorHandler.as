package org.w3c.dom 
{
	
	/**
	 * ...
	 * @author Biendo Aimé
	 */
	public interface IDOMErrorHandler 
	{
		// This method is called on the error handler when an error occurs.
		function handleError(error:IDOMError):Boolean;
	}
	
}