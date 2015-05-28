package of.app
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import of.app.required.context.XContext;
	import of.app.required.loading.LoadedData;
	import of.app.required.loading.XAllLoader;
	import of.app.required.loading.XGraphicalLoader;
	import of.app.required.regexp.BasicRegExp;
	import of.app.required.steps.VirtualSteps;
	import of.app.XConsole;
	import of.app.XUser;
	
	public class XBuild extends EventDispatcher
	{
		// REQUIRED
		static private var __instance:XBuild ;
		private var confModel:Object;
		//////////////////////////////////////// VARS
		public function XBuild() 
		{
			__instance = this ;
		}
		//////////////////////////////////////// INIT
		public function init(...rest:Array):XBuild
		{
			trace(this, 'inited...') ;
			confModel = { } ;
			return this ;
		}
		
		//////////////////////////////////////// REQUIRE CONF
		public function build(params:Object):XBuild
		{
			loadBaseConfXML() ;
			return this ;
		}
		
		private function requestBaseConf():void
		{
			var url:String = params.conf ;
			var loader:URLLoader = new URLLoader() ;
			loader.dataFormat = 'binary' ;
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus) ;
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError) ;
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError) ;
			loader.addEventListener(Event.COMPLETE, onComplete) ;
			loader.load(new URLRequest(url)) ;
		}
		//////////////////////////////////////// EVENTS
		private function onIOError(e:IOErrorEvent):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			trace(e) ;
			XUser.console.log('IOError >> '+String(e)) ;
		}
		private function onSecurityError(e:SecurityErrorEvent):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			trace(e) ;
			XUser.console.log('SecurityError >> '+String(e)) ;
		}
		private function onStatus(e:HTTPStatusEvent):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			trace(e) ;
			XUser.console.log('status >> '+String(e.status)) ;
		}
		private function onComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			trace(e.target.data) ;
			XUser.console.log('data >> '+e.target.data) ;
		}
		
		
		
		///////////////////////////////////////////////////////////////////////////////// LOAD CONFIG
		/**
		 * Loads the Configuration XML directly from Path in XParams, in a first Queue.
		 */
		internal function loadBaseConfXML():void
		{
			var confPath:String = XUser.parameters.fromPath("conf") ;
			
			XGraphicalLoader.disable() ;
			
			XAllLoader.addEventListener(Event.COMPLETE, onBaseConfXMLComplete) ;
			XAllLoader.add(confPath, "conf") ;
			XAllLoader.launch() ;
		}
		
		private function onBaseConfXMLComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			
			var p:Dictionary = LoadedData.list ;
			var conf:XML = confModel.conf = p["XML"]["conf"] ;
			LoadedData.empty() ;
			
			var confDir:String = XUser.parameters.fromPath("conf").match(BasicRegExp.url_KEEP_DIRECTORY)[0] ;
			
			XAllLoader.clean().addEventListener(Event.COMPLETE, onXMLSettingsComplete) ;
			
			for each(var entry:XML in conf.*) {
				XAllLoader.add(XUser.parameters.fromPath(confDir, entry.toString()), entry.@name.toXMLString()) ;
			}
			
			XAllLoader.launch() ;
			//XUser.console.log('data >> ' + conf)
			trace('data >> ' + conf)
		}
		
		private function onXMLSettingsComplete(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			XAllLoader.clean() ;
			var p:Dictionary = LoadedData.list ;
			var conf:XML = confModel.conf ;
			for each(var entry:XML in conf.*) {
				var name:String = entry.@name.toXMLString() ;
				confModel[name] = p["XML"][name] ;
			}
			configure() ;
		}
		
		private function configure():void
		{
			var params:XML = confModel.display ;
			var defaultAddress:String = params.@defaultAddress.toXMLString() ;
			//var stageXML:XML = params.stage[0] ;
			var schemeXML:XML = params.scheme[0] ;
			var elems:XML = confModel.elements ;
			var debugXML:XML = elems.debug[0] ;
			var tfXML:XML = elems.textfields[0] ;
			var links:XML = confModel.links ;
			var scripts:XML = confModel.scripts ;
			
			//XContext.initStage(stageXML) ;
			XConsole.log(XContext.displayer.stage.align) ;
			XConsole.log(XContext.displayer.stage.scaleMode) ;
			XUser.root.scheme = XContext.initFrameSet(schemeXML) ;
			XUser.factory.classes.dialoger.jsModule.parseCommand(scripts) ;
			XUser.factory.classes.dialoger.initLinks(links) ;
			XUser.factory.classes.dialoger.swfAddress.debug_tf = XConsole.TF ;
			XUser.factory.classes.dialoger.swfAddress.setHome(defaultAddress) ;
			trace('HOME of Site : ', XUser.factory.classes.dialoger.swfAddress.home)
			XAllLoader.clean().init(XUser.target, "libraries", confModel.libraries) ;
			XGraphicalLoader.enable().graphics.start(loadLibs) ;
		}
		///////////////////////////////////////////////////////////////////////////////// LOAD LIBS
		/**
		 * Loads the differents libraries in a second Queue.
		 */
		private function loadLibs():void
		{
			XAllLoader.addEventListener(Event.COMPLETE, onLoadsComplete) ;
			XAllLoader.launch() ;
		}
		/**
		 * Sets the loaded datas, and dispatch a CONNECT Event.
		 */
		private function onLoadsComplete(e:Event):void 
		{
			if (XAllLoader.isLastPhase) {
				e.target.removeEventListener(e.type, arguments.callee) ;
				XGraphicalLoader.graphics.kill(launchApp) ;
				XGraphicalLoader.disable() ;
			}
		}
		
		private function launchApp():void
		{
			XAllLoader.clean() ;
			XUser.data.loaded = LoadedData.empty() ;
			
			
			// __helpers__() ;
			
			// HERE TO CONTINUE
			//setTimeout(dispatchActive, .2) ;
			dispatchActive() ;
		}
		
		
		////// TODO HELPERS
		private function __helpers__():void
		{
			
		}
		
		private function dispatchActive():void
		{
			trace("ready to launch !!")
			dispatchEvent(new Event(Event.CONNECT)) ;
		}
		///////////////////////////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function init(...rest:Array):XBuild { return instance.init.apply(instance, [].concat(rest)) }
		static public function get hasInstance():Boolean { return Boolean(__instance as XBuild) }
		static public function get instance():XBuild { return hasInstance? __instance :  new XBuild() }
	}
}