package saz.helpers.layout.items 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author saz
	 */
	public class ResizableLayerItem extends LayoutItem
	{
		public function ResizableLayerItem(_props:Object = null) 
		{
			super(_props) ;
		}
		
		override public function onStageResize(e:Event):void 
		{
			trace('i') ;
		}
	}
	
}