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

package naja.model.control.loading 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import naja.model.data.loadings.loaders.DefaultLoaderGraphics;
	import naja.model.data.loadings.loaders.I.ILoaderGraphics;
	import naja.model.data.loadings.AllLoader;
	import naja.model.data.loadings.E.LoadEvent;
	import naja.model.data.loadings.E.LoadProgressEvent;
	
	/**
	 * ...
	 * @author saz
	 */
	public class GraphicalLoader
	{
//////////////////////////////////////////////////////// VARS
		static private var __instance:GraphicalLoader ;
		static public var FIREABLE_EVENTS:Array = [LoadEvent.OPEN, LoadEvent.COMPLETE, Event.OPEN, Event.COMPLETE, ProgressEvent.PROGRESS, LoadProgressEvent.PROGRESS] ;;
		
		private var __loader:AllLoader;
		private var __graphics:ILoaderGraphics;
		private var __enabled:Boolean = false;
//////////////////////////////////////////////////////// CTOR
		public function GraphicalLoader() 
		{
			__instance = this ;
		}
		public function init(g:ILoaderGraphics = null):GraphicalLoader
		{
			__loader = AllLoader.instance ;
			__graphics = g  || new DefaultLoaderGraphics() ;
			enable() ;
			return this ;
		}
		public function enable():GraphicalLoader
		{
			enabled = true ;
			return this ;
		}
		public function disable():GraphicalLoader
		{
			enabled = false ;
			return this ;
		}
		private function addEvents(cond:Boolean = true ):void
		{
			var o:Class = AllLoader , arr:Array = FIREABLE_EVENTS;
			for (var i:int = 0; i < arr.length ; i++ ) 
				cond? addEto(o, arr[i], onEvent) : removeEfrom(o, arr[i], onEvent) ;
		}
		private function onEvent(e:Event):void
		{
			if (!Boolean(__graphics is DefaultLoaderGraphics)) {
				var s:String = e.type , ph:String = e.target["phase"];
				s =  s.slice(0,1).toUpperCase().concat(s.slice(1)) ;
				var f:String = "on" + ph.toUpperCase() + s ;
				if (Object(__graphics).hasOwnProperty(f)) {
					__graphics[f](e) ;
				}
			}
		}
		private function addEto(o:Object, t:String, f:Function):void
		{
			if (!(o is IEventDispatcher|| Object(o).hasOwnProperty("addEventListener"))) throw new ArgumentError("Target is not available for adding any listeners...") ;
			o["addEventListener"](t, f) ;
		}
		private function removeEfrom(o:Object, t:String, f:Function):void
		{
			if (!(o is IEventDispatcher|| Object(o).hasOwnProperty("removeEventListener"))) throw new ArgumentError("Target is not available for removing any listeners...") ;
			o["removeEventListener"](t, f) ;
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function init(g:ILoaderGraphics = null):GraphicalLoader { return instance.init(g) }
		static public function get instance():GraphicalLoader { return __instance || new GraphicalLoader() }
		static public function get hasInstance():Boolean { return  Boolean(__instance) }
		static public function get graphics():ILoaderGraphics { return  __instance.__graphics }
		static public function set graphics(value:ILoaderGraphics ):void { __instance.__graphics = value }
		static public function get enabled():Boolean {	return __instance.enabled }
		static public function enable():GraphicalLoader { return __instance.enable() }
		static public function disable():GraphicalLoader { return __instance.disable() }
		
		public function get enabled():Boolean {	return __enabled }
		public function set enabled(value:Boolean):void { addEvents(value) ; __enabled = value}
		public function get loader():AllLoader { return __loader }
		public function get graphics():ILoaderGraphics { return __graphics }
		public function set graphics(value:ILoaderGraphics):void { __graphics = value }
	}
}