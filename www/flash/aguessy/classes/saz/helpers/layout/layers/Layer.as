package saz.helpers.layout.layers 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import saz.helpers.layout.layers.I.ILayer;

	
	/**
	 * ...
	 * @author saz
	 */
	public class Layer extends DefaultLayer implements ILayer
	{
		public function Layer(ref:Object,tg:DisplayObject = null) 
		{
			super(ref, tg) ;
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
		}
		public function onStage(e:Event):void 
		{
			//removeEventListener(e.type, arguments.callee ) ;
			fillRect() ;
			//stage.addEventListener(Event.RESIZE, onResize ) ;
			//addEventListener(Event.REMOVED_FROM_STAGE, function(e:Event):void
			//{
				//stage.removeEventListener(Event.RESIZE, onResize ) ;
				//Layer(e.currentTarget).removeEventListener(e.type, arguments.callee) ;
				//Layer(e.currentTarget).addEventListener(Event.ADDED_TO_STAGE , onStage) ;
			//}) ;
		}
		
		private function onResize(e:Event):void 
		{
			//fillRect() ;
		}
	}
}