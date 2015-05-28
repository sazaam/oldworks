package sketchbook.template
{
	import flash.display.Sprite;
	import sketchbook.SketchBook;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import sketchbook.display.SpriteHelper;

	public class ProjectTemplate extends Sprite
	{
		public var helper:SpriteHelper
		private var __mousePressed:Boolean = false
		
		public function ProjectTemplate()
		{
			init();
			reset();
		}
		
		//一番最初の初期化の処理、リセットするたびに行う初期化はresetないで行う
		protected function init():void
		{
			SketchBook.init(stage)
			SketchBook.topLeft()
			SketchBook.noScale()
			stage.addEventListener(Event.ENTER_FRAME, __enterFrameHandler)
			stage.addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler)
			stage.addEventListener(MouseEvent.MOUSE_UP, __mouseUpHandler)
			stage.addEventListener(Event.RESIZE, __resizedHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, __keyDownHandler)
			stage.addEventListener(KeyboardEvent.KEY_UP, __keyUpHandler)
			
			helper = new SpriteHelper(this)
		}
		
		//リサイズ等で、再度やり直す場合の処理
		public function reset():void
		{
			endUp()
		}
		
		//リセット・終了前の片付け
		public function endUp():void
		{
		}
		
		public function onEnterFrame():void
		{
			
		}
		
		public function onMouseDown():void
		{
			
		}
		
		public function onMouseUp():void
		{
			
		}
		
		public function onKeyDown(charCode:Number):void
		{
			
		}
		
		public function onKeyUp():void
		{
			
		}
		
		
		protected function __enterFrameHandler(e:Event):void
		{
			onEnterFrame()
		}
		
		protected function __mouseDownHandler(e:Event):void
		{
			__mousePressed = true
			onMouseDown()
		}
		
		protected function __mouseUpHandler(e:Event):void
		{
			__mousePressed = true
			onMouseUp()
		}
		
		protected function __resizedHandler(e:Event):void
		{
			reset()
		}
		
		protected function __keyDownHandler(e:KeyboardEvent):void
		{
			onKeyDown(e.charCode)
		}
		
		protected function __keyUpHandler(e:KeyboardEvent):void
		{
			onKeyUp()
		}
	}
}