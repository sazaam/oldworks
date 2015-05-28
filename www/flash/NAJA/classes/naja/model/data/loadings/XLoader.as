package naja.model.data.loadings
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import naja.model.control.loading.LoadingsController;
	import naja.model.control.regexp.BasicRegExp;
	import naja.tools.formats.FileFormat;

	/**
	 * 
	 * 
	 * Use of XLoader
	 * 
		var loader:XLoader = new XLoader() ;
		loader.addRequestByUrl("../swf/library/neo_tech_dacia_regular.swf","arial") ;
		loader.addRequestByUrl("../xml/struct/sections/portfolio.xml","portfolio") ;
		loader.addRequestByUrl("../img/home.jpg", "image1") ;
		loader.addRequestByUrl("../img/home2.jpg", "image2") ;
		loader.addRequestByUrl("../img/home3.jpg", "image3") ;
		loader.addRequestByUrl("../img/home4.jpg", "image4") ;
		loader.addEventListener(ProgressEvent.PROGRESS, onProgress) ;
		loader.addEventListener(Event.COMPLETE, onComplete) ;
		loader.load() ;
	 */
	
	public class XLoader extends EventDispatcher
	{
		//////////////////////////////////////////////////////// VARS
		internal var __reqs:Dictionary = new Dictionary() ;
		internal var __requests:Array = [] ;
		private var __waitAllOpened:Boolean = true ;
		//////////////////////////////////////////////////////// CTOR
		public function XLoader():void
		{

		}
		///////////////////////////////////////////////////////////////////////////////// ADD & REMOVE
		public function addRequest(request:XLoaderRequest):XLoaderRequest
		{
			for each (var e:XLoaderRequest in __reqs) if (e == request) throw new ArgumentError("Request already exists") ;
			if (request.url == null || request.url == "") throw new ArgumentError("Must specify a non-null URL") ;
			request = LoadingsController.treatRequest(this, request) ;
			__reqs[request] = request ;
			request.index = __requests.push(request) - 1 ;
			return request ;
		}
		
		public function addRequestByUrl(url:String, id:String = null, fileFormat:String = null, chacheEnabled:Boolean = true):XLoaderRequest
		{
			return addRequest(new XLoaderRequest(url, id, fileFormat, chacheEnabled)) ;
		}
		public function removeRequest(request:XLoaderRequest, eraseAll:Boolean = false):XLoaderRequest
		{
			if (__reqs[request] != null) {
				removeEventListenerFrom(request) ;
				request.unload(eraseAll) ;
				var n:int = __requests.indexOf(request) ;
				delete __requests[n] ;
				__requests.splice(n, 1) ;
				delete __reqs[request] ;
			}else	throw new ArgumentError("Unable to remove Request since doesn't exist") ;
			return request ;
		}
		public function removeRequestById(id:String, eraseAll:Boolean = true):XLoaderRequest
		{
			return removeRequest(getRequestById(id), eraseAll) ;
		}
		public function removeRequestByUrl(url:String, eraseAll:Boolean = true):XLoaderRequest
		{
			return removeRequest(getRequestByUrl(url), eraseAll) ;
		}
		public function removeAllRequests(eraseAll:Boolean = true):Array
		{
			var reqs:Array = [] ;
			for each (var request:XLoaderRequest in __reqs)
			{
				removeRequest(request, eraseAll) ;
				reqs.push(request) ;
			}
			return reqs ;
		}
		///////////////////////////////////////////////////////////////////////////////// GET REQUEST
		public function getRequestById(id:String):XLoaderRequest
		{
			for each (var request:XLoaderRequest in __reqs) if (id == request.id) return request ;
			throw new ArgumentError("Unable to found Request to remove - Wrong ID") ;
		}
		public function getRequestByUrl(url:String):XLoaderRequest
		{
			for each (var request:XLoaderRequest in __reqs) if (url == request.url) return request ;
			throw new ArgumentError("Unable to found URL key in Requests") ;
		}
		public function getRequestByIndex(i:uint):XLoaderRequest
		{
			if(Boolean(XLoaderRequest(__requests[i]))) return XLoaderRequest(__requests[i]) ;
			throw new ArgumentError("Invalid index - Out of Requests Array bounds...") ;
		}
		///////////////////////////////////////////////////////////////////////////////// RESPONSES
		public function getResponse(request:XLoaderRequest):*
		{
			for each (var req:XLoaderRequest in __reqs) {
				if (req == request) {
					if (request.response != null) return request.response ;
					else throw new ArgumentError("Request has no response... yet...") ;
				}
			}
			throw new ArgumentError("Response wasn't found - Wrong Request") ;
		}
		public function getResponseById(id:String):*
		{
			for each (var req:XLoaderRequest in __reqs) {
				if (id == req.id) {
					if (req.response != null) return req.response ;
					else throw new ArgumentError("Request with such ID has no response... yet...") ;
				}
			}
			throw new ArgumentError("Response wasn't found - Wrong ID");
		}
		public function getAllResponses():Array
		{
			var responses:Array = [] ;
			for each (var req:XLoaderRequest in __reqs) {
				if (req.response != null) responses.push(req.response) ;
			}
			return responses ;
		}
		///////////////////////////////////////////////////////////////////////////////// LOAD
		public function load():void
		{
			for each (var request:XLoaderRequest in __reqs) {
				addEventListenerTo(request) ;
				request.load() ;
			}
		}
		public function loadBytes(data:ByteArray):void
		{
			for each (var request:XLoaderRequest in __reqs) {
				addEventListenerTo(request) ;
				request.loadBytes(data) ;
			}
		}
		///////////////////////////////////////////////////////////////////////////////// ADD & REMOVE EVENT LISTENERS
		internal function addEventListenerTo(req:XLoaderRequest):void
		{
			req.addEventListener(Event.OPEN, open) ;
			req.addEventListener(ProgressEvent.PROGRESS, progress) ;
			req.addEventListener(Event.COMPLETE, complete) ;
		}
		internal function removeEventListenerFrom(req:XLoaderRequest):void
		{
			req.removeEventListener(Event.OPEN, open) ;
			req.removeEventListener(ProgressEvent.PROGRESS, progress) ;
			req.removeEventListener(Event.COMPLETE, complete) ;
		}
		///////////////////////////////////////////////////////////////////////////////// OPEN
		private function open(event:Event):void
		{
			var allOpened:Boolean = true ;
			for each (var request:XLoaderRequest in __reqs) {
				if (!waitAllOpened) request.removeEventListener(Event.OPEN, open) ;
				if (!request.opened) allOpened = false ;
			}
			if (allOpened || !waitAllOpened) dispatchEvent(new Event(Event.OPEN)) ;
		}
		///////////////////////////////////////////////////////////////////////////////// PROGRESS
		private function progress(e:ProgressEvent):void
		{
			var allOpened:Boolean = true ;
			var bytesLoaded:int = 0 ;
			var bytesTotal:int = 0 ;
			for each (var req:XLoaderRequest in __reqs) {
				if (!req.opened) {
					allOpened = false ;
					break ;
				}
				bytesLoaded += req.bytesLoaded ;
				bytesTotal += req.bytesTotal ;
			}			
			if (allOpened || !waitAllOpened) dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal)) ;
		}
		///////////////////////////////////////////////////////////////////////////////// COMPLETE
		private function complete(e:Event):void
		{
			removeEventListenerFrom(XLoaderRequest(e.target)) ;
			var allCompleted:Boolean = true ;
			var bytesLoaded:int = 0 ;
			var bytesTotal:int = 0 ;
			var response:Array = [] ;
			for each (var req:XLoaderRequest in __reqs) {
				if (!req.completed) {
					allCompleted = false ;
					break ;
				}
				bytesLoaded += req.bytesLoaded ;
				bytesTotal += req.bytesTotal ;
				response.push(req.response) ;
			}
			if (allCompleted) dispatchEvent(new Event(Event.COMPLETE)) ;
		}
///////////////////////////////////////////////////////////////////////////////// STATICS
		static public function toXMLNode(...rest:Array):XML
		{
			return LoadingsController.toXMLNode.apply(null, [].concat(rest)) ;
		}
		static public function testUrl(url:String, font:Boolean= false):String
		{
			return LoadingsController.testUrl(url, font) ;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get waitAllOpened():Boolean
		{ return __waitAllOpened }
		public function set waitAllOpened(value:Boolean):void
		{ __waitAllOpened = value }
		public function get requests():Array { return __requests }
		public function set requests(value:Array) { __requests = value }
		public function get requestsDict():Dictionary { return __reqs }
	}
}