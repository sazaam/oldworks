package naja.model.control.context 
{
	import asSist.$;
	import asSist.as3Query;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import naja.model.control.resize.StageResizer;
	import naja.model.XDisplayer;
	import naja.model.Root;
	import naja.model.XData;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Context 
	{
//////////////////////////////////////////////////////// VARS
		private static var __displayer:XDisplayer ;
		private var __scheme:XML ;
		static public var __instance:Context;

//////////////////////////////////////////////////////// CTOR
		public function Context() 
		{
			__instance = this ;
		}
		public function init():Context
		{
			__displayer = new XDisplayer() ;
			return this ;
		}
		public function initStage(xml:XML):void
		{
			$get(__displayer.stage).attr(xml) ;
		}
		public function initFrameSet(xml:XML):Sprite
		{
			var frameset:XML = xml.*[0] ;
			return $get(frameset).appendTo(__displayer.target)[0] ;
		}
//////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get displayer():XDisplayer { return __displayer }		
		//static public function $type(o:*):Type
		//{ return new Type(o)}
		static public function $get(o:*):as3Query
		{ return $(o) as as3Query }
		static public function $query(...args:*):as3Query
		{ return as3Query.create.apply(as3Query, [].concat(args)) as as3Query}
		public function get displayer():XDisplayer
		{ return  __displayer }
		//static public function get resizer():StageResizer
		//{ return  StageResizer.instance }
		
		public function get scheme():XML { return __scheme }
		public function set scheme(value:XML):void 
		{ __scheme = value }
		
		static public function init():Context { return instance.init()}
		static public function get instance():Context { return __instance || new Context() }
		static public function get hasInstance():Boolean { return  Boolean(__instance) }
	}
}