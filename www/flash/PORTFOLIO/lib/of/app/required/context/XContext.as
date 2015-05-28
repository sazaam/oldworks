package of.app.required.context 
{
	import asSist.$;
	import asSist.as3Query;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import of.app.required.resize.StageResize;
	
	/**
	 * ...
	 * @author saz
	 */
	public class XContext 
	{
		// REQUIRED
		static public var __instance:XContext;
		//////////////////////////////////////////////////////// VARS
		private var __displayer:Sprite ;
		private var __scheme:XML ;
		//////////////////////////////////////////////////////// CTOR
		public function XContext() 
		{
			__instance = this ;
		}
		public function init(...rest:Array):XContext
		{
			__displayer = rest[0] ;
			
			trace(this, 'inited...') ;
			return this ;
		}
		public function initStage(stageObj:Object):void
		{
			StageResize.instance.init($get(__displayer.stage).attr(stageObj)[0]) ;
		}
		public function initFrameSet(xml:XML):Sprite
		{
			var frameset:XML = xml.*[0] ;
			return $get(frameset).appendTo(__displayer)[0] ;
		}
		//////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get displayer():Sprite { return __instance.displayer }
		static public function set displayer(value:Sprite):void { __instance.displayer = value }
		static public function get scheme():XML { return __instance.__scheme }
		static public function set scheme(value:XML):void { __instance.__scheme = value }
		static public function $get(o:*):as3Query
		{ return $(o) as as3Query }
		static public function $check(o:*, id:String, name:String = null):as3Query
		{ 
			var p:as3Query ;
			p = $('#' + id) ;
			if (Boolean(p[0] )) {
				return p ;
			} else {
				p = $(o).attr({id:id, name:name || id}) ;
			}
			return p as as3Query ;
		}
		static public function $query(...rest:*):as3Query
		{ return as3Query.create.apply(as3Query, [].concat(rest)) as as3Query }
		static public function initStage(stageObj:Object):void { __instance.initStage(stageObj)}
		static public function initFrameSet(xml:XML):Sprite { return __instance.initFrameSet(xml) }
		static public function init(...rest:Array):XContext { return instance.init.apply(instance, [].concat(rest))}
		static public function get instance():XContext { return __instance || new XContext() }
		static public function get hasInstance():Boolean { return  Boolean(__instance as XContext) }
		
		public function get displayer():Sprite	{ return  __displayer}
		public function set displayer(value:Sprite):void	{ __displayer = value }
		public function get scheme():XML { return __scheme }
		public function set scheme(value:XML):void { __scheme = value }
	}
}