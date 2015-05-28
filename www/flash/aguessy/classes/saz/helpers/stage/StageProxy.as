package saz.helpers.stage 
{
	import asSist.*;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author saz
	 */
	public class StageProxy 
	{
		private static var stageRectangle:Rectangle ;
		public static var stage:Stage ;
		public static var inited:Boolean ;
		public static function init(_stage:Stage):void
		{
			stage = _stage ;
			inited = true ;
		}
		public static function get stageRect():Rectangle
		{
			if (!stage is Stage) throw(new Error("StageProxy has not been inited", 1)) ;
			return new Rectangle(0,0,stage.stageWidth,stage.stageHeight) ;
		}
	}
}