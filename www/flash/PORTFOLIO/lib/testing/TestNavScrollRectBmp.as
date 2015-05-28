package testing 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import of.app.required.commands.Command;
	import of.app.required.steps.VirtualSteps;
	import tools.fl.sprites.Smart;
	import tools.grafix.Draw;
	/**
	 * ...
	 * @author saz
	 */
	public class TestNavScrollRectBmp 
	{
		private var img:Array = ['./works/studies/1ksable/1kcourt.jpg', './works/studies/1ksable/1knature.jpg', './works/studies/1ksable/1kmemories.jpg', './works/studies/1ksable/1ktexture.jpg', './works/studies/1ksable/1khome.jpg'] ;
		private var __target:Sprite;
		private var __images:Vector.<BitmapData>;
		private var __urls:Vector.<String>;
		private var __urls:Vector.<String>;
		private var __w:int ;
		private var __h:int ;
		private var navSteps:VirtualSteps;
		private var __smarts:Vector.<Smart>;
		private var __thumbSize:int;
		private var __smartPanel:Smart;
		private var __work:BitmapData;
		private var __displayBitmap:Bitmap;
		
		public function TestNavScrollRectBmp(tg:Sprite)
		{
			__target  = tg ;
			init() ;
		}
		private function presets():void 
		{
			__w = 500 ;
			__h = 400 ;
			__images = new Vector.<BitmapData>() ;
			__urls = new Vector.<String>() ;
			var l:int = img.length ;
			for (var i:int  =  0 ; i < l ; i++ ) {
				__images[__images.length] = new BitmapData(__w, __h, false, 0xFF6600) ;
				__urls[__urls.length] = img[i] ;
			}
			
		}
		private function init():void 
		{
			presets() ;
			initSteps() ;
			initDisplay() ;
		}
		
		private function initDisplay():void 
		{
			//__thumbSize = 100 ;
			
			//__smartPanel = new Smart( { name:'smartPanel', x:200, y:150 } ) ;
			//
			//__smartPanel.properties.initialize = function():void {
				//Draw.draw('rect', { g:__smartPanel.graphics, color:0xD40000, alpha:1 }, 0, 0, __w, __h) ;
				//__work = new BitmapData(__w, __h, false, 0xCCCCCC) ;
				//__displayBitmap = new Bitmap(__work, 'auto', true) ;
				//__smartPanel.addChild(__displayBitmap) ;
				//
				//
				//this.draw = function(n:int):void {
					//
				//}
				//
			//}
			//__target.addChild(__smartPanel) ;
			//__smartPanel.properties.initialize() ;
			
			//__smarts = new Vector.<Smart>() ;
			//var l:int = img.length ;
			//for (var i:int  =  0 ; i < l ; i++ ) {
				//var sm:Smart = new Smart( { name:'smart_'+i, x:150 + i*__thumbSize} ) ;
			//}
		}
		
		private function initSteps():void 
		{
			//navSteps = new VirtualSteps('NAVSYSTEM').setUnique() ;
			//var l:int = img.length ;
			//for (var i:int  =  0 ; i < l ; i++ ) {
				//var st:VirtualSteps = new VirtualSteps(String(i+1), new Command(this, onStep, true), new Command(this, onStep, false)) ;
				//navSteps.add(st) ;
			//}
		}
		
		private function onStep(cond:Boolean = true):void 
		{
			
		}
		
	}

}