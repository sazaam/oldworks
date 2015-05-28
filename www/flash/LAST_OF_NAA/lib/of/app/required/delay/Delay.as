package of.app.required.delay 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Delay 
	{
		static private var __timer:Timer;
		static private var __timerFunc:Function;
		static private var __timerTime:Number;
		
		static public function make(time:Number, thisObj:*,  closure:Function , ...params:Array ):Class 
		{
			var t:Timer , tbis:Timer ;
			if (__timer as Timer) {
				__timerFunc = function(e:TimerEvent):void {
					e.currentTarget.removeEventListener(e.type, arguments.callee) ;
					__timerTime = time + __timerTime ;
					t = __timer = new Timer(__timerTime) ;
					__timerFunc = function(e:TimerEvent):void {
						e.currentTarget.removeEventListener(e.type, arguments.callee) ;
						closure.apply(thisObj, [].concat(params)) ;
						__timer = null ;
						__timerFunc = null ;
					}
					t.addEventListener(TimerEvent.TIMER, __timerFunc ) ;
					t.start() ;
				} ;
				__timer.addEventListener(TimerEvent.TIMER, __timerFunc) ;
			}else {
				__timerTime = time ;
				t = __timer = new Timer(time) ;
				__timerFunc = function(e:TimerEvent):void {
					e.currentTarget.removeEventListener(e.type, arguments.callee) ;
					closure.apply(thisObj, [].concat(params)) ;
					__timer = null ;
					__timerFunc = null ;
				} ;
				t.addEventListener(TimerEvent.TIMER, __timerFunc) ;
				t.start() ;
			}
			
			return Delay ;
		}
		
		static public function get isTiming():Boolean {
			return Boolean(__timer as Timer) ;
		}
		
		static public function cancel():void {
			__timer.removeEventListener(TimerEvent.TIMER, __timerFunc) ;
			__timer = null ;
			__timerFunc = null ;
		}
	}
}