package saz.helpers.layout.layers 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import saz.helpers.layout.layers.I.ILayer;
	/**
	 * ...
	 * @author saz
	 */
	public class DefaultLayer extends Sprite
	{
		private var _content:DisplayObject;
		private var g:Graphics ;
		public var id:Object ;
		
		public function DefaultLayer(ref:Object,_tg:DisplayObject = null) 
		{
			id = ref ;
			addContent(_tg) ;
		}
/////////////////////////////////////////////////////////////////////////////////////////////////////HIDE & SHOW
		public function show(instantly:Boolean = true, transitionObj:Object = null) {
			if (instantly) {
				visible = true ;
			}else {
				
			}
		}
		public function hide(instantly:Boolean = true, transitionObj:Object = null) {
			if (instantly) {
				visible = false ;
			}else {
				
			}
		}
/////////////////////////////////////////////////////////////////////////////////////////////////////ADD & REMOVE
		public function addContent(_tg:DisplayObject = null):void
		{
			_content = _tg ? _tg : new Sprite() ; 
			_content.name = "content";
			_content = addChild(_content) ;
		}
/////////////////////////////////////////////////////////////////////////////////////////////////////GETTERS & SETTERS
		public function get content():DisplayObject { return _content; }
		
		public function set content(value:DisplayObject):void 
		{
			removeChild(_content) ;
			value.name = "content" ;
			_content = addChild(value) ;
		}
/////////////////////////////////////////////////////////////////////////////////////////////////////GRAPHIX
		public function fillRect(_color:uint = 0xFFFFFF,_alpha:Number = 0,_rect:Rectangle = null):void
		{
			g = graphics ;
			g.clear() ;
			g.beginFill(_color, _alpha) ;
			var rect:Rectangle = _rect? _rect : new Rectangle( 0,  0, stage.stageWidth , stage.stageHeight) ;
			
			g.drawRect(rect.x, rect.y, rect.width, rect.height) ;
			trace(rect)
			g.endFill() ;
		}
		public function clear():void
		{
			g.clear() ;
		}
	}
	
}