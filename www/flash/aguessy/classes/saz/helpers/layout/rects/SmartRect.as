package saz.helpers.layout.rects 
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author saz
	 */
	public class SmartRect extends EventDispatcher
	{
		public var target:DisplayObject;
		private var _scrollRecter:ScrollRecter;
		///////////////////////////////////////////////////////////GETTERS & SETTERS
		public function get scrollRect():ScrollRecter { return _scrollRecter; }
		public function set scrollRect(value:ScrollRecter):void 
		{_scrollRecter = value ;}
		public function set rect(value:Rectangle):void 
		{_scrollRecter.applyRect(value) ;}
		///////////////////////////////////////////////////////////CTOR
		public function SmartRect(_tg:DisplayObject,_rectangle:Rectangle = null) 
		{
			target = _tg ;
			_scrollRecter = new ScrollRecter(_tg,_rectangle) ;
		}
		///////////////////////////////////////////////////////////SCROLLRECT
		public function updateRect():void
		{applyRect() ;}
		public function applyRect(_rectangle:Rectangle = null):void
		{target.scrollRect = _rectangle || _scrollRecter.rectangle ;}		
		public function remove():void 
		{setNull() ;}
		private function setNull():void 
		{target.scrollRect = null ;}
	}
}