package testing 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Tester extends Sprite 
	{
		
		public function Tester() 
		{
			//new MultiLoaderRequestTest(this) ;
			//new FroCircularLoadTest(this) ;
			
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
		}
		
		private function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			trace('started') ;
			test() ;
		}
		
		private function test():void 
		{
			var s:Sprite = Sprite(addChild(new Sprite())) ;
			
			var g:Graphics = s.graphics ;
			g.beginFill(0xEEEEEE) ;
			g.drawRect(0, 0, 400, 400) ;
			g.endFill() ;
			s.x = 200 ;
			s.y = 100 ;
			
			
			
			var dropShadowFilter:DropShadowFilter = new DropShadowFilter(1, 90, 0x0, .7, 50, 50, 1, 3, true) ;
			var p:Array = [dropShadowFilter] ;
			s.filters = [dropShadowFilter] ;
			p.splice(dropShadowFilter) ;
			s.filters = p ;
			
			trace('>>', p) ;
		}
	}
}