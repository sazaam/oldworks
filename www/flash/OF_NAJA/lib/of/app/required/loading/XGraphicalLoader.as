package of.app.required.loading 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import of.app.required.loading.E.LoadEvent;
	import of.app.required.loading.E.LoadProgressEvent;
	import of.app.required.loading.I.ILoaderGraphics;
	
	/**
	 * ...
	 * @author saz
	 */
	public class XGraphicalLoader
	{
//////////////////////////////////////////////////////// VARS
		static private var __instance:XGraphicalLoader ;
		static public var FIREABLE_EVENTS:Array = [LoadEvent.OPEN, LoadEvent.COMPLETE, Event.OPEN, Event.COMPLETE, ProgressEvent.PROGRESS, LoadProgressEvent.PROGRESS] ;;
		
		private var __loader:XAllLoader;
		private var __graphics:ILoaderGraphics;
		private var __enabled:Boolean = false;
//////////////////////////////////////////////////////// CTOR
		public function XGraphicalLoader() 
		{
			__instance = this ;
		}
		public function init(g:ILoaderGraphics):XGraphicalLoader
		{
			__loader = XAllLoader.instance ;
			__graphics = g ;
			enable() ;
			
			trace(this, ' inited...')
			return this ;
		}
		public function enable():XGraphicalLoader
		{
			enabled = true ;
			return this ;
		}
		public function disable():XGraphicalLoader
		{
			enabled = false ;
			return this ;
		}
		private function addEvents(cond:Boolean = true ):void
		{
			var o:Class = XAllLoader , arr:Array = FIREABLE_EVENTS;
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
		static public function init(g:ILoaderGraphics = null):XGraphicalLoader { return instance.init(g) }
		static public function get instance():XGraphicalLoader { return __instance || new XGraphicalLoader() }
		static public function get hasInstance():Boolean { return  Boolean(__instance as XGraphicalLoader) }
		static public function get graphics():ILoaderGraphics { return  __instance.__graphics }
		static public function set graphics(value:ILoaderGraphics ):void { __instance.__graphics = value }
		static public function get enabled():Boolean {	return __instance.enabled }
		static public function enable():XGraphicalLoader { return __instance.enable() }
		static public function disable():XGraphicalLoader { return __instance.disable() }
		
		public function get enabled():Boolean {	return __enabled }
		public function set enabled(value:Boolean):void { addEvents(value) ; __enabled = value}
		public function get loader():XAllLoader { return __loader }
		public function get graphics():ILoaderGraphics { return __graphics }
		public function set graphics(value:ILoaderGraphics):void { __graphics = value }
	}
}