package console 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author saz
	 */
	public class ConsoleHandle 
	{
		private var __cg:ConsoleGraphics;
		private var __enabled:Boolean;
		
		public function ConsoleHandle(tg:Sprite) 
		{
			__cg = new ConsoleGraphics(tg) ;
			
			init() ;
		}
		
		private function init():void 
		{
			__cg.create() ;
			trace('console >>', __cg.console) ;
			trace('target >>', __cg.target) ;
			addEvents() ;
		}
		
		private function addEvents():void 
		{
			tg.addEventListener(Event.RESIZE, onResize) ;
			tg.addEventListener(KeyboardEvent.KEY_DOWN, onDown) ;
		}
		
		private function onDown(e:KeyboardEvent):void 
		{
			trace('Down')
		}
		
		private function onResize(e:Event):void 
		{
			trace('Resize')
		}
		
	}

}