package saz.geeks.Mac.addons 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author saz
	 */
	public class ScrollStageView 
	{
		private var tg:DisplayObject;
		private var realTG:DisplayObject;
		
		public function ScrollStageView(_rectTG:DisplayObject,obj2:* = null) 
		{
			realTG = _rectTG ;
			var rect:Rectangle ;
			if (obj2 == null) rect = new Rectangle(0, 0, realTG.width, realTG.height)
			else {
				if (obj2 is Rectangle) {
					rect = Rectangle(obj2) ;
				}else if (obj2 is DisplayObject) {
					tg = DisplayObject(obj2) ;
					if (tg.scrollRect != null ) {
						rect = tg.scrollRect ;
					}else {
						rect = new Rectangle(0, 0, (tg is Stage)? Stage(tg).stageWidth : tg.width, (tg is Stage)? Stage(tg).stageHeight : tg.height) ;
						if (tg is Stage) {
							tg.addEventListener(Event.RESIZE, onStageResized) ;
						}
					}
				}
			}
			realTG.scrollRect = rect ;
		}
		
		private function onStageResized(e:Event):void 
		{
			realTG.scrollRect = new Rectangle(0,0,Stage(e.target).stageWidth,Stage(e.target).stageHeight) ;
		}
		
	}
	
}