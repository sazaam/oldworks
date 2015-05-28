package console 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author saz
	 */
	public class ConsoleGraphics 
	{
		private var __target:Sprite;
		private var __console:Sprite;
		
		public function ConsoleGraphics(tg:Sprite) 
		{
			__target = tg ;
		}
		
		protected function create():void 
		{
			__console = Sprite(addChild(new Sprite())) ;
		}
		
		public function get console():Sprite { return __console; }
		
		public function get target():Sprite { return __target; }
		
		
	}

}