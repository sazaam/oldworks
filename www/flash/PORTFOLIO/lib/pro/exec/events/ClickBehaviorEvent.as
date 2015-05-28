package pro.exec.events 
{
	import flash.events.Event;
	import pro.exec.Behavior;
	/**
	 * ...
	 * @author saz
	 */
	public class ClickBehaviorEvent extends Event
	{
		static public const FOCUS_IN:String = "focusIsIn";
		static public const FOCUS_OUT:String = "focusIsOut";
		public static const MOUSE_INSIDE:String = "mouseIsOver";
		public static const MOUSE_OUTSIDE:String = "mouseIsOut";
		public static const ROLL_INSIDE:String = "rollIsOver";
		public static const ROLL_OUTSIDE:String = "rollIsOut";
		public static const MOUSE_UP:String = 'mouseIsDown' ;
		public static const MOUSE_DOWN:String = 'mouseIsUp' ;
		public static const CLICK:String = 'mouseIsClicked' ;
		public static const DOUBLE_CLICK:String = 'mouseIsDouble' ;
		public static const WHEEL_NEXT:String = 'wheelToNext' ;
		public static const WHEEL_PREV:String = 'wheelToPrev' ;
		public static const ALL:String = 'AllEnabled' ;
		
		private var __clickCode:int;
		public function ClickBehaviorEvent(type:String, clickCode:int = -1, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable) ;
			if (type == ClickBehaviorEvent.ALL) {
				if(clickCode == -1) trace('default behavior will be chosen...', this)
				__clickCode = clickCode ;
			}else{
				__clickCode = Behavior.DEFAULT ;
			}
		} 
		
		public override function clone():Event 
		{ 
			return new ClickBehaviorEvent(type, __clickCode, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("KeyBehaviorEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get clickCode():int { return __clickCode }
	}

}