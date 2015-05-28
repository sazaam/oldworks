package pro.exec 
{
	import pro.exec.events.ClickBehaviorEvent;
	import pro.exec.events.KeyBehaviorEvent;
	/**
	 * ...
	 * @author saz
	 */
	public class Behavior 
	{
		public static const DEFAULT:int  = -1 ;
		public static const DOUBLE:int  = 2 ;
		public static const ENTER:int  = 1 ;
		public static const ESCAPE:int  = 0 ;
		public static const PASS_DOWN:int  = 500 ;
		public static const PASS_UP:int  = -500 ;
		public static const PREV:int  = -5000 ;
		public static const NEXT:int  = 5000 ;
		public static const FOCUS_IN:int  = 50 ;
		public static const FOCUS_OUT:int  = -50 ;
		
		static public function getBehaviorCodeFromType(type:String):int
		{
			switch (type) 
			{
				case ClickBehaviorEvent.FOCUS_IN :
				case ClickBehaviorEvent.ROLL_INSIDE :
					return FOCUS_IN ;
				break ;
				case ClickBehaviorEvent.FOCUS_OUT :
				case ClickBehaviorEvent.ROLL_OUTSIDE :
					return FOCUS_OUT ;
				break ;
				case ClickBehaviorEvent.WHEEL_NEXT :
				case KeyBehaviorEvent.RIGHT :
					return NEXT ;
				break ;
				case ClickBehaviorEvent.WHEEL_PREV :
				case KeyBehaviorEvent.LEFT :
					return PREV ;
				break ;
				case KeyBehaviorEvent.UP :
					return PASS_UP ;
				break ;
				case KeyBehaviorEvent.ESCAPE :
					return ESCAPE ;
				break ;
				case KeyBehaviorEvent.DOWN :
					return PASS_DOWN ;
				break ;
				case KeyBehaviorEvent.ENTER :
				case ClickBehaviorEvent.CLICK :
					return ENTER ;
				break;
				case ClickBehaviorEvent.DOUBLE_CLICK :
					return DOUBLE ;
				break;
				default:
					return DEFAULT ;
				break;
			}
		}
		static public function getBehaviorTypeFromCode(code:int = -1):String
		{
			switch (code) 
			{
				case FOCUS_IN :
					return "focus_in" ;
				break ;
				case FOCUS_OUT :
					return 'focus_out' ;
				break ;
				case  PREV :
					return 'function prev' ;
				break ;
				case NEXT :
					return 'function next' ;
				break ;
				case ESCAPE :
					return 'function escape' ;
				break ;
				case ENTER :
					return 'function enter' ;
				break;
				case PASS_UP :
					return 'function passing up' ;
				break ;
				case PASS_DOWN :
					return 'function passing down' ;
				break ;
				case DOUBLE :
					return "function doubleClick" ;
				break;
				case DEFAULT :
					return 'default function' ;
				break;
			}
		}
	}
}