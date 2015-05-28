package air.widgets 
{
	/**
	* ...
	* @author Biendo Aimé
	*/
	import air.widgets.window.WidgetWindowSystem;
	import air.widgets.XUpdater
	import flash.display.*;
	import flash.desktop.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;

	import flash.utils.*;
	import flash.html.*;
	import flash.events.*;
	import flash.errors.*;
	import caurina.transitions.Tweener

	public class BasicWidget {

		private var corewindow:NativeWindow;
		private var _window:NativeWindow;
		
		private var originalHeight:Number;
		private var target:DisplayObjectContainer;
		
		private var options:NativeWindowInitOptions;
		private var optMenu:NativeMenu;
		private var iconIndex:int = 0;
		private var icons:Array;
		
		
		//utils
		private var _nativeSystemChrome:String = NativeWindowSystemChrome.NONE
		private var _nativeWindowTransparency:Boolean = true
		private var _nativeWindowMaximizable:Boolean = true
		private var _nativeWindowMinimizable:Boolean = true
		private var _nativeWindowResizable:Boolean = true
		private var _nativeWindowType:String = NativeWindowType.UTILITY
		private var _nativeWindowResize:String = NativeWindowResize.NONE
		private var _nativeWindowDisplayState:String = NativeWindowDisplayState.NORMAL
		private var _nativeWindowInitOptions:NativeWindowInitOptions
		private var _hideWindowInTaskBar:Boolean = false
		private var _centered:Boolean = false
		private var WidgetWin1:WidgetWindowSystem;
		
		public function BasicWidget() {
			
		}
		
		public function init(_tg:DisplayObjectContainer):BasicWidget
		{
			target = _tg as DisplayObjectContainer
			
			target.stage.scaleMode = StageScaleMode.NO_SCALE;
			target.stage.align = StageAlign.TOP_LEFT;
			launchTween()
			
			var u:XUpdater = new XUpdater();
			u.checkForUpdate();
			
			return airInit();
		}

		/**
		* Initialisation Air
		*/
		
		private function airInit():BasicWidget
		{
			try { NativeApplication.nativeApplication.startAtLogin = true; } catch (e:IllegalOperationError) 
			{
				//throw(new Error('AIR INITING GOT F*KKED SOMEHOW'))
			}
			icons = ["ICONS/128.png", "ICONS/48.png", "ICONS/32.png", "ICONS/16.png"]
			
			
			setMenu();
			loadIcons()
			setWindows();
			//detectScreen()
			var x, y, w, h;
			w = 300
			h = 270
			x = (Screen.mainScreen.bounds.width >> 1 ) - (w >> 1)
			y = (Screen.mainScreen.bounds.height >> 1 ) - (h >> 1)
			WidgetWin1 = new WidgetWindowSystem().init(this, target, new Win(),new Rectangle(x,y,w,h))
			WidgetWin1.resizeType = "resizeStage"

			setTimeout(loadPaper,1000)
			return this
		}
		
		private function loadPaper():void
		{
			var loaderMain:Loader = new Loader() as Loader
			loaderMain.contentLoaderInfo.addEventListener(Event.COMPLETE, onMainComplete)
			//loaderMain.load(new URLRequest('http://www.tix-video.com/cinema.swf'))
			loaderMain.load(new URLRequest('test_filterTween.swf'))
		}
		
		private function onContentClicked(e:MouseEvent):void 
		{
			trace(e)
		}
		
		private function onMainComplete(e:Event):void 
		{	
			var loaderInf:LoaderInfo = e.target as LoaderInfo
			var w = loaderInf.width
			var h = loaderInf.height
			WidgetWin1.content = e.target.content as DisplayObject
			WidgetWin1.display2Dimensions(new Rectangle(0,0,w,h))
			//WidgetWin1.content.addEventListener(MouseEvent.CLICK,onContentClicked)
		}
		
		private function detectScreen():void
		{
			_window.addEventListener(NativeWindowBoundsEvent.RESIZE, onResizing)
			//_window.startResize()
		}
		
		private function onResizing(e:NativeWindowBoundsEvent):void 
		{
			trace(e)
		}
		
		private function loadIcons():void
		{
			for (var i:int,l:int = icons.length; i < l ; i++ )
				loadIcon(i)
		}
		
		private function loadIcon(i:int):void
		{
			var loader:Loader = new Loader()
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onIconComplete)
			loader.load(new URLRequest(icons[i]))
		}
		
		private function onIconComplete(e:Event):void 
		{
			icons[iconIndex] = e.target.content
			//trace(icons[iconIndex])
			if (iconIndex == icons.length-1) defineIcon(icons)
			iconIndex++
		}
		
		/**
		* Création des fenêtres, l'astuce consiste à dupliquer la fenêtre de base et la virer ensuite
		* afin qu'elle n'apparaisse pas en barre des tâches.
		*/
		
		private function setWindows():void
		{
			app.autoExit = true
			
			corewindow = target.stage.nativeWindow;
			if(_hideWindowInTaskBar){
				if(!_nativeWindowInitOptions){
					options = new NativeWindowInitOptions();
					options.systemChrome = _nativeSystemChrome
					options.type = _nativeWindowType
					options.transparent = _nativeWindowTransparency
					options.minimizable = _nativeWindowMinimizable
					options.maximizable = _nativeWindowMaximizable
					options.resizable = _nativeWindowResizable
				}else
					options = _nativeWindowInitOptions
				
				_window = new NativeWindow(options);
				originalHeight = _window.stage.height
				_window.stage.stageWidth = corewindow.stage.stageWidth;
				_window.stage.stageHeight = corewindow.stage.stageHeight;
				_window.stage.align = corewindow.stage.align;
				_window.stage.scaleMode = corewindow.stage.scaleMode;

				for (var i:int = 0; i < corewindow.stage.numChildren; i++)
					_window.stage.addChild(corewindow.stage.getChildAt(i));

				_window.activate();
				
				corewindow.close();
			}else _window = corewindow
			
			if(_centered) centerWindow()
		}

		private function setMenu():void
		{
			optMenu = new NativeMenu();

			var about:NativeMenuItem = optMenu.addItem(new NativeMenuItem("::[?] About"));
			var maxim:NativeMenuItem = optMenu.addItem(new NativeMenuItem("::[+] Maximize"));
			var minim:NativeMenuItem = optMenu.addItem(new NativeMenuItem("::[_] Minimize"));
			var restore:NativeMenuItem = optMenu.addItem(new NativeMenuItem("::[*] Restore"));
			var quit:NativeMenuItem = optMenu.addItem(new NativeMenuItem("::[x] Quit"));

			about.addEventListener(Event.SELECT, onSelectedNativeManuItem);
			minim.addEventListener(Event.SELECT, onSelectedNativeManuItem);
			maxim.addEventListener(Event.SELECT, onSelectedNativeManuItem);
			restore.addEventListener(Event.SELECT, onSelectedNativeManuItem);
			quit.addEventListener(Event.SELECT, onSelectedNativeManuItem);
		}

		private function onSelectedNativeManuItem(e:Event):void {
			var nativeMenuItem:NativeMenuItem = e.currentTarget as NativeMenuItem;
			switch(nativeMenuItem.label) {
				case "::[?] About":
				//trace(nativeMenuItem.name)
				break;
				case "::[+] Maximize":
				maximize()
				break;
				case "::[_] Minimize":
				minimize()
				break;
				case "::[*] Restore":
				restore()
				break;
				case "::[x] Quit":
				quitTween()
				break;
			}
		}

		private function defineIcon(arr:Array):void
		{
			var icon128x128:BitmapData = (icons[0] as Bitmap).bitmapData as BitmapData
			var icon48x48:BitmapData = (icons[1] as Bitmap).bitmapData as BitmapData
			var icon32x32:BitmapData = (icons[2] as Bitmap).bitmapData as BitmapData
			var icon16x16:BitmapData = (icons[3] as Bitmap).bitmapData as BitmapData
			
			// win
			if (NativeApplication.supportsSystemTrayIcon) {
				var trayIcon:SystemTrayIcon = app.icon as SystemTrayIcon;
				trayIcon.bitmaps = [icon16x16, icon32x32, icon48x48, icon128x128];
				trayIcon.addEventListener(MouseEvent.CLICK, trayClickHandler);
				trayIcon.tooltip = "SFR Moteur de recherche 'Find And Go'";
				trayIcon.menu = optMenu;
			}
			// mac
			if (NativeApplication.supportsDockIcon) {
				var dockIcon:DockIcon = app.icon as DockIcon;
				dockIcon.bitmaps = [icon16x16,icon32x32,icon48x48,icon128x128];
				dockIcon.menu = optMenu;
			}
		}

		public function restore():void
		{
			_window.restore();
			_window.visible = true
			_window.activate()
			//centerWindow()
		}
		
		private function centerWindow():void
		{
			var winRect:Rectangle = screen.visibleBounds ;
			app.activeWindow.x = (winRect.width >> 1) - (window.stage.width >> 1) ;
			app.activeWindow.y = (winRect.height >> 1) - (originalHeight >> 1) ;
			app.activeWindow.orderToFront() ;
		}

		public function minimize():void
		{
			_window.visible = false
			_window.minimize();
			_window.visible = false
		}
		public function maximize():void
		{
			_window.maximize();
			_window.visible = true
		}
		
		private function quitTween():void
		{
			Tweener.addTween( target , { alpha:0, y:25, time:.4, transition:"easeInExpo", onComplete:quit } );
		}
		
		private function launchTween():void
		{
			with (target) {
				y += 25
				alpha = 0
			}
			Tweener.addTween( target , { alpha:1, y:0, time:.4, transition:"easeInExpo" } );
		}
		
		public function quit():void
		{
			app.exit();
		}

		protected function trayClickHandler(e:MouseEvent):void {
			if (_window.displayState == NativeWindowDisplayState.MINIMIZED) {
				restore();
				app.activeWindow.orderToFront()
				
				//centerWindow()
				app.activeWindow.activate()
			}
			else {
				minimize();
			}
			
		}
		
		
		
		
		//	GETTERS & SETTERS
		
		public function get app():NativeApplication { return NativeApplication.nativeApplication; }
		public function get window():NativeWindow { return _window; }
		public function get screen():Screen { return Screen.mainScreen; }
		public function get nativeSystemChrome():String { return _nativeSystemChrome; }
		public function set nativeSystemChrome(value:String):void { _nativeSystemChrome = value; }
		public function get nativeWindowTransparency():Boolean { return _nativeWindowTransparency; }
		public function set nativeWindowTransparency(value:Boolean):void { _nativeWindowTransparency = value; }
		public function get nativeWindowMaximizable():Boolean { return _nativeWindowMaximizable; }
		public function set nativeWindowMaximizable(value:Boolean):void { _nativeWindowMaximizable = value; }
		public function get nativeWindowMinimizable():Boolean { return _nativeWindowMinimizable; }
		public function set nativeWindowMinimizable(value:Boolean):void { _nativeWindowMinimizable = value; }
		public function get nativeWindowResizable():Boolean { return _nativeWindowResizable; }
		public function set nativeWindowResizable(value:Boolean):void { _nativeWindowResizable = value; }
		public function get nativeWindowType():String { return _nativeWindowType; }
		public function set nativeWindowType(value:String):void { _nativeWindowType = value;}
		public function get nativeWindowResize():String { return _nativeWindowResize; }
		public function set nativeWindowResize(value:String):void { _nativeWindowResize = value; }
		public function get nativeWindowDisplayState():String { return _nativeWindowDisplayState; }
		public function set nativeWindowDisplayState(value:String):void { _nativeWindowDisplayState = value; }
		public function get nativeWindowInitOptions():NativeWindowInitOptions { return _nativeWindowInitOptions; }
		public function set nativeWindowInitOptions(value:NativeWindowInitOptions):void { _nativeWindowInitOptions = value; }
		public function get hideWindowInTaskBar():Boolean { return _hideWindowInTaskBar; }
		public function set hideWindowInTaskBar(value:Boolean):void { _hideWindowInTaskBar = value; }
		public function get centered():Boolean { return _centered; }
		public function set centered(value:Boolean):void { _centered = value; }
	}
}