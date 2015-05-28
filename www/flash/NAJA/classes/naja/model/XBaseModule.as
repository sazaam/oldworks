package naja.model 
{
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	import naja.model.control.context.Context;
	import naja.model.control.events.EventsRegisterer;
	import naja.model.control.loading.GraphicalLoader;
	import naja.model.control.dialog.ExternalDialoger;
	import naja.model.control.regexp.BasicRegExp;
	import naja.model.control.resize.StageResizer;
	import naja.model.data.loadings.AllLoader;
	import naja.model.data.loadings.E.LoadEvent;
	import naja.model.data.loadings.LoadedData;
	import naja.model.Root;
	import naja.model.XModel;
	import naja.tools.steps.VirtualSteps;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import naja.tools.zip.ZipEntry;
	import naja.tools.zip.ZipFile;
	import naja.tools.zip.ZipLoader;

	/**
	 * ...
	 * @author saz
	 */
	public class XBaseModule extends EventDispatcher {
		//////////////////////////////////////////////////////// VARS
		static private var __instance:XBaseModule ;
		protected var __registered:Dictionary = new Dictionary();
		protected var __context:Context;
		protected var __events:EventsRegisterer;
		protected var __generalLoader:GraphicalLoader;
		protected var __dialoger:ExternalDialoger;
		protected var __model:XModel;
		protected var __resizer:StageResizer;
		protected var __allLoader:AllLoader;
		
		public function XBaseModule() 
		{
			super() ;
			__instance = this ;
		}
		//////////////////////////////////////////////////////// CTOR
		/**
		 * Inits along XModel, create principal helpers
		 * such as :
		 *  - Context
		 *  - GraphicalLoader
		 *  - EventsRegisterer
		 *  - StageResizer
		 *  - ExternalDialoger
		 * @param model XModel
		 * @return XBaseModule
		 */	
		internal function init(model:XModel):XBaseModule {
			__model = model ;
			__context = Context(register(Context)) ;
			__generalLoader = GraphicalLoader(register(GraphicalLoader,model.user.loaderGraphics)) ;
			__events = EventsRegisterer(register(EventsRegisterer)) ;
			__resizer = StageResizer(register(StageResizer,Root.root.stage)) ;
			__dialoger = ExternalDialoger(register(ExternalDialoger)) ;
			__allLoader = AllLoader(register(AllLoader, Root.root, "configuration")) ;
			return this ;
		}
		///////////////////////////////////////////////////////////////////////////////// LOAD CONFIG
		/**
		 * Loads the Configuration XML directly from Path in SitePathes, in a first Queue.
		 */
		internal function loadBase():void
		{
			var confPath:String = Root.user.fromPath("config") ;
			var isZip:Boolean = AllLoader.testUrl(confPath) == "zip" ;
			var closure:Function = isZip ? onZipConfComplete : onConfComplete ;
			var subPath:String = isZip ? "zip" : "xml" ;
			
			GraphicalLoader.disable() ;
			AllLoader.addEventListener(Event.COMPLETE, closure) ;
			AllLoader.add(confPath, "config") ;
			AllLoader.launch() ;
		}

		
		protected function onZipConfComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			AllLoader.clean() ;
			var p:Dictionary = LoadedData.list ;
			__model.config = p["XML"]["__config__.xml"] ;
			for each(var entry:XML in __model.config.*) {
				var name:String = entry.toString() ;
				var n:String = name.match(BasicRegExp.str_NAJA_PROTECTED_TO_ID)[0] ;
				__model[n] = p["XML"][name] ;
			}
			configure() ;
		}
		
		protected function onConfComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			var p:Dictionary = LoadedData.list ;
			__model.config = p["XML"]["config"] ;
			var confDirPath:String = Root.user.fromPath("config").match(BasicRegExp.url_KEEP_DIRECTORY)[0] ;
			LoadedData.empty() ;
			AllLoader.clean().addEventListener(Event.COMPLETE, onSettingsComplete) ;
			for each(var entry:XML in __model.config.*) {
				AllLoader.add(Root.user.fromPath(confDirPath, entry.toString()), entry.@name.toXMLString()) ;
			}
			AllLoader.launch() ;
		}
		
		private function onSettingsComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			AllLoader.clean() ;
			var p:Dictionary = LoadedData.list ;
			for each(var entry:XML in __model.config.*) {
				var name:String = entry.@name.toXMLString() ;
					__model[name] = p["XML"][name] ;
			}
			configure() ;
		}
		///////////////////////////////////////////////////////////////////////////////// OPEN
		/**
		 * Opens the site, meaning all setups are cleared.
		 */
		internal function openSite():void
		{
			var u:VirtualSteps = __model.user.customizer ;
			var home:String = __dialoger.swfAddress.home ;
			__dialoger.hierarchy.functions = u ;
			u.commandOpen.addEventListener(Event.COMPLETE,onOpen) ;
			__dialoger.hierarchy.functions.play() ;
		}
		protected function onOpen(e:Event):void 
		{
			__dialoger.initAddress(__dialoger.swfAddress.home) ;
		}
		///////////////////////////////////////////////////////////////////////////////// CONNECT
		internal function dispatchConnect():void
		{
			if (hasEventListener(Event.COMPLETE)) dispatchEvent(new Event(Event.COMPLETE)) ;
		}
		///////////////////////////////////////////////////////////////////////////////// LOAD CONFIG
		/**
		 * Inits the Structure according to the loaded Configuration XML
		 */
		internal function configure():void
		{
			var params:XML = __model.params ;
			var defaultAddress:String = params.@defaultAddress.toXMLString() ;
			var stageXML:XML = params.stage[0] ;
			var schemeXML:XML = params.scheme[0] ;
			var elems:XML = __model.elements ;
			var debugXML:XML = elems.debug[0] ;
			var tfXML:XML = elems.textfields[0] ;
			var links:XML = __model.links ;
			
			__context.initStage(stageXML) ;
			Root.__scheme = __context.initFrameSet(schemeXML) ;
			__context.displayer.debug = __context.displayer.initDebug(debugXML) ;
			__dialoger.jsModule.init(__model.scripts) ;
			__dialoger.initLinks(links) ;
			__dialoger.swfAddress.debug_tf = __context.displayer.debug ;
			__dialoger.swfAddress.home = defaultAddress ;
			AllLoader.clean().init(Root.root, "libraries", __model.libraries) ;
			GraphicalLoader.enable().graphics.start(loadLibs) ;
		}
		///////////////////////////////////////////////////////////////////////////////// LOAD LIBS
		/**
		 * Loads the differents libraries in a second Row.
		 */
		internal function loadLibs():void
		{
			AllLoader.addEventListener(Event.COMPLETE, onLoadsComplete) ;
			AllLoader.launch() ;
		}
		/**
		 * Sets the loaded datas, and dispatch a CONNECT Event.
		 */
		protected function onLoadsComplete(e:Event):void 
		{
			if (AllLoader.isLastPhase) {
				e.target.removeEventListener(e.type, arguments.callee) ;
				GraphicalLoader.graphics.kill(siteInitiation) ;
				GraphicalLoader.disable() ;
			}
		}
		
		internal function siteInitiation():void
		{
			AllLoader.clean() ;
			__model.data.loaded = LoadedData.empty() ;
			
			// HERE TO CONTINUE
			setTimeout(dispatchConnect, .2) ;
			//launchAgain() ;
		}
		//////////////////////////////////////////////////////// REGISTER / UNREGISTER
		public function register(c:*, ...rest:Array):*
		{
			var ref:* ;
			if (c is Class) {
				ref = c ;
				if (Boolean(__registered[ref])) throw(new ReferenceError("The Object is already instanciated")) ;
				__registered[ref] = c["init"].apply(this,[].concat(rest)) ;
			}else{
				ref = Object(c).constructor ;
				if (Boolean(__registered[ref])) throw(new ReferenceError("The Object is already instanciated")) ;
				__registered[ref] = c ;
			}
			return __registered[ref] ;
		}
		public function unregister(c:*):*
		{
			var ref:* , obj:* ;
			if (c is Class) {
				ref = c ;
				if (!Boolean(__registered[ref])) throw(new ReferenceError("The Object is not instanciated")) ;
				obj = __registered[ref] ;
			}else{
				ref = Object(c).constructor ;
				if (!Boolean(__registered[ref])) throw(new ReferenceError("The Object is not instanciated")) ;
				obj = __registered[ref] ;
			}
			__registered[ref] = null ;
			delete __registered[ref] ;
			return obj ;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function register(c:*, ...rest:Array):*
		{return __instance.register.apply(__instance, [c].concat(rest)) }
		static public function unregister(c:*):*
		{return __instance.unregister(c) }
		static public function get instance():XBaseModule { return __instance || new XBaseModule() }
		static public function set instance(value:XBaseModule):void { __instance = value }
		static public function get hasInstance():Boolean { return Boolean(__instance as XBaseModule) }
	}
}