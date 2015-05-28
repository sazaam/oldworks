package org.w3c.dom 
{
	import org.w3c.dom.INode;
	/**
	 * ...
	 * @author Biendo Aimé
	 */
	public interface ICharacterData extends INode
	{
		function appendData(arg:String):void;
		function deleteData(offset:int, count:int):void;
		function getData():String;
		function getLength():int;
		function insertData(offset:int, arg:String):void;
		function replaceData(offset:int, count:int, arg:String):void;
		function setData(data:String):void;
		function substringData(offset:int, count:int):String;
		function regExp(reg:RegExp):String;
	}
	
}