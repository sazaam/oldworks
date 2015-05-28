package saz.geeks.Mac.parts 
{
	import f6.helpers.essentials.collections.SpriteCollection;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Parts extends SpriteCollection
	{
		private var part				:Part
		
		public function Parts() 
		{
			trace("PARTS LOADED...")
		}
		
		public function addPart(_part:Part):void
		{
			part = _part
			add(_part)
		}
		public function loadBackground():void
		{
			part.init()
			enable()
		}
		public function removePart():void
		{
			disable()
		}
		
		private function enable():void
		{
			part.addEventListener(Event.RESIZE,part.onPartResize)
		}
		
		private function disable():void
		{
			part.clean()
			part.removeEventListener(Event.RESIZE, part.onPartResize)
			removeAll(this)
			//part = null
		}
	}
}