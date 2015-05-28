package pro 
{
	import of.app.Root;
	import of.app.XCustom ;
	import pro.graphics.SazLoaderGraphics;
	/**
	 * ...
	 * @author saz-ornorm
	 */
	public class Custom extends XCustom
	{
		
		public function Custom() 
		{
			super() ;
			generateParams(DEFAULT_PARAMS) ;
			generateRequired(Unique, SazLoaderGraphics) ;
			
			generateRestIfThereIs() ;
		}
		
		private function generateRestIfThereIs():void
		{
			// here the rest of generation of Classes...
			Root.root.focusRect = false ;
			
		}
	}
}