package testing 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import of.app.required.resize.StageResize;
	/**
	 * ...
	 * @author saz
	 */
	public class TestFrame 
	{
		private var __target:Sprite;
		private var __controller:SazController;
		
		
		public function TestFrame(tg:Sprite) 
		{
			__target = tg ;
			__controller = new SazController() ;
			
			setup() ;
		}
		
		private function setup():void 
		{
			__controller.addEventListener(Event.INIT, onInit) ;
			__controller.init(new SazModel(), new SazViewPort(), __target) ;
		}
		
		private function onInit(e:Event):void 
		{
			trace('yes', e)
		}
	}
}