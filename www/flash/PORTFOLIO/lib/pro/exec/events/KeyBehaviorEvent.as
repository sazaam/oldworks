package pro.exec.events 
{
	import flash.events.Event;
	import pro.exec.Behavior;
	
	/**
	 * ...
	 * @author saz
	 */
	public class KeyBehaviorEvent extends Event 
	{
		public static const UP:String = 'actionUp' ;
		public static const DOWN:String = 'actionDown' ;
		public static const LEFT:String = 'actionLeft' ;
		public static const RIGHT:String = 'actionRight' ;
		public static const ENTER:String = 'actionEnter' ;
		public static const ESCAPE:String = 'actionEscape' ;
		public static const ALL:String = 'actionAll' ;
		
		private var __keyCode:int;
		public function KeyBehaviorEvent(type:String, keyCode:int = -1, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable) ;
			if (type == KeyBehaviorEvent.ALL) {
				if(keyCode == -1) trace('default behavior will be chosen...', this)
				__keyCode = keyCode ;
			}else{
				__keyCode = Behavior.DEFAULT ;
			}
		} 
		
		public override function clone():Event 
		{ 
			return new KeyBehaviorEvent(type, __keyCode,  bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("KeyBehaviorEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get keyCode():int { return __keyCode }
	}
	
}