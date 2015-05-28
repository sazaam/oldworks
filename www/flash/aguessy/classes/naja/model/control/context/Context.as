package naja.model.control.context 
{
	import asSist.$;
	import asSist.as3Query;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import modules.foundation.Type;
	import naja.model.control.resize.StageResizer;
	import naja.model.XDisplayer;
	import naja.model.Root;
	import naja.model.XData;
	import saz.helpers.stage.StageProxy;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Context 
	{
//////////////////////////////////////////////////////// VARS
		private static var __displayer:XDisplayer ;
		private var __scheme:XML ;

//////////////////////////////////////////////////////// CTOR
		public function Context() 
		{
			trace("CTOR > " + this)
			__displayer = new XDisplayer() ;
		}
		
		public function initStage(xml:XML):void
		{
			$get(__displayer.stage).attr(xml) ;
		}
		
		public function initFrameSet(xml:XML):void
		{
			var frameset:XML = xml.*[0] ;
			$get(frameset).appendTo(__displayer.target) ;
		}
		
/////////////////////////////////////////////////////////////////////////////////////////////////EVENTS
		public function initEvents():void
		{
			//StageResizer.instance.init(_target.stage) ;
		}
/////////////////////////////////////////////////////////////////////////////////////////////////LINKS
		public function initLinks(links:XML):void
		{
			var data:XData = Root.user.model.data ;
			data.generate(links) ;
		}
//////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get displayer():XDisplayer { return __displayer }		
		static public function $type(o:*):Type
		{ return new Type(o)}
		static public function $get(o:*):as3Query
		{ return $(o) as as3Query }
		static public function $query(...args:*):as3Query
		{ return as3Query.create.apply(as3Query, [].concat(args)) as as3Query}
		public function get displayer():XDisplayer
		{ return  __displayer }
		//static public function get resizer():StageResizer
		//{ return  StageResizer.instance }
		
		public function get scheme():XML { return __scheme; }
		public function set scheme(value:XML):void 
		{ __scheme = value }
		
		
	}
}