package naja.model 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import naja.model.control.context.Context;
	import naja.model.control.dialog.ExternalDialoger;
	import naja.model.control.events.EventsRegisterer;
	import naja.model.control.loading.GeneralLoader;
	import naja.model.control.resize.StageResizer;
	import naja.model.Root;
	import naja.model.data.loaders.AllLoader;
	import naja.model.data.loaders.LoadedData;
	import naja.model.steps.E.StepEvent;
	import naja.model.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	public class XModule extends EventDispatcher
	{
		private var __stepsOpen:VirtualSteps;
		private var __context:Context;
		private var __events:EventsRegisterer;
		private var __generalLoader:GeneralLoader;
		private var __dialoger:ExternalDialoger;
		private var __model:XModel;
		private var __resizer:StageResizer;
//////////////////////////////////////////////////////// CTOR
		public function XModule() 
		{
			trace("CTOR > " + this)
			__stepsOpen = Root.user.customizer.gates["open"] ;
		}
		
		public function init(model:XModel):void
		{
			__model = model ;
			__context = new Context() ;
			__generalLoader = new GeneralLoader() ;
			__events = new EventsRegisterer() ;
			__resizer = new StageResizer() ;
			__dialoger = new ExternalDialoger() ;
		}
		
		
///////////////////////////////////////////////////////////////////////////////// LOAD CONFIG
		public function loadConfigXML():void
		{
			__context.displayer.target.addEventListener(Event.COMPLETE, onConfigComplete) ;
			__generalLoader.loader.init(Root.root,null,"configuration") ;
			__generalLoader.loader.add(Root.user.sitePathes["config"], "config") ;
			__generalLoader.loader.add(Root.user.sitePathes["librairies"], "librairies") ;
			__generalLoader.loader.add(Root.user.sitePathes["scripts"], "scripts") ;
			__generalLoader.loader.launch() ;
		}
		
		private function onConfigComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			
			var p:Dictionary = LoadedData.list ;
			__model.config = p["XML"]["config"] ;
			__model.libraries = p["XML"]["librairies"] ;
			__model.scripts = p["XML"]["scripts"] ;
			configure() ;
		}
		
		private function configure():void
		{
			var config:XML = __model.config ;
			var stageXML:XML = config.stage[0] ;
			var schemeXML:XML = config.scheme[0] ;
			var debugXML:XML = config.debug[0] ;
			var tfXML:XML = config.textfields[0] ;
			var defaultAddress:String = config.@defaultAddress.toXMLString() ;
			var links:XML = config.links[0] ;
			__context.initStage(stageXML) ;
			__context.initFrameSet(schemeXML) ;
			__context.initLinks(links) ;
			__context.displayer.debug = __context.displayer.initDebug(debugXML) ;
			__dialoger.jsModule.init(__model.scripts) ;
			__dialoger.swfAddress.debug_tf = __context.displayer.debug ;
			__dialoger.swfAddress.home = defaultAddress ;
			__generalLoader.loader.clean() ;
			__resizer.init(__context.displayer.stage) ;
			
			loadLibs() ;
		}
		
///////////////////////////////////////////////////////////////////////////////// LOAD LIBS
		private function loadLibs():void
		{
			var libraries:XML = __model.libraries ;
			__generalLoader.loader.scheme = libraries ;
			__generalLoader.loader.graphics = __model.user.customizer["loaderGraphics"] ;
			__context.displayer.target.addEventListener(Event.COMPLETE, onLoadsComplete)
			__generalLoader.loader.launch() ;
		}
		
		private function onLoadsComplete(e:Event):void 
		{
			e.target.removeEventListener(e.type, arguments.callee) ;
			var p:Dictionary = LoadedData.list ;
			__model.data.loaded = p ;
			
			
			dispatchConnect() ;
		}
		
///////////////////////////////////////////////////////////////////////////////// CONNECT
		public function dispatchConnect():void
		{
			if (hasEventListener(Event.CONNECT)) dispatchEvent(new Event(Event.CONNECT)) ;
		}
		
///////////////////////////////////////////////////////////////////////////////// OPEN
		public function open():void
		{
			trace("Grand Opening")
			var u:VirtualSteps = __model.user.customizer ;
			var home:String = __dialoger.swfAddress.home ;
			__dialoger.hierarchy.functions = u ;
			u.commandOpen.addEventListener(Event.COMPLETE,onOpen) ;
			__dialoger.hierarchy.functions.play() ;
		}
		
		public function onOpen(e:Event):void 
		{
			__dialoger.initAddress(__dialoger.swfAddress.home) ;
		}
	}
}