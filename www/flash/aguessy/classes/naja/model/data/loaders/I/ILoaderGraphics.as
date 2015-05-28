package naja.model.data.loaders.I 
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public interface ILoaderGraphics 
	{
		////////////////////////////////////////////////////////////// LAUNCH & KILL
		function start():void 
		function kill():void 
		/////////////////////////////////////////////////// IMG
		function loadIMG():void ;
		function onIMGProgress(e:ProgressEvent):void ;
		function onIMGComplete(e:Event):void ;
		/////////////////////////////////////////////////// FONTS
		function loadFonts():void ;
		function onFontsProgress(e:ProgressEvent):void ;
		function onFontsComplete(e:Event):void ;
		/////////////////////////////////////////////////// SWF
		function loadSWF():void ;
		function onSWFProgress(e:ProgressEvent):void ;
		function onSWFComplete(e:Event):void ;
		/////////////////////////////////////////////////// XML
		function loadXML():void ;
		function onXMLProgress(e:ProgressEvent):void ;
		function onXMLComplete(e:Event):void ;
	}
}