package saz.helpers.layout.layers 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import saz.helpers.layout.layers.I.ILayer;

	
	/**
	 * ...
	 * @author saz
	 */
	public class BackgroundLayer extends DefaultLayer implements ILayer
	{
		private var backgroundAlpha:Number;
		private var backgroundColor:uint;
		private var backgroundRect:Rectangle;
		public function BackgroundLayer(_color:uint = 0, _alpha:Number = 1, _rect:Rectangle = null,content:DisplayObject = null) 
		{
			super("backgroundLayer", content) ;
			backgroundColor = _color ;
			backgroundAlpha = _alpha ;
			backgroundRect = _rect;
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
		}
		public function onStage(e:Event):void 
		{
			removeEventListener(e.type, arguments.callee ) ;
			fillRect(backgroundColor,backgroundAlpha,backgroundRect) ;
			stage.addEventListener(Event.RESIZE, onResize ) ;
			addEventListener(Event.REMOVED_FROM_STAGE, function(e:Event):void
			{
				stage.removeEventListener(Event.RESIZE, onResize ) ;
				Layer(e.currentTarget).removeEventListener(e.type, arguments.callee) ;
				Layer(e.currentTarget).addEventListener(Event.ADDED_TO_STAGE , onStage) ;
			})
		}
		
		private function onResize(e:Event):void 
		{
			fillRect(backgroundColor,backgroundAlpha,backgroundRect) ;
		}
	}
}