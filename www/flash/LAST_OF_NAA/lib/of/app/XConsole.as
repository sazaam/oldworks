package of.app 
{
	/**
	 * ...
	 * @author saz
	 */
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import of.app.required.context.XContext;
	import tools.grafix.Draw;

	public class XConsole {
		// REQUIRED
		static private var __instance:XConsole ;
		//////////////////////////////////////// VARS
		private var __debug_tf:TextField ;
		//////////////////////////////////////// CTOR
		public function XConsole () 
		{
			__instance = this ;
		}
		//////////////////////////////////////// INIT
		public function init():XConsole 
		{
			
			// Debug TextField
			__target = XUser.target ;
			__debug_tf = XContext.$get(TextField).attr( {
				id : 'debug_TF', 
				name : 'debug_TF',
				width : __target.stage.stageWidth,
				height : __target.stage.stageHeight * .5,
				wordWrap :  true 
			}).appendTo(__target)[0] ;
			
			trace(this, 'inited...') ;
			log("Console inited...") ;
			return this ;
		}
		
		public function upgrade():void
		{
			var panel:Sprite = XContext.$get('#console')[0] ;
			if(!Boolean(panel)) panel = XContext.$get(Sprite).attr({id:'console', name:'console'})[0] ;
			Draw.draw('rect', {g:panel.graphics, color:0x1b1b1b, alpha: .9}, 0, 0, __target.stage.stageWidth , __target.stage.stageHeight *.5)
			
			__debug_tf = XContext.$get('#debug_TF').remove()[0] ;
			var fmt:* = __debug_tf.getTextFormat() ;
			fmt.color =  0xFFFFFF ;
			__debug_tf.setTextFormat(fmt) ;
			
			XContext.$get('#console').append(__debug_tf).hide().appendTo(__target)
			XContext.displayer.stage.addEventListener(KeyboardEvent.KEY_DOWN, onDown) ;
			
			trace('console upgraded !!')
		}
		
		private function onDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == 32 && e.shiftKey)
			XContext.$get('#console').toggle() ;
		}
		//////////////////////////////////////// LOG
		public function log(...rest:Array):XConsole 
		{
			var str:String = '', l:int = rest.length ;
			for (var i:int = 0 ; i < l ; i++ ) {
				str += String(rest[i]) + ' ' ;
			}
			__debug_tf.appendText('\n' + str) ;
			
			var fmt:* = __debug_tf.getTextFormat() ;
			fmt.font =  'Arial' ;
			fmt.leftMargin = fmt.rightMargin = 15 ;
			fmt.size =  10 ;
			__debug_tf.setTextFormat(fmt) ;
			return this ;
		}
		//////////////////////////////////////// DUMP
		public function dump(o:Object, recursive:Boolean = false):XConsole
		{
			var str:String = '' ;
			for (var i:String in o) {
				var obj:Object = o[i] ;
				str += '\n' + i + ' >> ' + String(obj) ;
				if (recursive) str += arguments.callee(obj, recursive) ;
			}
			
			return log(str) ;
		}
		///////////////////////////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		static public function get TF():TextField { return __instance.TF }
		static public function set TF(value:TextField):void { __instance.TF = value }
		static public function log(...rest:Array):XConsole { return __instance.log.apply(__instance, [].concat(rest)) }
		static public function dump(o:Object, recursive:Boolean = false):XConsole { return __instance.dump(o, recursive) }
		static public function init():XConsole { return instance.init() }
		static public function get hasInstance():Boolean { return Boolean(__instance as XConsole) }
		static public function get instance():XConsole { return hasInstance? __instance :  new XConsole() }
		
		public function get TF():TextField { return __debug_tf }
		public function set TF(value:TextField):void { __debug_tf = value }
	}
}