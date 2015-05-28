package saz.helpers.layout.managers 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import saz.helpers.layout.items.LayoutItem;
	import saz.helpers.stage.StageProxy;
	
	/**
	 * ...
	 * @author saz
	 */
	public class LayoutManager 
	{//////////////////Layout Manager Class v0.1
		////////////////////////////////////////////////////////////////////GETTERS & SETTERS
		public function get stage():Stage { 
			return StageProxy.stage ;
		}
		public function get stageRect():Rectangle { 
			return StageProxy.stageRect ;
		}
		////////////////////////////////////////////////////////////////////VARS
		private var _layoutBoss:LayoutItem;
		////////////////////////////////////////////////////////////////////CTOR
		public function LayoutManager(_target:LayoutItem) 
		{
			if(!StageProxy.inited) StageProxy.init(_target.stage) ;
			_layoutBoss = _target ;
		}
		////////////////////////////////////////////////////////////////////INIT
		public function init():void
		{
			if(_layoutBoss.stage) _layoutBoss.stage.addEventListener(Event.RESIZE,onStageResized) ;
		}
		////////////////////////////////////////////////////////////////////STAGE RESIZE
		private function onStageResized(e:Event):void 
		{
			dispatchChildren(_layoutBoss,e) ;
		}
		////////////////////////////////////////////////////////////////////DISPATCH CHILDREN
		private function dispatchChildren(_layout:LayoutItem,e:Event):void
		{
			if(_layout.hasEventListener(Event.RESIZE)) _layout.dispatchEvent(e) ;
			for (var i:int = 0 ; i < _layout.numChildren ; i++ ) {
				var _child:DisplayObject = _layout.getChildAt(i) as DisplayObject ;
				if (_child is LayoutItem) {
					dispatchChildren(LayoutItem(_child),e) ;
				}else {
					if(_child.hasEventListener(Event.RESIZE)) _child.dispatchEvent(e) ;
				}
			}
		}
		////////////////////////////////////////////////////////////////////GETTERS & SETTERS
		public function inheritedDimensions(_child:LayoutItem):Rectangle {
			if (_child == _layoutBoss) return _layoutBoss.getRect(_layoutBoss) ;
			var rect:Rectangle ;
			var p:DisplayObjectContainer = _child.parent ;
			if (p is LayoutItem) rect = LayoutItem(p).rectangle ; 
			else rect = p.getRect(p)  ;
			return rect ;
		}
		//private static function $NotEmptyParent(_child:DisplayObject):DisplayObjectContainer
		//{
			//var p:DisplayObjectContainer = _child.parent ;
			//if (p is Stage) return p ;
			//var isBigger:Boolean = isBiggerThanChild(_child) ;
			//return isBigger ?  $NotEmptyParent(p) : p  ;
		//}
		//private static function isBiggerThanChild(_child:DisplayObject):Boolean
		//{
			//var p:DisplayObjectContainer = _child.parent ;
			//var isBigger:Boolean = (p.width >_child.width && p.height >_child.height ) ;
			//return isBigger ;
		//}
		public function get Boss():LayoutItem { return _layoutBoss; }
	}
}