package of.app.required.resize 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author saz
	 */
	public class StageProxy 
	{
		public static var stage:Stage ;
		public static var inited:Boolean ;
		public static var stageDims:Point;
		public static function init(_stage:Stage):Point
		{
			stage = _stage ;
			setStageDims() ;
			stage.addEventListener(Event.RESIZE, onStageResize)
			inited = true ;
			return stageDims ;
		}
		
		static private function setStageDims():void
		{
			stageDims = new Point(stage.stageWidth, stage.stageHeight) ;
		}
		
		static private function onStageResize(e:Event):void 
		{
			setStageDims() ;
		}
		
		public static function get stageRect():Rectangle
		{
			if (!stage is Stage) throw(new Error("StageProxy has not been inited", 1)) ;
			return new Rectangle(0,0,stage.stageWidth,stage.stageHeight) ;
		}
	}
}