package saz.geeks.Mac.parts 
{
	import caurina.transitions.Tweener;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author saz
	 */
	public class MacStudio extends SectionManager
	{
		private var onInited:Function = function() {
			launch()
		}
		private var onKilled:Function = function() {
			trace(target)
		}
		public function MacStudio() 
		{
			onInit = onInited
			onKill = onKilled
		}
		private function launch():void
		{
			launchText("STUDIO")
		}
	}
	
}