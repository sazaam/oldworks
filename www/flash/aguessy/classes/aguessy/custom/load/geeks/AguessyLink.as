package aguessy.custom.load.geeks 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import naja.model.Root;
	import naja.model.XUser;
	
	/**
	 * ...
	 * @author saz
	 */
	public class AguessyLink extends Sprite
	{
		private var __width:Number;
		private var __height:Number;
		private var user:XUser;
		private var __fill:Object;
		private var __alpha:Number;
		private var __arrowFill:uint;
		//////////////////////////////////////////////////////// CTOR
		public function AguessyLink() 
		{
			super() ;
			user = Root.user ;
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
		}
		///////////////////////////////////////////////////////////////////////////////// INIT, ONSTAGE & DRAW
		public function init(tf:TextField):void
		{
			__width = tf.width + 10;
			var l:int = tf.numLines ;
			var min:Number = 19 ;
			__height = l==1 ? min : 19+((l-1)*10);
			x = tf.x - 2 ;
			y = tf.y - 2 ;
		}
		
		private function onStage(e:Event):void 
		{
			if (e.type == Event.ADDED_TO_STAGE) {
				removeEventListener(Event.ADDED_TO_STAGE,arguments.callee) ;
				addEventListener(Event.REMOVED_FROM_STAGE,arguments.callee) ;
				draw() ;
			}else {
				removeEventListener(Event.REMOVED_FROM_STAGE,arguments.callee) ;
				addEventListener(Event.ADDED_TO_STAGE,arguments.callee) ;
				draw(false) ;
			}
		}
		
		private function draw(cond:Boolean = true):void
		{
			var g:Graphics = graphics, p:Graphics ; 
			var sh:Shape ;
			if (cond) {
				if (!__fill || __fill == null) {
					g.beginBitmapFill(Root.user.model.data.objects["motif"], null, true, true) ;
				}
				
				else if (__fill is uint) {
					g.beginFill(uint(__fill),__alpha || 1) ;
				}
				g.drawRect(0, 0, __width, __height) ;
				g.endFill() ;
				sh = new Shape() ;
				p = sh.graphics ;
				p.beginFill(__arrowFill || 0xFFFFFF,.3) ;
				p.moveTo(0,3) ;
				p.lineTo(3,3) ;
				p.lineTo(3,0) ;
				p.lineTo(10,6) ;
				p.lineTo(3,12) ;
				p.lineTo(3,9) ;
				p.lineTo(0,9) ;
				p.endFill() ;
				sh.x = __width - sh.width - 2 ;
				sh.y = 2 ;
				addChild(sh) ;
			}else {
				removeChildAt(0)
				g.clear() ;
			}
		}
		///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get fill():Object { return __fill; }
		public function set fill(value:Object):void 
		{
			__fill = value;
		}
		public function get alph():Number { return __alpha; }
		public function set alph(value:Number):void 
		{
			__alpha = value;
		}
		public function get arrowFill():uint { return __arrowFill; }
		public function set arrowFill(value:uint):void 
		{
			__arrowFill = value;
		}
	}
}