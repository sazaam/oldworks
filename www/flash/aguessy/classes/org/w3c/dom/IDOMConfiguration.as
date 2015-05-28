package org.w3c.dom 
{
	
	/**
	 * ...
	 * @author Biendo Aimé
	 */

	/**
	 * The following list of parameters defined in the DOM: 
	 * 
	 * 		"canonical-form" true / false
	 * 
	 * 		"cdata-sections" true / false
	 * 
	 * 		"check-character-normalization" true / false
	 * 
	 * 		"comments" true / false
	 * 
	 * 		"datatype-normalization" true / false
	 * 
	 * 		"element-content-whitespace" true / false
	 * 
	 * 		"entities" true /false
	 * 
	 * 		"error-handler" true / false
	 * 
	 * 		"infoset" true / false
	 * 
	 * 		"namespaces" true / false
	 * 
	 * 		"namespace-declarations" true / false
	 * 
	 * 		"normalize-characters" true / false
	 * 
	 * 		"schema-location" null
	 * 
	 * 		"schema-type" null
	 * 
	 * 		"split-cdata-sections" true / false
	 * 
	 * 		"validate" true / false
	 * 
	 * 		"validate-if-schema" true / false
	 * 
	 * 		"well-formed" true / false
	 */

	public interface IDOMConfiguration 
	{
		//Check if setting a parameter to a specific value is supported.
		function canSetParameter(name:String, value:Object):Boolean;
		
		//Return the value of a parameter if known.
		function getParameter(name:String):Object;
		
		//The list of the parameters supported by this DOMConfiguration object and for which at least one value can be set by the application
		function getParameterNames():IDOMStringList;
		
		// Set the value of a parameter.
		function setParameter(name:String, value:Object):void; 
	}
	
}