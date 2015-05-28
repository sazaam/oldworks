package saz.geeks.Mac.parts 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author saz
	 */
	public class MacMusic extends SectionManager
	{
		private var onInited:Function = function() {
			//trace("YOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO ")
		}
		private var onKilled:Function = function() {
			trace(target)
		}
		
		public function MacMusic() 
		{
			onInit = onInited
			onKill = onKilled
		}
		
	}
	
}