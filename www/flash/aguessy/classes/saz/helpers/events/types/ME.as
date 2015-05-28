package saz.helpers.events.types 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	public class ME {
		
		static public function click(bubbles:Boolean = false, cancelable:Boolean = false):MouseEvent
		{
			return MouseEvent($E(MouseEvent.CLICK,bubbles, cancelable)) ;
		}
		static public function $E(type:String, bubbles:Boolean = false, cancelable:Boolean = false):Event 
		{
			return new Event(type,bubbles,cancelable) ;
		}
	}
}