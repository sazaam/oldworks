package testing 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import tools.geom.RatioPreserver;
	
	/**
	 * ...
	 * @author saz
	 */
	public class TestFullScreenResize extends Sprite 
	{
		private var __background:Sprite;
		private var __bmp:Bitmap;
		
		public function TestFullScreenResize() 
		{
			prepare() ;
			init() ;
		}
		
		private function prepare():void 
		{
			stage.align = 'TL' ;
			stage.scaleMode = 'noScale' ;
			
			__background = new Sprite() ; 
			addChild(__background) ;
			stage.addEventListener(Event.RESIZE, onBackgroundResize ) ;
			//stage.dispatchEvent(new Event(Event.RESIZE)) ;
		}
		
		private function onBackgroundResize(e:Event):void 
		{
			drawBackground() ;
		}
		
		
		
		////////////////////////////////// BACKGROUND
		private function drawBackground():void 
		{
			scaleBitmap( stage.stageWidth, stage.stageHeight) ;
		}
		private function scaleBitmap(w:int,h:int):void
		{
			if (!__bmp.smoothing) __bmp.smoothing = true ;
			var coords:Rectangle = getCoords(__bmp.bitmapData, w, h) ;
			__bmp.x = coords.x ;
			__bmp.y = coords.y ;
			__bmp.width = coords.width ;
			__bmp.height = coords.height ;
		}
		private function getCoords(bmpd:BitmapData,w:int,h:int):Rectangle
		{
			var s:Rectangle = RatioPreserver.preserveRatio(new Rectangle(0,0,bmpd.width, bmpd.height), new Rectangle(0, 0, w, h),true) ;
			return s ;
		}
		
		
		
		
		
		
		
		
		private function init():void 
		{
			load() ;
		}
		
		private function load():void 
		{
			var loader:Loader = new Loader() ;
			loader.addEventListener(Event.OPEN, onLoadOpen) ;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete) ;
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress) ;
			
			loader.dispatchEvent(new Event(Event.OPEN)) ;
			
			loader.load(new URLRequest('../img/metal.jpg')) ;
		}

		
		private function onLoadOpen(e:Event):void 
		{
			trace('loadings Start') ;
		}
		
		private function onLoadComplete(e:Event):void 
		{
			__bmp = e.target.content ;
			trace('>>>', __bmp) ;
			resume() ;
		}
		private function onLoadProgress(e:ProgressEvent):void 
		{
			trace('Progress >>>' , e.bytesLoaded/e.bytesTotal) ;
		}
		
		
		private function resume():void 
		{
			stage.dispatchEvent(new Event(Event.RESIZE)) ;
		}
	}
}