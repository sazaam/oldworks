package pro 
{
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import of.app.Root;
	/**
	 * ...
	 * @author saz-ornorm
	 */
	public class Main extends Root
	{
		public function Main() 
		{
			super() ;
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
			addEventListener(DataEvent.DATA, onData) ;
			trace(this, 'inited') ;
		}
		
		private function onStage(e:Event):void 
		{
			removeEventListener(e.type, arguments.callee);
			
			user.setup(Custom) ;
			//user.setup() ;
			user.build() ;
		}
		
		private function onData(e:DataEvent):void 
		{
			removeEventListener(e.type, arguments.callee) ;
			user.startApp() ;
		}
	}
}