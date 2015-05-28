package air.widgets.window 
{
	import air.widgets.BasicWidget;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LineScaleMode;
	import flash.display.NativeWindowResize;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.desktop.NativeApplication
	import flash.display.NativeWindow
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.events.NativeWindowDisplayStateEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author saz
	 */
	
	public class WidgetWindowSystem
	{
			//	init
				//	natives
		private var _widget:BasicWidget;
		private var target:Sprite;
		private var _nativeScreen:Screen;
		private var _nativeWindow:NativeWindow;
		private var _nativeApp:NativeApplication;
		private var _nativeStage:Stage;
		private var _activeWindow:NativeWindow;
				//	buttons
		private var icon:Sprite
		private var close:Sprite
		private var maxim:Sprite
		private var minim:Sprite
		private var restore:Sprite
		private var toolbar:Sprite
		private var status:Sprite
		private var resize:Sprite
		private var clips:Array;
		private var diffX:Array;
		private var diffY:Array;
				//	back
		private var cont:Sprite
		private var backCont:Sprite
		private var back:Sprite		

		
			//	func		
				//	dimensions
		private var lastWindowSize:Rectangle;
		private var contentScrollRect:Rectangle;

		private var _resizeType:String = "stretch";
		private var _allowOffset:Boolean = true;
		private var outOfBounds:Boolean = false;
				//	content
		private var _content:DisplayObject;
				//	intervals
		private var resizeTimeout:uint;
		private var updatedRectangle:Rectangle;
		private var contentRatio:Number;
		
		
		
		


		
		
		public function WidgetWindowSystem() 
		{
			
		}
		
		public function init(_basicWidget:BasicWidget,_tg:DisplayObjectContainer,_win:Sprite,_startRect:Rectangle = null):WidgetWindowSystem
		{
			_widget = _basicWidget
			_nativeApp = NativeApplication.nativeApplication
			_nativeScreen = Screen.mainScreen
			target = (!_win.parent)? _tg.addChild(_win) as Sprite : _win as Sprite ;
			
			_nativeWindow = target.stage.nativeWindow
			_nativeStage = _nativeWindow.stage
			
			
			
			//trace("Rectangle Dims : " + initDimensions)
			//trace(_nativeWindow.globalToScreen(new Point(_nativeStage.x, _nativeStage.stage.y)))
			
			enable()
			initDimensions(_startRect)
			return this
		}
		
		private function initDimensions(_startRect:Rectangle = null):void
		{
			if (_startRect)	display2Dimensions(_startRect)
			else {
				var defaultDimensions:Rectangle = new Rectangle( 0, 0, target.width, target.height)
				_nativeWindow.width = defaultDimensions.width
				_nativeWindow.height = defaultDimensions.height
			}
		}
		
		private function onBackResized(e:Event):void 
		{
			if (updatedRectangle)
			{
				_content.width = updatedRectangle.width
				_content.height = updatedRectangle.height
			}
			
			
		}
		
		public function display2Dimensions(_startRect:Rectangle):void
		{
			_nativeWindow.width = _startRect.width
			_nativeWindow.height = _startRect.height
			_nativeWindow.x = _startRect.x
			_nativeWindow.y = _startRect.y
			if(updatedRectangle) startResize()
		}
		
		private function cropCont():void
		{
			contentScrollRect = new Rectangle(0, 0, lastWindowSize.width-4, lastWindowSize.height-47)
			backCont.width = contentScrollRect.width
			backCont.height = contentScrollRect.height
			cont.scrollRect = contentScrollRect

			switch(_resizeType) {
				case 'stretch':
					updatedRectangle = new Rectangle(0, 0, contentScrollRect.width, contentScrollRect.height)
				break;
				case 'crop':
					//updatedRectangle = new Rectangle(0, 0, _content.width, _content.height)
				break;
				case 'ratio':
					var w:int, h:int;
					w = contentScrollRect.width
					h = contentScrollRect.height
					updatedRectangle = new Rectangle(0, 0, w, w*contentRatio/100)
				break;
				case 'resizeStage':
					//updatedRectangle = new Rectangle(0,0,lastWindowSize.width-4,lastWindowSize.height-47)
					return
				break;
				case 'none':
				default:
				
				break;
			}
		}
		
		private function enable():void
		{
			registerButtons()
			
			enableMinimize()
			enableMaximize()
			enableResize()
			enableMove()
			enableClick()
		}
		
		private function registerButtons():void
		{
			close = target.getChildByName('close_win') as Sprite
			maxim = target.getChildByName('maxim_win') as Sprite
			minim = target.getChildByName('minim_win') as Sprite
			restore = target.getChildByName('restore_win') as Sprite
			resize = target.getChildByName('resize_win') as Sprite
			back = target.getChildByName('back_win') as Sprite
			cont = target.getChildByName('cont_win') as Sprite
			backCont = cont.getChildByName('back') as Sprite
			
			clips = [close, maxim, minim, restore, resize]
			diffX = [back.width - close.x, back.width - maxim.x, back.width - minim.x, back.width - restore.x, back.width - resize.x]
			diffY = [back.height - resize.y]
			
			lastWindowSize = _nativeWindow.bounds
		}
		
		private function enableClick():void
		{
			target.stage.addEventListener(MouseEvent.MOUSE_DOWN ,onWindowClick)
			target.stage.addEventListener(MouseEvent.MOUSE_UP ,onWindowClick)
		}
		
		private function onWindowClick(e:MouseEvent):void 
		{
			switch(e.target.name) {
				case 'close_win':
					_widget.quit()
				break;
				case 'maxim_win':
					_widget.maximize()
				break;
				case 'minim_win':
					_widget.minimize()
				break;
				case 'restore_win':
					_widget.restore()
				break;
				case 'resize_win':
					if (e.type == MouseEvent.MOUSE_DOWN) 
						_nativeWindow.startResize()
					else{cropCont()}
				break;
				case 'back_win':
				case 'content_win':
					if(e.type == MouseEvent.MOUSE_DOWN) _nativeWindow.startMove()
				break;
				case 'content':
					
				break;
			}
		}
		
		private function enableMove():void
		{
			//
		}
		
		private function enableMinimize():void
		{
			//
		}
		
		private function enableMaximize():void
		{
			//
		}
		
		private function enableResize():void
		{
			_nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZING, onWindowResize)
			_nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, onWindowResize)
			_nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, onWindowResize)
			_nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, onWindowResize)
			_nativeWindow.addEventListener(Event.ACTIVATE, onWindowActivate)
		}
		
		private function onWindowActivate(e:Event):void 
		{
			_nativeWindow.alwaysInFront = true
			_nativeWindow.orderToFront()
			_nativeWindow.alwaysInFront = false
		}
		
		private function onWindowResize(e:Event):void 
		{
			resizeTimeout = setTimeout(startResize, 15)
		}
		
		private function startResize():void
		{
			for (var i:int = 0,l:int = clips.length; i < l ; i++ )
				reposWinButtons(clips[i], i, l)
		}
		
		private function reposWinButtons(_btn:Sprite,_i:int,_l:int):void
		{
			if(_i == 0) resizeWinBack()
			var distX:int = back.width - diffX[_i] 
			var distY:int = back.height - diffY[0]
			switch(_btn.name) {
				case 'close_win':
				case 'maxim_win':
				case 'minim_win':
				case 'restore_win':
					_btn.x = distX
				break;
				case 'resize_win':
					_btn.x = distX
					_btn.y = distY
				break;
			}
			
		}
		
		private function resizeWinBack():void
		{
			
			back.width = int(lastWindowSize.width)
			back.height = int(lastWindowSize.height)
			lastWindowSize = _nativeWindow.bounds
			cropCont()
			backCont.dispatchEvent(new Event(Event.RESIZE))
			if (_content) {
				_content.stage.dispatchEvent(new Event(Event.RESIZE))
			}
		}
		
		
		
		public function get activeWindow():NativeWindow { return _activeWindow; }
		public function set activeWindow(value:NativeWindow):void { _activeWindow = value; }
		public function get content():DisplayObject { return _content; }
		public function set content(value:DisplayObject):void {
			if (value == null  && _content != null) {
				_content.parent.removeChild(_content)
				backCont.removeEventListener(Event.RESIZE, onBackResized)
				return
			}
			if (value == _content) return
			if(_content) cont.removeChildAt(cont.getChildIndex(_content))
			
			_content = cont.addChild(value)
			contentRatio = _content.height*100/_content.width
			backCont.addEventListener(Event.RESIZE, onBackResized)
			startResize()
		}
		public function get resizeType():String { return _resizeType; }
		public function set resizeType(value:String):void { _resizeType = value; }
		public function get allowOffset():Boolean { return _allowOffset; }
		public function set allowOffset(value:Boolean):void { _allowOffset = value; }
	}
	
}