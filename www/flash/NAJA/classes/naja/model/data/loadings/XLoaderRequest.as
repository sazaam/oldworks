package naja.model.data.loadings 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import naja.model.control.loading.LoadingsController;
	import naja.model.control.regexp.BasicRegExp;
	import naja.tools.formats.FileFormat;
	import naja.tools.zip.ZipEntry;
	import naja.tools.zip.ZipFile;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class XLoaderRequest extends EventDispatcher
	{
		//////////////////////////////////////////////////////// VARS
		public var index:int = 0 ;
		private var __id:String ;
		private var __fileFormat:String ;
		private var __cacheEnabled:Boolean ;
		private var __loader:* ;
		private var __request:URLRequest = new URLRequest() ;
		private var __response:* ;
		private var __bytesLoaded:int = 0 ;
		private var __bytesTotal:int = 0 ;
		private var __opened:Boolean = false ;
		private var __completed:Boolean = false ;
		private var __ext:String ;
		//////////////////////////////////////////////////////// CTOR
		public function XLoaderRequest(url:String = null, id:String = null, fileFormat:String = null, cacheEnabled:Boolean = true):void
		{
			this.url = url ;
			this.id = id ;
			this.fileFormat = fileFormat || url.match(BasicRegExp.ext_STRICT_RE)[0] ;
			this.cacheEnabled = cacheEnabled ;
		}
		
		static public function toXMLNode(...rest:Array):XML
		{
			return LoadingsController.toXMLNode.apply(null, [].concat(rest)) ;
		}
		static public function fromXMLNode(node:XML):XLoaderRequest
		{
			return LoadingsController.fromXMLNode(node) ;
		}
		///////////////////////////////////////////////////////////////////////////////// LOAD & UNLOAD
		internal function load():void
		{
			request.url = url ;
			if (!cacheEnabled) {
				var uniqueKey:String = new Date().toString() ;
				var pattern:RegExp = /\ / ;
				while (uniqueKey.search(pattern) != -1)
				{
					uniqueKey = uniqueKey.replace(pattern, "") ;
				}
				var doNotCache:String = (url.search(BasicRegExp.url_PARAMS_RE) != -1) ? "&" : "?" ;
				doNotCache += "noCache=" + uniqueKey + Math.random() ;
				request.url += doNotCache ;
			}
			request.contentType = contentType ;
			request.data = data ;
			request.method = method ;
			request.requestHeaders = requestHeaders ;
			loader.load(request) ;
		}
		internal function loadBytes(__data:ByteArray):void
		{
			loader.loadBytes(__data) ;
		}
		internal function unload(eraseAll:Boolean = false):void
		{
			if (loader is Loader) Loader(loader).unload() ;
			if (eraseAll) {
				id = null ;
				fileFormat = null ;
				cacheEnabled = true ;
				loader = null ;
				__request = new URLRequest() ;
				__response = null ;
				__bytesLoaded = 0 ;
				__bytesTotal = 0 ;
				__opened = false ;
				__completed = false ;
			}
		}
		///////////////////////////////////////////////////////////////////////////////// GETEVENTDISPATCHER
		private function getEventDispatcher(loader:*):EventDispatcher
		{
			var eventDispatcher:EventDispatcher ;
			if (loader is Loader) eventDispatcher = Loader(loader).contentLoaderInfo ;
			else if (loader is URLLoader) eventDispatcher = URLLoader(loader) ;
			return eventDispatcher ;
		}
		///////////////////////////////////////////////////////////////////////////////// OPEN
		private function open(e:Event):void
		{
			__opened = true ;
			dispatchEvent(e) ;
		}
		///////////////////////////////////////////////////////////////////////////////// PROGRESS
		private function progress(e:ProgressEvent):void
		{
			__bytesLoaded = e.bytesLoaded;
			__bytesTotal = e.bytesTotal;
			dispatchEvent(e);
		}
		///////////////////////////////////////////////////////////////////////////////// COMPLETE
		private function complete(e:Event):void
		{
			var response:* = LoadingsController.treatComplete(this, e) ;
			__response = response ;
		}
		///////////////////////////////////////////////////////////////////////////////// HTTPSTATUS
		private function httpStatus(e:HTTPStatusEvent):void
		{
			dispatchEvent(e) ;
		}
		///////////////////////////////////////////////////////////////////////////////// IOERROR
		private function ioError(e:IOErrorEvent):void
		{
			dispatchEvent(e) ;
		}
		///////////////////////////////////////////////////////////////////////////////// SECURITYERROR
		private function securityError(e:SecurityErrorEvent):void
		{
			dispatchEvent(e) ;
		}
		///////////////////////////////////////////////////////////////////////////////// INIT
		private function init(e:Event):void
		{
			dispatchEvent(e) ;
		}
///////////////////////////////////////////////////////////////////////////////// TOSTRING
		override public function toString():String{
			return '[Object XLoaderRequest [url : ' + __request.url + ', id : ' + __id + ', fileFormat : ' +__fileFormat+ ', extension : '+ __ext +' , response : ' + __response+']]' ;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get contentType():String
		{ return request.contentType }
		public function set contentType(value:String):void
		{ request.contentType = value }
		public function get data():Object
		{ return request.data }
		public function set data(value:Object):void
		{ request.data = value }
		public function get method():String
		{ return request.method }
		public function set method(value:String):void
		{ request.method = value }
		public function get requestHeaders():Array
		{ return request.requestHeaders }
		public function set requestHeaders(value:Array):void
		{ request.requestHeaders = value }
		public function get url():String
		{ return request.url }
		public function set url(value:String):void
		{ request.url = value }
		public function get id():String
		{ return __id }
		public function set id(value:String):void
		{ __id = value }
		public function get fileFormat():String
		{ return __fileFormat }
		public function set fileFormat(value:String):void
		{ __fileFormat = value }
		public function get cacheEnabled():Boolean
		{ return __cacheEnabled }
		public function set cacheEnabled(value:Boolean):void
		{ __cacheEnabled = value }
		public function get loader():*
		{ return __loader }
		public function set loader(value:*):void
		{
			if (!(value is Loader || value is URLLoader || value == null)) throw new Error("Loader must be either a Loader or an URLLoader, or null...") ;
			var eventDispatcher:EventDispatcher = getEventDispatcher(__loader) ;
			if (eventDispatcher != null)
			{
				eventDispatcher.removeEventListener(Event.OPEN, open) ;
				eventDispatcher.removeEventListener(ProgressEvent.PROGRESS, progress) ;
				eventDispatcher.removeEventListener(Event.COMPLETE, complete) ;
				eventDispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus) ;
				eventDispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioError) ;
				eventDispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError) ;
				eventDispatcher.removeEventListener(Event.INIT, init) ;
			}
			eventDispatcher = getEventDispatcher(value) ;
			if (eventDispatcher != null)
			{
				eventDispatcher.addEventListener(Event.OPEN, open) ;
				eventDispatcher.addEventListener(ProgressEvent.PROGRESS, progress) ;
				eventDispatcher.addEventListener(Event.COMPLETE, complete) ;
				eventDispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus) ;
				eventDispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioError) ;
				eventDispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError) ;
				eventDispatcher.addEventListener(Event.INIT, init);
			}
			__loader = value;
		}
		public function get request():URLRequest
		{ return __request }
		public function get response():*
		{ return __response }
		public function set response(value:*):void
		{ __response = value }
		public function get bytesLoaded():int
		{ return __bytesLoaded }
		public function get bytesTotal():int
		{ return __bytesTotal }
		public function get opened():Boolean
		{ return __opened }
		public function get completed():Boolean {return __completed}
		public function set completed(value:Boolean):void
		{ __completed = value }
		public function get ext():String { return __ext }
		public function set ext(value:String):void { __ext = value }
	}
}