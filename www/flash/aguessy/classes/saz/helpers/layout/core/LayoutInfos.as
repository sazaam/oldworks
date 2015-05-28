package saz.helpers.layout.core 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author saz
	 */
	public class LayoutInfos 
	{

		public static function getLayoutInfos(_elem:DisplayObject):LayoutInfos
		{
			if( _elem == _elem.stage) return new LayoutInfos(_elem.stage.stageWidth,_elem.stage.stageHeight) ;
			if( !_elem.scrollRect && _elem.parent == _elem.stage) return new LayoutInfos(_elem.stage.stageWidth,_elem.stage.stageHeight) ;
			
			var o:LayoutInfos = new LayoutInfos() ;
			o.width = _elem.scrollRect ? _elem.scrollRect.width : (_elem is Stage) ? Stage(_elem).stageWidth : _elem.width ;
			o.height =  _elem.scrollRect ? _elem.scrollRect.height : (_elem is Stage) ? Stage(_elem).stageHeight : _elem.height ;
			return o ;
		}
		public static function getLayoutRect(_elem:DisplayObject):Rectangle
		{
			var o:LayoutInfos = getLayoutInfos(_elem) ;
			var r:Rectangle = new Rectangle(0,0,o.width,o.height) ;
			return r ;
		}
		public static function getScrollRectAncestor(_elem:DisplayObject):DisplayObjectContainer
		{
			var p:DisplayObjectContainer = _elem.parent ;
			return p.scrollRect && p.parent.scrollRect ? getScrollRectAncestor(p) : p ;
		}
		
		public var width:int ;
		public var height:int ;
		public function LayoutInfos(_w:int = 0,_h:int = 0) 
		{
			width = _w ;
			height = _h ;
		}
		public function toString():String
		{
			return "[ width : "+width+" , height : "+height+" ]" ;
		}
	}
	
}