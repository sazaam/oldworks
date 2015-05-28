package testing 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import of.app.required.loading.XLoader;
	import of.app.required.loading.LoadingsController;
	//import of.app.XParams;
	
	/**
	 * ...
	 * @author saz
	 */
	public class TestNoZip extends Sprite 
	{
		
		public function TestNoZip() 
		{
			init() ;
		}
		
		private function init():void 
		{
			var loader:XLoader = new XLoader() ;
			//var loader:Loader = new Loader() ;
			trace(LoadingsController) ;
			trace('ok') ;
		}
	}
}