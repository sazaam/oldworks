package pro.layer 
{
	import flash.events.Event;
	import tools.fl.sprites.Smart;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Layer extends Smart
	{
		
		public function Layer(props:Object = null) 
		{
			super(props) ;
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
			x =  stW / 2 - width / 2 ;
			y =  stH / 2 - height / 2 ;
		}
		
		private function onStageResize(e:Event):void 
		{
			resize() ;
		}
	}
}