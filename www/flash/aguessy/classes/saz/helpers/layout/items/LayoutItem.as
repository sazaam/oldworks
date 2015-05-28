package saz.helpers.layout.items 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import saz.helpers.layout.core.LayoutInfos;
	import saz.helpers.layout.managers.LayoutManager;
	import saz.helpers.layout.rects.SmartRect;
	import saz.helpers.sprites.Smart;
	
	/**
	 * ...
	 * @author saz
	 */
	
	
	public class LayoutItem extends Smart
	{//////////////////Layout Item Class v0.1
		////////////////////////////////////////////////////////////////////GETTERS & SETTERS
		public function get rectangle():Rectangle { return scrollRect || this.getRect(this); }
		//public function get parentRectangle():Rectangle { 
			//if (parent) {
				//if (parent is LayoutItem) {
					//_parentRectangle = LayoutItem(parent).parentRectangle ;
				//}else if (parent is Stage) {
					//_parentRectangle = new Rectangle(0,0,stage.stageWidth,stage.stageHeight) ;
				//}else if (parent is Sprite) {
					//_parentRectangle = parent.getRect(parent) ;
				//}else {
					//trace("tralala")
				//}
			//}
			//return _parentRectangle ;
		//}
	
		public function get index():int { return _depthIndex ; }
		public function set index(value:int):void 
		{_depthIndex = value ;}
		
		public function get layoutInfos():Object {
			return LayoutInfos.getLayoutInfos(this) ;
		}
		
		public function get smartRect():SmartRect { return _smartRect; }
		
		public function set smartRect(value:SmartRect):void 
		{
			_smartRect = value;
		}

		////////////////////////////////////////////////////////////////////VARS
		public var managerInstance:LayoutManager
		private var _parentRectangle:Rectangle
		private var _smartRect:SmartRect ;
		private var _depthIndex:int ;
		private var _parentLayoutInfos:Object;
		////////////////////////////////////////////////////////////////////CTOR
		public function LayoutItem(_props:Object = null) 
		{
			super(_props) ;
			// init smartRect
			_smartRect = new SmartRect(this) ;
			scaleX = scaleY = 0 ;
			applyRect(getRect(this)) ;
			// added event
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage) ;
			
			
		}
		///////////////////////////////////////////////////////////////////////////////////////////EVENTS
		////////////////////////////////////////////////////////////////////RESIZE
		public function onParentResize(e:Event):void 
		{
			applyRect(LayoutInfos.getLayoutRect(parent)) ;
			//trace(rectangle)
		}
		
		private function applyRect(_rect:Rectangle = null):void
		{
			_smartRect.applyRect(_rect) ;
		}
		////////////////////////////////////////////////////////////////////ONREMOVED
		private function onRemoved(e:Event):void 
		{
			scaleX = scaleY = 0 ;
			// resize events
			removeEventListener(Event.RESIZE, onParentResize) ;
			// added & remove events
			removeEventListener(Event.REMOVED_FROM_STAGE, arguments.callee) ;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage) ;
		}
		////////////////////////////////////////////////////////////////////ONADDED
		private function onAddedToStage(e:Event):void 
		{
			// important  !   setting the width to ZERO to have the REAL width and height of the parent
			applyRect(scrollRect) ;
			
			// initing the manager once
			if (!managerInstance) {
				if (parent is LayoutItem) {
					managerInstance = LayoutItem(parent).managerInstance ;
					_depthIndex = LayoutItem(parent).index + 1 ;
				}else{
					managerInstance = new LayoutManager(this) ;
					_depthIndex = 0 ;
				}
				
				//applyRect(managerInstance.inheritedDimensions(this)) ;
				if (this == managerInstance.Boss) {
					
				}
				//trace(managerInstance.inheritedDimensions(this))
				//launch instance
				managerInstance.init() ;
			}else {
				//applyRect(parentRectangle) ;
			}
			//
			
			init() ;
			
			// added & remove events
			removeEventListener(Event.ADDED_TO_STAGE, arguments.callee) ;
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved) ;
			// resize events
			addEventListener(Event.RESIZE, onParentResize) ;
		}
		
		private function init():void
		{
			applyRect(LayoutInfos.getLayoutRect(parent)) ;
			scaleX = scaleY = 1 ;
			//trace(scrollRect)
			//trace(">>>>>>>>>>>>>>>>>>> : "+ LayoutInfos.getLayoutInfos(parent))
		}
		

	}
}