package pro 
{
	import of.app.Root;
	import of.app.XCustom ;
	import pro.graphics.CustomLoaderGraphics;
	import pro.exec.steps.AboutStep;
	import pro.exec.steps.ContactStep;
	import pro.exec.steps.HomeStep;
	import pro.exec.steps.ProjectStep;
	import pro.exec.steps.WorksInsideStep;
	import pro.exec.steps.WorksStep;
	/**
	 * ...
	 * @author saz
	 */
	public class Custom extends XCustom
	{
		
		public function Custom() 
		{
			super() ;
			generateParams(DEFAULT_PARAMS) ;
			generateRequired(Unique, CustomLoaderGraphics) ;
			
			generateRestIfThereIs() ;
		}
		
		private function generateRestIfThereIs():void
		{
			// here the rest of generation of Classes...
			Root.root.focusRect = false ;
			
			
			// IMPORTANT for referenciation in ApplicationDomain.loaderInfo
			HomeStep;
			WorksStep;
			WorksInsideStep;
			ProjectStep;
			AboutStep;
			ContactStep;
		}
	}
}