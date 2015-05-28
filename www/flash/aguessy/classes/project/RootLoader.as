package project 
{
	import f6.helpers.essentials.collections.SpriteCollection; SpriteCollection;
	import flash.events.ProgressEvent;
	import flash.text.Font;
	import flash.text.TextFormat;
	import saz.helpers.shapes.Circle; Circle;
	
	
	import flash.display.Loader;
	import flash.display.Sprite ;
	import asSist.* ;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import frocessing.core.F5Graphics3D;
	import frocessing.display.F5MovieClip3D;

	
	
	
	/**
	 * ...
	 * @author saz
	 */
	public class RootLoader extends Sprite
	{
		
		public function RootLoader() 
		{
			$(stage).attr( { scaleMode: "noScale", align: "TL" } ).bind(MouseEvent.CLICK, clickHandler) ;
			$(Loader).each(function(i:int, el:Loader) {
				$(el.contentLoaderInfo).bind(ProgressEvent.PROGRESS, onProgress).bind(Event.COMPLETE, onLoadComplete).bind(IOErrorEvent.IO_ERROR,onLoadError) ;
			})[0].load(new URLRequest("./main.swf"))  ;
			$(Sprite).attr( { id:"load" } ).each(function(i:int, el:Sprite) {
				addChild(el) ;
			} )
		}
		
		private function onProgress(e:ProgressEvent):void
		{
			var percent:Number = e.bytesLoaded / e.bytesTotal;
			var load:Sprite = $("#load")[0] ;
			load.graphics.beginFill(0x004cb0, 1) ;
			
			load.graphics.drawRect(0,299,percent*948,1);
			//trace(e.bytesLoaded)
		}
		
		private function onLoadError(e:IOErrorEvent):void
		{
			trace("YO  :  " + e ) ;
		}
		
		private function onLoadComplete(e:Event):void
		{
			removeChild($("#load")[0]) ;
			addChild(e.target.content) ;
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			
		}
	}
}