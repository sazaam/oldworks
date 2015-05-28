package naja.model.data.loaders 
{
	import asSist.$;
	import flash.display.DisplayObjectContainer;
	import naja.model.data.loaders.I.ILoaderGraphics;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	/**
	 * ...
	 * @author saz
	 */
	public class LoaderGraphics implements ILoaderGraphics
	{
		public function LoaderGraphics(_tg:DisplayObjectContainer) 
		{
			//
		}
//////////////////////////////////////////////////////////////////////////GRAFIX
		public function start():void 
		{
			//
		}
		public function kill():void 
		{
			//
		}
/////////////////////////////////////////////////////////////////////////////STEPS
////////////////////////////////////////////////////////////////////////////////////////////////////MAIN
		public function loadMain():void
		{
			//
		}
		public function onMainProgress(e:ProgressEvent):void 
		{
			//
		}
		public function onMainComplete(e:Event):void 
		{
			//
		}
////////////////////////////////////////////////////////////////////////////////////////////////////IMG
		public function loadIMG():void
		{
			//
		}
		public function onIMGProgress(e:ProgressEvent):void 
		{
			//
		}
		public function onIMGComplete(e:Event):void 
		{
			//
		}
////////////////////////////////////////////////////////////////////////////////////////////////////FONTS
		public function loadFonts():void
		{
			//
		}
		public function onFontsComplete(e:Event):void 
		{
			//
		}
		public function onFontsProgress(e:ProgressEvent):void 
		{
			//
		}
////////////////////////////////////////////////////////////////////////////////////////////////////SWF
		public function loadSWF():void
		{
			//
		}
		public function onSWFComplete(e:Event):void 
		{
			//
		}
		public function onSWFProgress(e:ProgressEvent):void 
		{
			//var percent:Number = Percent.percent(e.bytesLoaded, e.bytesTotal, {start:(target.stage.stageWidth >> 1) - (150 >> 1), end:(target.stage.stageWidth >> 1) + (150 >> 1) } ) ;
			//indicatePercent(percent) ;
		}
////////////////////////////////////////////////////////////////////////////////////////////////////XML
		public function loadXML():void
		{
			//
		}
		public function onXMLComplete(e:Event):void 
		{
			//
		}
		public function onXMLProgress(e:ProgressEvent):void 
		{
			//
		}
	}
	
}