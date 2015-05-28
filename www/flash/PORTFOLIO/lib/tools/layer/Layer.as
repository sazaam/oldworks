package tools.layer 
{
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import tools.fl.sprites.Smart;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Layer extends Smart
	{
		private var __bgCol:uint;
		private var __bgAlph:Number;
		private var __dimensions:Rectangle;
		
		public function Layer(dimensions:Rectangle = null , backgroundColor:uint = 0xFFFFFF, backgroundAlpha:Number = .8 , props:Object = null) 
		{
			super(props) ;
			__dimensions = dimensions || new Rectangle(0, 0, 750, 550) ;
			__bgCol = backgroundColor ;
			__bgAlph = backgroundAlpha ;
			listen() ;
		}
		
		private function listen(cond:Boolean = true):void
		{
			if (cond) {
				addEventListener(Event.ADDED_TO_STAGE, onStage) ;
				addEventListener(Event.REMOVED_FROM_STAGE, onStage) ;
			}else {
				removeEventListener(Event.ADDED_TO_STAGE, onStage) ;
				removeEventListener(Event.REMOVED_FROM_STAGE, onStage) ;
			}
		}
		
		private function onStage(e:Event):void 
		{
			if (e.type == Event.ADDED_TO_STAGE) {
				properties.stage = stage ;
				properties.stage.addEventListener(Event.RESIZE, onStageResize) ;
				resize() ;
			}else {
				properties.stage.removeEventListener(Event.RESIZE, onStageResize) ;
			}
		}
		
		private function resize():void
		{
			var stW:int = properties.stage.stageWidth ;
			var stH:int = properties.stage.stageHeight ;
			draw() ;
			x =  stW / 2 - width / 2 ;
			y =  stH / 2 - height / 2 ;
		}
		
		public function draw():void 
		{
			var g:Graphics = graphics ;
			g.clear() ;
			g.beginFill(__bgCol, __bgAlph) ;
			g.drawRoundRect(__dimensions.x,__dimensions.y, __dimensions.width, __dimensions.height, 15, 15) ;
			g.endFill() ;
		}
		
		private function onStageResize(e:Event):void 
		{
			resize() ;
		}
		
		public function get backgroundColor():uint { return __bgCol }
		public function set backgroundColor(value:uint):void { __bgCol = value }
		public function get backgroundAlpha():Number { return __bgAlph}
		public function set backgroundAlpha(value:Number):void { __bgAlph = value }
	}
}