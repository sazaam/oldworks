	/*
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

package naja.model 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextField;
	import naja.model.control.regexp.BasicRegExp;
	import naja.model.XModel;
	import naja.model.data.loadings.loaders.I.ILoaderGraphics;
	import naja.tools.steps.VirtualSteps;
	
	/**
	 * The XUser class is part of the Naja X API.
	 * 
	 * @see	naja.model.Root
	 * @see	naja.model.XData
	 * @see	naja.model.XModel
	 * @see	boa.core.x.base.Base
	 * 
     * @version 1.0.0
	 */
	
	public class XUser
	{
//////////////////////////////////////////////////////// VARS
		private var __customizer:VirtualSteps ;
		private var __model:XModel ;
		private var __root:Root ;
		private var __pathes:Object ;
		private var __rootPath:String ;
		private var __address:String ;
		private var __parameters:Object ;
		private var __sessionTicket:* ;
		private var __token:* ;
		private var __userData:Object = {};
		private var __loaderGraphics:ILoaderGraphics;
//////////////////////////////////////////////////////// CTOR
		/**
		 * Constructs an XUser
		 */	
		public function XUser() 
		{
			__root = Root.root ;
			__root.addEventListener(Event.ADDED_TO_STAGE, onStage ) ;
		}
		///////////////////////////////////////////////////////////////////////////////// SITE PATHES
		public function fromPath(...rest:Array):String
		{
			var l:int = rest.length ;
			var s:String = "", p:String = "";
			for (var i:int = 0 ; i < l ; i++ ) {
				var str:String = rest[i] ;
				if (!Boolean(str)) throw new ArgumentError("An error occurred...should check that every param of rest array is a String") ;
				if (Boolean(sitePathes[str])) p = String(sitePathes[str]) ;
				else if (str.match(BasicRegExp.url_VARIABLE_PATH_MULTI) is Array) p = toPath(str)
				else p = str ;
				if(p.indexOf(".") == -1) checkSlash(p) ;
				s += p ;
			}
			return s ;
		}
		private function checkSlash(s:String):String
		{
			if (s.search(BasicRegExp.url_IS_FOLDER_SLASHED) == -1) s += "/" ;
			return s
		}
		public function fromRoot(...rest:Array):String
		{
			return __rootPath+fromPath.apply(null,[].concat(rest)) ;
		}
		public function toPath(str:String):String
		{
			return str.replace(BasicRegExp.url_VARIABLE_PATH_MULTI, function():String{ return __pathes[arguments[1]] }) ;
		}
		///////////////////////////////////////////////////////////////////////////////// SITE PATHES
		/**
		 * Sets Pathes of the application, checking whether running online or not.
		 * 
		 * @param o Object - An Object already containing custom pathes for the application 
		 * @return Object - An Object containing custom pathes of the application (to SWF, to XML, to IMG).
		 */
		internal function setSitePathes(o:Object):Object
		{
			var pathes:Object = { } ;
			var obj:Object = root.loaderInfo.parameters ;
			for (var a:String in o) {
				pathes[a] = o[a] ;
			}
			for (var i:String in obj) {
				if (i in pathes) pathes[i] = obj[i] ;
			}
			__pathes = pathes ;
			__rootPath = __pathes['root'] ;
			for (var j:String in pathes) {
				if (j in pathes) pathes[j] = toPath(pathes[j]) ;
			}
			__pathes = pathes ;
			return pathes ;
		}
		

		///////////////////////////////////////////////////////////////////////////////// STAGE INIT
		private function onStage(e:Event):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			__model = XModel.init() ;
			__model.module.load() ;
			__model.module.addEventListener(Event.COMPLETE, onConnect) ;
		}
		///////////////////////////////////////////////////////////////////////////////// MODEL CONNECT
		private function onConnect(e:Event):void 
		{
			play() ;
		}
		private function play():void
		{
			__model.module.open() ;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get model():XModel { return __model }
		public function get root():Root { return __root }
		public function get initModule():XModule { return __model.module  }
		public function set initModule(value:XModule) { XModule.instance = value }
		public function get customizer():VirtualSteps { return __customizer }
		public function set customizer(value:VirtualSteps):void 
		{ __customizer = value }
		public function get loaderGraphics():ILoaderGraphics { return __loaderGraphics }
		public function set loaderGraphics(g:ILoaderGraphics):void 
		{ __loaderGraphics = g }
		public function get parameters():Object { return __parameters }
		public function get sitePathes():Object {return __pathes } 
		public function set sitePathes(value:Object):void 
		{ setSitePathes(value) }
		public function get userData():Object { return __userData }
		public function get address():String { return __address }
		public function get token():* { return __token }
		public function get sessionTicket():* { return __sessionTicket }
	}
}