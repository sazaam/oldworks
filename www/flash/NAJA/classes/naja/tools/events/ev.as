package naja.tools.events 
{
	import flash.events.IEventDispatcher;
	public class ev{
		public function ev() {
			
		}
		static public function add(target:Object,t:String, f:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			if (IEventDispatcher(target)) {
				var tg:IEventDispatcher = IEventDispatcher(target) ;
				tg.addEventListener(t, f, useCapture, priority, useWeakReference) ;
			}
			else if(Object(target).hasOwnProperty("addEventListener")){
				target["addEventListener"](t, f, useCapture, priority, useWeakReference) ;
			}
		}
		static public function rem(target:Object, t:String, f:Function, useCapture:Boolean = false):void {
			if (IEventDispatcher(target)) {
				var tg:IEventDispatcher = IEventDispatcher(target) ;
				tg.removeEventListener(t, f , useCapture) ;
			}
			else if(Object(target).hasOwnProperty("removeEventListener")){
				target["removeEventListener"](t, f, useCapture) ;
			}
		}
		static public function has(target:Object,t:String):Boolean{
			return true ;
		}
		static public function trig(target:Object,type:String):Boolean{
			return true ;
		}
		
		static public const ACTIVATE:String = "activate" ;
		static public const ADDED:String = "added" ;
		static public const ADDED_TO_STAGE:String = "addedToStage" ;
		static public const CANCEL:String = "cancel" ;
		static public const CHANGE:String = "change" ;
		static public const CLEAR:String = "clear" ;
		static public const CLOSE:String = "close" ;
		static public const COMPLETE:String = "complete" ;
		static public const CONNECT:String = "connect" ;
		static public const COPY:String = "copy" ;
		static public const CUT:String = "cut" ;
		static public const DEACTIVATE:String = "deactivate" ;
		static public const ENTER_FRAME:String = "enterFrame" ;
		static public const EXIT_FRAME:String = "exitFrame" ;
		static public const FRAME_CONSTRUCTED:String = "frameConstructed" ;
		static public const FULLSCREEN:String = "fullscreen" ;
		static public const ID3:String = "id3" ;
		static public const INIT:String = "init" ;
		static public const MOUSE_LEAVE:String = "mouseLeave" ;
		static public const OPEN:String = "open" ;
		static public const PASTE:String = "paste" ;
		static public const REMOVED:String = "removed" ;
		static public const REMOVED_FROM_STAGE:String = "removedFromStage" ;
		static public const RENDER:String = "render" ;
		static public const RESIZE:String = "resize" ;
		static public const SAMPLE_DATA:String = "sampleData" ;
		static public const SCROLL:String = "scroll" ;
		static public const SELECT:String = "select" ;
		static public const SELECT_ALL:String = "selectAll" ;
		static public const SOUND_COMPLETE:String = "soundComplete" ;
		static public const TAB_CHILDREN_CHANGE:String = "tabChildrenChange" ;
		static public const TAB_ENABLED_CHANGE:String = "tabEnabledChange" ;
		static public const TAB_INDEX_CHANGE:String = "tabIndexChange" ;
		static public const UNLOAD:String = "unload" ;
		// MouseEvent
		static public const CLICK:String = "click" ;
		static public const DOUBLE_CLICK:String = "doubleClick" ;
		static public const MOUSE_DOWN:String = "mouseDown" ;
		static public const MOUSE_MOVE:String = "mouseMove" ;
		static public const MOUSE_OUT:String = "mouseOut" ;
		static public const MOUSE_OVER:String = "mouseOver" ;
		static public const MOUSE_UP:String = "mouseUp" ;
		static public const MOUSE_WHEEL:String = "mouseWheel" ;
		static public const ROLL_OUT:String = "rollOut" ;
		static public const ROLL_OVER:String = "rollOver" ;
		//ProgressEvent
		static public const PROGRESS:String = "progress" ;
		static public const SOCKET_DATA:String = "socketData" ;
		//LoadEvent
		public static const LOAD_COMPLETE:String = "loadComplete" ;
		public static const LOAD_OPEN:String = "loadOpen" ;
		//LoadProgressEvent
		public static const LOAD_PROGRESS:String = "loadProgress" ;
	}
}