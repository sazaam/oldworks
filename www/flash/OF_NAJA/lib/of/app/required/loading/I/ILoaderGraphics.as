package of.app.required.loading.I 
{
	import flash.events.Event ;
	import flash.events.ProgressEvent ;
	
	public interface ILoaderGraphics 
	{
		////////////////////////////////////////////////////////////// LAUNCH & KILL
		function start(closure:Function, ...args:Array):void 
		function kill(closure:Function, ...args:Array):void 
		/////////////////////////////////////////////////// ALL
		function onALLOpen(e:Event):void ;
		function onALLProgress(e:ProgressEvent):void ;
		function onALLComplete(e:Event):void ;
		/////////////////////////////////////////////////// IMG
		function onIMGOpen(e:Event):void ;
		function onIMGProgress(e:ProgressEvent):void ;
		function onIMGComplete(e:Event):void ;
		/////////////////////////////////////////////////// FONTS
		function onFONTSOpen(e:Event):void ;
		function onFONTSProgress(e:ProgressEvent):void ;
		function onFONTSComplete(e:Event):void ;
		/////////////////////////////////////////////////// SWF
		function onSWFOpen(e:Event):void ;
		function onSWFProgress(e:ProgressEvent):void ;
		function onSWFComplete(e:Event):void ;
		/////////////////////////////////////////////////// XML
		function onXMLOpen(e:Event):void ;
		function onXMLProgress(e:ProgressEvent):void ;
		function onXMLComplete(e:Event):void ;
	}
}