package 
{
	import book.SAMUAE_BOOK;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			//trace(this);
			var samuaeBook:SAMUAE_BOOK = new SAMUAE_BOOK(this) ;
		}
		
	}
	
}