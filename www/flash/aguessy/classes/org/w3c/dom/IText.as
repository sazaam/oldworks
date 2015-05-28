package org.w3c.dom 
{
	
	/**
	 * ...
	 * @author Biendo Aimé
	 */
	public interface IText extends ICharacterData
	{
		function getWholeText():String;
		function isElementContentWhitespace():Boolean;
		function replaceWholeText(content:String):IText;
		function splitText(offset:int):IText;
	}
	
}