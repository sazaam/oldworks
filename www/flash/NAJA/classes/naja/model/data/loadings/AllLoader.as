﻿	/*
	 * Version 1.0.0
	 * Copyright BOA 2009
	 * 
	 * 
                                                                      SSSSSS
                                                                      SSSSSS
                                                                      SSSSSS
                                                                      3SSSSS



                    SSSSS                      ASSSSSS                                     SSSSSSA                 3ASSSSSS
        ASSSS    SSSSSSSSSSS               SSSSSSSSSSSSSSS            3SSSSS          3SSSSSSSSSSSSSS         S3SSSS SA3 3 SA3S
        ASSSS  SSSSSSSSSSSSSSS           SSSSSSSSSSSSSSSSSS           3SSSSS        SSSSSSSSSSSSSSSSSSS     SSS3SSSSSSSS3 SS S33
        ASSSS3SSSSSSA3SSSSSSSSS         SSSSSSS3    3SSSSSSS          3SSSSS        SSSSSSS     SSSSSSSS   A3ASS3SSSSSSSSASSSSSAS
        ASSSSSSSS        SSSSSS         SSS            SSSSSS         3SSSSS        SSS            SSSSS3 3SSSSSSSSSSSASA    33
        ASSSSSSS          SSSSSS                        SSSSS         3SSSSS                       SSSSSS 33SSSSSS3SSSSA
        ASSSSS             SSSSS                        SSSSS         3SSSSS                        SSSSSSS SSSSSSS3AS
        ASSSSS             SSSSS                        SSSSS3        3SSSSS                        SSSSSSSSSS 33SS3A3
        ASSSSS             SSSSS                        SSSSS3        3SSSSS                        SSSSS3SSSSSSSSSSSS
        ASSSSS             SSSSS               SSSSSSSSSSSSSS3        3SSSSS              3SSSSSSSSSSSSSSSASS SSSS
        ASSSSS             SSSSS           SSSSSSSSSSSSSSSSSS3        3SSSSS          3SSSSSSSSSSSSSSSSSSSSS3 SSSSSS3
        ASSSSS             SSSSS         SSSSSSSSSSSSSSSSSSSS3        3SSSSS        3SSSSSSSSSSSSSSSSSSSSSSS 3SSS 33
        ASSSSS             SSSSS        SSSSSS          SSSSS3        3SSSSS       SSSSSSS          SSSSSSSS   SSSS
        ASSSSS             SSSSS       SSSSSS           SSSSS3        3SSSSS       SSSSS            SSSSSS   3 SSS3
        ASSSSS             SSSSS       SSSSS            SSSSS3        3SSSSS      ASSSSS            SSSSSSA   A AA
        ASSSSS             SSSSS       SSSSS            SSSSS3        3SSSSS      SSSSSS            SSSSSS  ASA3S
        ASSSSS             SSSSS       SSSSS           SSSSSS3        3SSSSS      ASSSSS           SSSSSSS    3AS
        ASSSSS             SSSSS       SSSSSS        SSSSSSSS3        3SSSSS       SSSSSS        SSSSSSSSS    3A
        ASSSSS             SSSSS        SSSSSSSSSSSSSSSSSSSSS3        3SSSSS       ASSSSSSSSSSSSSSSSSSSSSS    S
        ASSSSS             SSSSS         SSSSSSSSSSSSSS  SSSS3        3SSSSS         SSSSSSSSSSSSSS 3SSSS
        3SSSS3             SSSSS           SSSSSSSSSS    SSSS         3SSSSS           SSSSSSSSSA    SSSS    A
                                                                      3SSSSS                             A  S
                                                                      ASSSSS                               3
                                                                      SSSSSA
                                                                      SSSSS
                                                                SSSSSSSSSSS
                                                                SSSSSSSSSS
                                                                SSSSSSSSA
                                                                   33
	 
	 * 
	 * 
	 *  
	 */


package naja.model.data.loadings
{
	import flash.display.Bitmap;
	import flash.text.Font;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import naja.tools.commands.Command;
	import naja.model.control.regexp.BasicRegExp ;
	import naja.tools.formats.FileFormat;
	import naja.tools.lists.Gates;
	import naja.model.data.loadings.E.LoadEvent ;
	import naja.model.data.loadings.E.LoadProgressEvent ;
	import flash.display.DisplayObjectContainer ;
	import flash.display.Sprite ;
	import flash.display.Stage ;
	import flash.events.Event ;
	import flash.events.IEventDispatcher ;
	import flash.events.ProgressEvent ;
	import naja.tools.steps.E.StepEvent;
	import naja.tools.steps.VirtualSteps;
	
	 public class AllLoader extends XLoader
	{
		////////////////////////////////////////////////////////////////////////////////////VARS
		static private var __instance:AllLoader ;
		protected var __scheme:XML ;
		protected var __target:IEventDispatcher ;
		protected var __idSequence:String;
		protected var __merged:Gates;
		protected var __proxyLoader:XLoader ;
		private var __mergedLoadings:Boolean;
		private var __currentLoads:Gates;
		private var __phase:String = "none";
		private var __phases:Array;
		private var __originalScheme:XML;
		private var __zipEnabled:Boolean;
		private var __zipParams:Object;
		
		////////////////////////////////////////////////////////////////////////////////////CTOR
		/**
		 * Constructs an AllLoader Object 
		 */
		public function AllLoader()
		{
			super() ;
			__instance = this ;
		}
		////////////////////////////////////////////////////////////////////////////////////INIT
		/**
		 * 
		 * @param	_tg
		 * @param	__idSequence
		 * @return the current AllLoader object
		 */
		public function init(_tg:IEventDispatcher, _idSequence:String = null, _scheme:XML = null, mergedLoadings:Boolean = true):AllLoader
		{
			__scheme = Boolean(_scheme)? _scheme.copy() : XML(<scheme />) ;
			snapOriginalScheme() ;
			__idSequence = _idSequence || "ALL" ;
			__scheme.@sequence = __idSequence ;
			__target = _tg ;
			__mergedLoadings = mergedLoadings ;
			checkMerged() ;
			return this ;
		}
		
		private function checkMerged():void
		{
			if (Boolean(__scheme.@merged.toXMLString())) {
				__mergedLoadings = Boolean(stringToBoolean(__scheme.@merged.toXMLString())) ;
			}else {
				__scheme.@merged = String(__mergedLoadings) ;
			}
		}
		private function snapOriginalScheme():void
		{
			__originalScheme = __scheme.copy() ;
		}
		public function clean():AllLoader
		{
			getLoader().removeAllRequests() ;
			
			__proxyLoader = new XLoader() ;
			__scheme = XML(<scheme />) ;
			__scheme.@merged = String(__mergedLoadings) ;
			__phase = 'All' ;
			return this ;
		}
		///////////////////////////////////////////////////////////////////////////////// SEPARATE
		private function launchMultiLoad():void
		{
			treat(0) ;
		}
		
		private function enable():void
		{
			addEvents() ;
		}
		private function clear():void
		{
			var reqs:Array = [].concat(__proxyLoader.requests) ;
			__proxyLoader.removeAllRequests() ;
			__proxyLoader = new XLoader() ;
			__proxyLoader.requests = reqs ;
			removeEvents() ;
		}
		private function removeEvents():void
		{
			__proxyLoader.removeEventListener(Event.OPEN, onOpen) ;
			__proxyLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress) ;
			__proxyLoader.removeEventListener(Event.COMPLETE, onComplete) ;
			__proxyLoader.removeEventListener(Event.COMPLETE, onLoadXtraComplete) ;
		}
		private function addEvents():void
		{
			__proxyLoader.addEventListener(Event.OPEN, onOpen) ;
			__proxyLoader.addEventListener(ProgressEvent.PROGRESS, onProgress) ;
			__proxyLoader.addEventListener(Event.COMPLETE, onComplete) ;
			__proxyLoader.addEventListener(Event.COMPLETE, onLoadXtraComplete) ;
		}
		private function onOpen(e:Event):void 
		{
			dispatchEvent(e) ;
		}
		private function onLoadXtraComplete(e:Event):void 
		{
			if(!__mergedLoadings) {
				clear() ;
				if (Boolean(__merged.keys[__merged.keys.indexOf(__currentLoads) +1])) {
					treat(__merged.keys.indexOf(__currentLoads) +1) ;
				}
			}
		}
		private function treat(n:int):void
		{
			if (__currentLoads is Gates) __proxyLoader = new XLoader() ;
			__currentLoads = __merged.keys[n] ;
			for each (var req:XLoaderRequest in __currentLoads) {
				req.addEventListener(ProgressEvent.PROGRESS, onReqProgress) ;
				req.addEventListener(Event.COMPLETE, onReqComplete) ;
				req.addEventListener(Event.COMPLETE, clearReqComplete) ;
				req.addEventListener(Event.OPEN, onReqOpen) ;
				__proxyLoader.addRequest(req) ;
			}
			__phase = Gates.getKeyFromObject(__merged, __currentLoads) ;
			enable() ;
			__proxyLoader.load() ;
		}
		private function onReqOpen(e:Event):void 
		{
			var req:XLoaderRequest = XLoaderRequest(e.target) ;
			if(hasEventListener(LoadEvent.OPEN)) dispatchEvent(new LoadEvent(req, LoadEvent.OPEN, false, false,req.index)) ;
		}
		///////////////////////////////////////////////////////////////////////////////// MERGED & SEPARATE
		private function stringToBoolean(str:String):Boolean
		{
			return ( str == "true" ) ;
		}
		///////////////////////////////////////////////////////////////////////////////// LAUNCH
		public function launch():AllLoader 
		{
			sort() ;
			lauchLoadings() ;
			return this ;
		}
		private function lauchLoadings():void
		{
			var __node:XML , req:XLoaderRequest ;
			checkMerged() ;
			if (__mergedLoadings) {
				__phase = 'All' ;
				for each(__node in __scheme.*) {
					req = addRequest(XLoaderRequest.fromXMLNode(__node) ) ;
					req.addEventListener(ProgressEvent.PROGRESS, onReqProgress) ;
					req.addEventListener(Event.COMPLETE, onReqComplete) ;
					req.addEventListener(Event.COMPLETE, clearReqComplete) ;
					req.addEventListener(Event.OPEN, onReqOpen) ;
				}
				addEventListener(ProgressEvent.PROGRESS, onProgress) ;
				addEventListener(Event.COMPLETE, onComplete) ;
				addEventListener(Event.COMPLETE, clearComplete) ;
				load() ;
			}else {
				__merged = new Gates() ;
				__proxyLoader = new XLoader() ;
				for each(__node in __scheme.*) {
					req = XLoaderRequest.fromXMLNode(__node) ;
					switch(req.ext) {
						case FileFormat.ZIP :
						case FileFormat.FONTS :
						case FileFormat.SWF :
						case FileFormat.IMG :
						case FileFormat.XML:
							var b:Gates  = (req.ext in __merged) ? Gates(__merged[req.ext]) : Gates(__merged.add(new Gates() , req.ext)) ;
							b.add(req, req.id) ;
						break ;
						default :
							throw(new ReferenceError("Unexpected Fileformat case...")) ;
					}
				}
				launchMultiLoad() ;
			}
		}
		///////////////////////////////////////////////////////////////////////////////// SORT
		private function sort():void
		{
			var output:XML = XML(<scheme />) ;
			__phases = [] ;
			output.@merged = __scheme.@merged.toXMLString() ;
			if (__scheme.*.length() == 1) output.@merged = "true" ;
			for each(var __node:XML in __scheme.*) {
				__phases.push(__node.localName()) ;
				for each(var __same:XML in __scheme[__node.localName()]) {
					var p:XML = __same.copy() ;
					delete __scheme.*[__same.childIndex()] ;
					output.appendChild(p) ;
				}
			}
			if (stringToBoolean(output.@merged)) __phases = ["All"] ;
			__scheme = output ;
		}
		///////////////////////////////////////////////////////////////////////////////// REQUEST EVENTS
		private function onReqComplete(e:Event):void 
		{
			var req:XLoaderRequest = XLoaderRequest(e.target) ;
			var complete:LoadEvent = new LoadEvent(req, LoadEvent.COMPLETE, false, false,req.index) ;
			complete.content = req.response ;
			if (LoadedData) {
				switch(req.ext) {
					case FileFormat.VID :
						throw(new ReferenceError("VIDEO NOT SUPPORTED YET!...")) ;
					break ;
					case FileFormat.TEXT :
						throw(new ReferenceError("PLAIN TEXT NOT SUPPORTED YET!...")) ;
					break ;
					default :
						LoadedData.insert(req.ext.toUpperCase(), req.id, req.response) ;
					break ;
				}
			}
			if (hasEventListener(LoadEvent.COMPLETE)) dispatchEvent(complete) ;
			clearReqComplete(e) ;
		}
		private function onReqProgress(e:ProgressEvent):void 
		{
			var req:XLoaderRequest = XLoaderRequest(e.target) ;
			var progress:LoadProgressEvent = new LoadProgressEvent(req, false, false,req.index) ;
			progress.bytesLoaded = e.bytesLoaded ;
			progress.bytesTotal = e.bytesTotal ;
			if(hasEventListener(LoadProgressEvent.PROGRESS)) dispatchEvent(progress) ;
		}
		private function onComplete(e:Event):void 
		{
			if (e.target == __proxyLoader) dispatchEvent(e) ;
		}
		private function onProgress(e:ProgressEvent):void 
		{
			if (e.target == __proxyLoader) dispatchEvent(e) ;
		}
		private function clearComplete(e:Event):void
		{	
			removeEventListener(Event.COMPLETE, clearComplete) ;
			removeEventListener(Event.COMPLETE, onComplete) ;
			removeEventListener(ProgressEvent.PROGRESS, onProgress) ;
		}
		private function clearReqComplete(e:Event):void 
		{
			e.target.removeEventListener(ProgressEvent.PROGRESS, onReqProgress) ;
			e.target.removeEventListener(Event.COMPLETE, onReqComplete) ;
			e.target.removeEventListener(Event.OPEN, onReqOpen) ;
		}
		///////////////////////////////////////////////////////////////////////////////// ADD & REMOVE
		public function add(url:String,id:String,font:Boolean = false):void
		{
			__scheme.appendChild(XLoader.toXMLNode(url, id, font)) ;
		}
		public function removeById(id:String):XML
		{
			for each(var __node:XML in __scheme.*) 
				if (__node.@id ==  id) {
					delete __scheme.*[__node.childIndex()] ;
					return __node ;
				}
			return null ;
		}
		public function removeByUrl(url:String):XML
		{
			for each(var __node:XML in __scheme.*) 
				if (__node.@url ==  url) {
					delete __scheme.*[__node.childIndex()] ;
					return __node ;
				}
			return null ;
		}

		private function getLoader():XLoader
		{
			return __mergedLoadings ? super : __proxyLoader;
		}
///////////////////////////////////////////////////////////////////////////////// STATICS
		static public function testUrl(url:String, font:Boolean = false):String
		{
			return XLoader.testUrl(url, font) ;
		}
		static public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):AllLoader
		{ __instance.addEventListener(type, listener, useCapture, priority, useWeakReference) ;
			return __instance }
		static public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):AllLoader
		{ __instance.removeEventListener(type, listener, useCapture) ;
			return __instance }
		static public function init(_tg:IEventDispatcher, _idSequence:String = null, _scheme:XML = null, mergedLoadings:Boolean = true):AllLoader
		{ return instance.init(_tg, _idSequence, _scheme, mergedLoadings) }
		static public function clean():AllLoader { return __instance.clean() }
		static public function launch():AllLoader { return __instance.launch() }		
		static public function add(url:String, id:String = null, font:Boolean = false):void { __instance.add(url,id,font) }
		static public function removeById(id:String):XML { return __instance.removeById(id) }
		static public function removeByUrl(url:String):XML { return __instance.removeByUrl(url) }
////////////////////////////////////////////////////////////////////////////////////GETTERS & SETTERS
		static public function get target():IEventDispatcher{ return __instance ? __instance.__target : null }
		static public function set target(tg:IEventDispatcher):void { __instance.__target = tg }
		static public function get instance():AllLoader	{ return __instance || new AllLoader() }
		static public function get idSequence():String { return __instance.__idSequence } 
		static public function set idSequence(value:String):void { __instance.__idSequence = value }
		static public function get phase():String { return __instance.__phase }
		static public function get phases():Array{ return __instance.__phases }
		static public function get isLastPhase():Boolean{ return __instance.isLastPhase}
		static public function get scheme():XML{ return __instance.__scheme }
		static public function set scheme(value:XML):void { __instance.scheme = value }
		static public function get originalScheme():XML { return __instance.__originalScheme }
		static public function get zipEnabled():Boolean {return __instance.__zipEnabled }
		static public function set zipEnabled(value:Boolean):void{ __instance.__zipEnabled = value}
		
		static public function get requests():Array { return __instance.requests }
		static public function set requests(value:Array) { __instance.requests = value }
		
		override public function get requests():Array { return getLoader().__requests }
		override public function set requests(value:Array) { getLoader().__requests = value }
		override public function get requestsDict():Dictionary { return getLoader().__reqs}
		
		public function get target():IEventDispatcher{ return __target }
		public function set target(tg:IEventDispatcher):void { __target = tg }
		public function get idSequence():String { return __idSequence }
		public function set idSequence(value:String):void { __idSequence = value }
		public function get phase():String { return __phase }
		public function get phases():Array { return __phases }
		public function get isLastPhase():Boolean{ return __phase == __phases[__phases.length - 1]}
		public function get scheme():XML { return __scheme }
		public function set scheme(value:XML):void { __scheme = value.copy() ; snapOriginalScheme() ; checkMerged() }
		public function get originalScheme():XML { return __originalScheme }
		public function get zipEnabled():Boolean {return __zipEnabled}
		public function set zipEnabled(value:Boolean):void { __zipEnabled = value }
	}
}