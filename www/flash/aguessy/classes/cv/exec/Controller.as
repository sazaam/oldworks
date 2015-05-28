package cv.exec 
{
	import asSist.$;
	import cv.deposit.Deposit;
	import cv.grafix.Graphix;
	import cv.modules.Backgrounds;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import gs.easing.Expo;
	import gs.TweenLite;
	import mvc.behavior.commands.Command;
	import mvc.behavior.commands.CommandQueue;
	import mvc.behavior.commands.Wait;
	import saz.helpers.keys.KeyCommand;
	import saz.helpers.layout.items.LayoutItem;
	import saz.helpers.sprites.Smart;
	import saz.helpers.stage.StageProxy;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Controller extends EventDispatcher
	{
		public var selectedSection:int = -1;
		public var awaitingSection:int = -1;
		public var backgrounds:Backgrounds ;
		
		internal var _deposit:Deposit ;
		internal var _graphix:Graphix ;
		public var spaceNavOpened:Boolean;
		public var stepOnePassedThrough:Boolean;
		
		private var sectionsLength:int = 0;
		private var nav3DID:uint;
		public var enabled:Boolean;
		public var isLaunching:Boolean;
		private var currentCoords:Point;
		private var context:ContextMenu;
		private var contextMenus:Array;
		///////////////////////////////////////////////////CTOR
		public function Controller() 
		{
			
		}
		///////////////////////////////////////////////////INIT
		public function init():Controller
		{
			_deposit = Executer.deposit.init() ;
			_graphix = Executer.graphix.init() ;
			return this ;
		}
		///////////////////////////////////////////////////START
		public function start():void
		{
			// lance l'histoire des navs
			// lance l'histoire de navigation spacebar
			var xml:XML = Deposit.XML_SECTIONS ;
			clearContextMenus() ;
			for each(var section:XML in Deposit.XML_SECTIONS.*) {
				_graphix.createSectionsNavItem(section) ;
				_graphix.createSections3DNavItem(section) ; 
				sectionsLength = section.childIndex() ;
				addContextMenuItemsForSection(section) ;
			}
			closeContextMenu() ;
			
			$(Executer.target.stage).bind(Event.RESIZE, _graphix.onStageResized) ;
			
			enableSpaceNavigation() ;
			enableMouseScroll() ;
		}
		
		private function closeContextMenu():void
		{
			Executer.target.contextMenu = context ;
			
			
			var p = context.customItems ;
			var l:int = p.length ;
			for (var i:int = 0; i < l ; i++ )
			{
				var item:ContextMenuItem = ContextMenuItem(p[i]) ;
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onContextMenuItemSelect) ;
			}
		}
		
		private function onContextMenuItemSelect(e:ContextMenuEvent):void 
		{
			var returned:Object = retrieveProjectItem(ContextMenuItem(e.target));
			launch(returned.section,returned.project) ;
		}
		private function retrieveProjectItem(cm:ContextMenuItem):Object {
			var l:int = contextMenus.length ;
			for (var i:int = 0; i < l ; i++ ) {
				var p:Array = contextMenus[i] as Array ;
				var k:int = p.length ;
				for (var j:int = 0 ; j < k ; j++ ) {
					if (ContextMenuItem(p[j]) == cm) {
						return { section:i , project:j } ;
					}
				}
			}
			return {}
		}
		private function addContextMenuItemsForSection(section:XML):void
		{
			contextMenus.push([]) ;
			context.customItems.push(new ContextMenuItem(section.@id.toXMLString(),true,false)) ;
			for each(var project:XML in section.project) {
				var cmi:ContextMenuItem = new ContextMenuItem(String(project.@name.toXMLString().toUpperCase())) ;
				contextMenus[section.childIndex()].push(cmi) ;
				context.customItems.push(cmi) ;
			}
		}
		
		private function clearContextMenus():void
		{
			StageProxy.stage.showDefaultContextMenu = false ;
			context = new ContextMenu() ;
			context.hideBuiltInItems() ;
			context.customItems = [] ;
			contextMenus = [] ;
		}
		///////////////////////////////////////////////////ENABLE
		///////////////////////////////////////////////////MOUSE NAVIGATION
		private function enableMouseScroll():void
		{
			$("#grid").bind(MouseEvent.MOUSE_DOWN,onGridClick) ;
		}
		private function onGridClick(e:MouseEvent):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee) ;
			e.currentTarget.addEventListener(MouseEvent.MOUSE_UP , onMouseUp) ;
			
			currentCoords = new Point(e.stageX, e.stageY) ;
			
			var rect:Rectangle = backgrounds.currentPage.scrollRect ;
			var original:Point = new Point(backgrounds.currentPage.getChildAt(0).width, backgrounds.currentPage.getChildAt(0).height) ;
			rect.width = original.x ;
			rect.height = original.y ;
			backgrounds.currentPage.scrollRect = rect ;
			
			e.currentTarget.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMoved) ;
		}
		
		private function onMouseMoved(e:MouseEvent):void 
		{
			var rect:Rectangle = backgrounds.currentPage.scrollRect ;
			
			var p:Point = new Point(currentCoords.x - e.stageX, currentCoords.y - e.stageY) ;
			rect.topLeft = p ;
			backgrounds.currentPage.scrollRect = rect ;
			e.updateAfterEvent() ;
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			e.currentTarget.removeEventListener(e.type , arguments.callee) ;
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoved) ;
			var rect:Rectangle = backgrounds.currentPage.scrollRect ;
			TweenLite.to(rect, .22, {ease:Expo.easeOut, top:0, left:0, width:e.currentTarget.stage.stageWidth,height:e.currentTarget.stage.stageHeight,onUpdate:function():void {
				backgrounds.currentPage.scrollRect = rect ;
			}})
			
			e.currentTarget.addEventListener(MouseEvent.MOUSE_DOWN,onGridClick) ;
			trace("closed") ;
		}
		///////////////////////////////////////////////////SPACE NAVIGATION
		private function enableSpaceNavigation():void
		{
			$(Executer.target.stage).bind(KeyboardEvent.KEY_DOWN, onKeyPress).bind(KeyboardEvent.KEY_UP, onKeyPress) ;
			enabled = true ;
			isLaunching = false ;
		}
		public function onKeyPress(e:KeyboardEvent):void
		{
			if (enabled == false) return ;
			var eventDown:Boolean = e.type == KeyboardEvent.KEY_DOWN ;
			
			if (e.keyCode == Keyboard.SPACE)
			{
				if (eventDown) 
				{
					if (!spaceNavOpened) {
						addNav() ;
						stepOne() ;
					} else {
						removeNav() ;
						if (stepOnePassedThrough) {
							stepOnePassedThrough = false ;
						}
					}
				}
			}
			else if (e.keyCode == Keyboard.ESCAPE || e.keyCode == Keyboard.LEFT)
			{
				if (spaceNavOpened) {
					if (eventDown) {
						if (!stepOnePassedThrough) removeNav() ;
						else {
							stepOne() ;
						}
					}
				}
				else{
					if(e.keyCode == Keyboard.LEFT) {
						if (backgrounds && eventDown) backgrounds.prevPage() ;
					}
				}
			}
			else if (e.keyCode == Keyboard.UP)
			{
				if (spaceNavOpened) {
					if (eventDown) {
						if (stepOnePassedThrough) {
							if (enabled == true) _graphix.nav3D.prev() ;
						}
						else {
							changeAwaitingSection(-1) ;
						}
					}
				}else{
					if (backgrounds && eventDown) backgrounds.prevProject() ;
				}
			}
			else if (e.keyCode == Keyboard.DOWN)
			{
				if (spaceNavOpened) {
					if (eventDown) {
						if (stepOnePassedThrough) {
							if (enabled == true) _graphix.nav3D.next() ;
						}
						else {
							changeAwaitingSection(1) ;
						}
					}
				}else{
					if (backgrounds && eventDown) backgrounds.nextProject() ;
				}
			}
			else if (e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.NUMPAD_ENTER || e.keyCode == Keyboard.RIGHT)
			{
				if (spaceNavOpened && eventDown) {
					if (!stepOnePassedThrough) {
						stepTwo();
					}
					else {
						launchSelectedProject() ;
					}
				}else{
					if (e.keyCode == Keyboard.RIGHT) {
						if (backgrounds && eventDown) backgrounds.nextPage() ;
					}
				}
			}
		}
		
		public function launchSelectedProject():void
		{
			var proj:int = _graphix.nav3D.awaitingProject ;
			isLaunching = true ;
			launch(awaitingSection, proj) ;
			setTimeout(removeNav, 500) ;
			isLaunching = false ;
		}
		public function onNavItemSelect(e:MouseEvent):void
		{
			changeAwaitingSection(int(e.currentTarget.name.substr( -1)) - awaitingSection) ;
			if (stepOnePassedThrough) _graphix.setNav3D(true) else {
				stepTwo() ;
			}
		}
		///////////////////////////////////////////////////STEPS
		public function stepOne(tween:Boolean = false):void
		{
			if (stepOnePassedThrough) {
				if(nav3DID is uint) clearTimeout(nav3DID) ;
				_graphix.killOldAwaitingSection() ;
				stepOnePassedThrough = false ;
			}
			_graphix.spaceNavStepOne(tween) ;
			
		}
		public function stepTwo():void
		{
			_graphix.spaceNavStepTwo() ;
			nav3DID = setTimeout(_graphix.setNav3D,500,true) ;
			stepOnePassedThrough = true ;
		}
		////////////////////////////////////////////////////SPACEBAR NAV
		public function addNav():void
		{
			spaceNavOpened = true ;
			_graphix.enableLayer(true, .3) ;
		}
		
		public function removeNav():void
		{
			if(stepOnePassedThrough) _graphix.killOldAwaitingSection() ;
			spaceNavOpened = false ;
			_graphix.enableLayer(false, .3) ;
			
		}
		private function changeAwaitingSection(_num:int):void
		{
			if (stepOnePassedThrough) {
				_graphix.killOldAwaitingSection() ;
			}
			
			awaitingSection += _num;
			if (awaitingSection > sectionsLength) awaitingSection = 0 ;
			else if (awaitingSection < 0) awaitingSection = sectionsLength;
			_graphix.showCurrentNavItem() ;
		}
		///////////////////////////////////////////////////LAUNCH
		public function launch(_num:int = 0,_projNum:int = -1):void
		{
			if (selectedSection != -1) {
				kill() ;
			}
			launchSection(_num,_projNum) ;
		}		
		///////////////////////////////////////////////////LAUNCH SECTION
		private function launchSection(_num:int,_projNum:int = -1):void
		{
			_graphix.launchSection(_num) ;
			backgrounds = new Backgrounds(this) ;
			backgrounds.init(Deposit.XML_SECTIONS.*[_num] ) ;
			backgrounds.launch(_projNum) ;
		}
		
		private function kill():void
		{
			if(backgrounds) backgrounds.kill() ;
			_graphix.killSection() ;
		}
		
		public function get graphix():Graphix { return _graphix; }
		public function get deposit():Deposit { return _deposit; }
	}
}