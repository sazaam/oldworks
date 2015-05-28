package testing 
{
	///////////////////// TEST FROLOADER + LOAD FX
	//import flash.display.Bitmap;
	//import flash.display.DisplayObject;
	//import flash.display.Graphics;
	//import flash.display.Loader;
	//import flash.display.Sprite;
	//import flash.events.Event;
	//import flash.events.ProgressEvent;
	//import flash.geom.Point;
	//import flash.geom.Rectangle;
	//import flash.net.URLRequest;
	//import flash.utils.setTimeout;
	//import tools.fl.sprites.Smart;
	
	
	///////////////////// TEST CHARTS
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;

	
	/**
	 * ...
	 * @author saz
	 */
	
	[SWF(backgroundColor='0x1d1d1d')]
	public class AllTests extends Sprite
	{
		
		///////////////////// TEST FROLOADER + LOAD FX
		//private static const URLANNEXES:String = './annexes.swf' ;
		//private static const URL:String = '../img/works/fond_7.png' ;
		//private static const DIMS:Rectangle = new Rectangle(0,0,550, 200) ;
		//private static const POSITION:Point = new Point(200, 200) ;
		//
		//private static var FroLoadingClass:Class ;
		//private static var FXLoadingClass:Class ;
		
		
		///////////////////// TEST CHARTS
		//private var charts:TestCharts;
		
		
		public function AllTests() 
		{
			
			addEventListener(Event.ADDED_TO_STAGE, init) ;
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.scaleMode = 'noScale' ;
			stage.align = 'TL' ;
			___setup() ;
		}
		///////////////////// TEST CHARTS
		//private function ___setup():void 
		//{
			//var g:Graphics = graphics ;
			//g.beginFill(0, .3) ;
			//g.drawRect(0, 0, 500, 500) ;
			//g.endFill() ;
			//charts = new TestCharts(this) ;
		//}
		
		private function ___setup():void 
		{
			//new TextFX(this) ;
			
			//var test:TestFroTriangleNav = new TestFroTriangleNav(this) ;
			
			//var test:TestBitmapPerfectReflect = new TestBitmapPerfectReflect(this) ;
			
			//var test:TestIsoPyramid3D = new TestIsoPyramid3D() ;
			
			//var testSMTP:TestMail = new TestMail(this) ;
			//testSMTP.init() ;
			
			//var testNav:TestNavScrollRectBmp = new TestNavScrollRectBmp(this) ;
			
			
			var testNav:TestNavFro3D = new TestNavFro3D(7) ;
			addChild(testNav) ;
			
			testNav.select(3) ;
			
			//addChild(new TestManga()) ;
		}
		
		///////////////////// TEST FROLOADER + LOAD FX
		//private function ___setup():void 
		//{
			//var loader:Loader = new Loader() ;
			//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, ___onSetupComplete) ;
			//loader.load(new URLRequest(URLANNEXES)) ;
		//}
		//private function ___onSetupComplete(e:Event):void 
		//{
			//
			//e.target.removeEventListener(e.type, arguments.callee) ;
			//var loader:Loader = e.target.loader ;
			//var content:Sprite = Sprite(loader.content) ;
			// settings
			//FroLoadingClass = content.loaderInfo.applicationDomain.getDefinition('pro.exec.external::FroLoader') ;
			//FXLoadingClass = content.loaderInfo.applicationDomain.getDefinition('pro.exec.external::LoadFX') ;
			//loader.unload() ;
			//loader.unloadAndStop(true) ;
			//loader = content = null ;
			//
			// launch
			//___launch() ;
		//}
		//private function ___launch():void 
		//{
			//start() ;
		//}
		//
		//
		//
		//
		//private function start():void 
		//{
			//var smart:Smart = initSmart() ;
			//initLoad(smart) ;
		//}
		//
		//private function initSmart():Smart
		//{
			//var smart:Smart = new Smart() ;
			//var g:Graphics  = smart.graphics;
			//g.beginFill(0x0, 0) ;
			//g.drawRect(0,0, 550, 200) ;
			//g.endFill() ;
			//
			//smart.x = POSITION.x ;
			//smart.y = POSITION.y ;
			//
			//return Smart(addChild(smart));
		//}
		//
		//private function initLoad(smart:Smart):void 
		//{
			//trace(smart)
			//var w:int = smart.width ;
			//var h:int = smart.height ;
			//var itemW:int = 10 ;
			//var itemH:int = 1 ;
			//var loader:Loader = smart.properties.loader = new Loader() ;
			//var open:Function = smart.properties.open = function(e:Event):void {
				//trace(FroLoadingClass)
				//FroLoader(dimensions:Rectangle = null, diameter:Number = NaN, itemWidth:Number = NaN, itemHeight:Number = NaN, colorIndex:uint = 0x0, colorMode:String = 'rgb')
				//var loadFro = this.loadFro = new (FroLoadingClass as Class)(smart.getRect(smart), 40, itemW, itemH) ;
				//smart.addChild(loadFro) ;
				//trace('>> open') ;
			//}
			//var progress:Function = smart.properties.progress = function(e:ProgressEvent):void {
				//trace('>>', 100*(e.bytesLoaded / e.bytesTotal), '%') ;
			//}
			//var complete:Function = smart.properties.complete = function(e:Event):void {
				//this.loader.contentLoaderInfo.removeEventListener(Event.OPEN, this.open) ;
				//this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.progress) ;
				//this.loader.contentLoaderInfo.removeEventListener(e.type, arguments.callee) ;
				//this.open = this.progress = this.complete = null ;
				//var response:DisplayObject = DisplayObject(this.loader.content) ;
				//trace('>>>>', response) ;
				//trace('>> events erased') ;
				//trace('>> closed') ;
				//smart.addChild(response) ;
				//loader.unload() ;
				//loader.unloadAndStop(true) ;
				//this.loader = null ;
				//
				//var bmp:Bitmap = Bitmap(response) ;
				//var loadFX = this.loadFX = new (FXLoadingClass as Class)(bmp.bitmapData, smart.getRect(smart)) ;
				//smart.addChild(loadFX) ;
				//loadFX['start']() ;
				//smart.removeChild(this.loadFro) ;
				//response = null ;
				//trace('>> loader cleaned') ;
				//
				//
				//setTimeout(loadFX['kill'], 1500) ;
			//}
			//
			//loader.contentLoaderInfo.addEventListener(Event.OPEN, function(e:Event):void{smart.properties.open(e)}) ;
			//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, function(e:Event):void{smart.properties.progress(e)}) ;
			//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{smart.properties.complete(e)}) ;
			//
			//loader.load(new URLRequest(URL)) ;
		//}
	}
}