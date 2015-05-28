package naja.model 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.text.TextField;
	import naja.model.control.context.Context;
	
	/**
	 * ...
	 * @author saz
	 */
	public class XDisplayer 
	{
//////////////////////////////////////////////////////// VARS
		private var __target:DisplayObjectContainer ;
		private var __stage:Stage ;
		private var __debug:TextField ;
		
//////////////////////////////////////////////////////// CTOR
		public function XDisplayer() 
		{
			trace("CTOR > " + this)
			__target = DisplayObjectContainer(Root.root) ;
			__stage = __target.stage ;
		}
		
		public function initDebug(xml:XML):TextField
		{
			__debug = TextField(Context.$get(xml.*[0]).appendTo(__target)[0]) ;
			return __debug ;
		}
		
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get target():DisplayObjectContainer { return __target }
		public function get stage():Stage { return __stage }
		
		public function get debug():TextField { return __debug }
		public function set debug(_debug:TextField):void
		{ __debug = _debug }
	}
}