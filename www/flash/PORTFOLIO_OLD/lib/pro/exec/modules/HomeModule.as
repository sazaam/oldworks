package pro.exec.modules 
{
	import pro.exec.ExecuteController;
	import pro.steps.HomeStep;
	/**
	 * ...
	 * @author saz
	 */
	public class HomeModule 
	{
		private var __controller:ExecuteController;
		
		public function HomeModule() 
		{
			__controller = ExecuteController.instance ;
		}
		
		public function launch(step:HomeStep, cond:Boolean = true):void 
		{
			//check(step) ;
			__controller.home(step, cond) ;
		}
	}
}