package charts 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author saz
	 */
	

	public class ChartsManager {
		private var __view:ChartsView;
		public function ChartsManager() 
		{
			
		}
		public function init(target:Sprite, dimensions:Rectangle = null):ChartsManager 
		{
			__view = new ChartsView().init(this, target, dimensions) ; 
			return this ;
		}
		
		public function createUpon(datas:XML, cond:Boolean = true):void 
		{
			if (cond) {
				trace(datas) ;
				__view.addChart([]) ;
			}else {
				__view.addChart([], false) ;
			}
		}
		
		/////////// GS
		public function get view():ChartsView { return __view }
	}
}