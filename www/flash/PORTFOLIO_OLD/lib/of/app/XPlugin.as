package of.app 
{
	import adobe.utils.CustomActions;
	import flash.events.EventDispatcher;
	import of.app.required.steps.I.IStep;
	import of.app.required.steps.VirtualSteps;
	
	/**
	 * ...
	 * @author saz
	 */
	public class XPlugin extends EventDispatcher 
	{
		
		public function XPlugin() 
		{
			__step = new VirtualSteps('PORITIT') ;
		}
		public function get plug():Function 
		{
			return __xF;
		}
		public function get step():IStep 
		{
			return __step;
		}
		public function set plug(value:Function):void 
		{
			__xF = function(step:IStep) : Function {
				trace('XF >>>>', __step)
				return xPlug(step, value) ;
			}
		}

		protected function xPlug(step : IStep, f : Function):Function
		{
			trace('XPlug>>>>', __step)
			__step = step ;
			return f;
			
		}
		
		private var __plug : Function;
		private var __close : Function;
		private var __open : Function;
		private var __release : Function;
		private var __notify : Function;
		private var __step : IStep;
		private var __xF : Function;
	}

}
		/*
		public function get close():Function 
		{
			return __close;
		}
		
		public function set close(value:Function):void 
		{
			__close = value;
		}
		
		public function get release():Function 
		{
			return __release;
		}
		
		public function set release(value:Function):void 
		{
			__release = value;
		}
		
		public function get notify():Function 
		{
			return __notify;
		}
		
		public function set notify(value:Function):void 
		{
			__notify = value;
		}
		
		public function get open():Function 
		{
			return __open;
		}
		
		public function set open(value:Function):void 
		{
			__open = value;
		}
		*/