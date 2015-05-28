package charts 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author saz
	 */
	public class ChartsView {
		private var __viewport:Sprite;
		private var __manager:ChartsManager;
		private var __canvas:F5ChartsHandler;
		public function ChartsView() 
		{
			
		}
		
		public function init(manager:ChartsManager, target:Sprite, dimensions:Rectangle = null):ChartsView 
		{
			__manager = manager ;
			__viewport = target ;
			__canvas = new F5ChartsHandler(dimensions) ;
			
			return this ;
		}
		
		public function addChart(p:Array = null, cond:Boolean = true):void 
		{
			if (cond) {
				__viewport.addChild(canvas.createChart(p)) ;
			}else {
				__viewport.removeChild(canvas.createChart(null,  false)) ;
			}
		}
		
		/////////// GS
		public function get viewport():Sprite { return __viewport }
		public function set viewport(value:Sprite):void { __viewport = value }
		public function get canvas():F5ChartsHandler { return __canvas }
		public function set canvas(value:F5ChartsHandler):void { __canvas = value }
	}

}