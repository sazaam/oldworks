package saz.geeks.Mac 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author saz
	 */
	public class MacPlayer 
	{
		public var 			target		:DisplayObjectContainer;
		public var 			xml			:XML;
		public var 			MacFunc		:MacPlayerFunc;
		public var 			MacGraphX	:MacPlayerGraphics;
		public var 			MacDepot	:MacPlayerDeposit;
		public static var 	player		:MacPlayer
		
		public function MacPlayer() 
		{
			player = this
		}
		
		public function init(_tg:DisplayObjectContainer):MacPlayer
		{
			target = _tg
			return this
		}
		public function launch(_xml):void
		{
			xml 			= _xml
			MacFunc 		= new MacPlayerFunc()
			MacFunc.init(this)
		}
		
		public function enableHome(_arr:Array):void
		{
			_arr.forEach(function(el, i, arr) {
				//trace(el.name)
				switch(el.name) {
					default :
					el.buttonMode = true; el.addEventListener(MouseEvent.CLICK, MacFunc.listenHomeEvents)
					case 'BACKGROUND':
					case 'PARTS':
						
					break;
					
				}
			} )
		}
		
		public function enableNav(_arr:Array):void
		{
			_arr.forEach(function(el, i, arr) { el.buttonMode = true; el.addEventListener(MouseEvent.CLICK, MacFunc.listenHomeEvents) } )
		}
		public function disableNav(_arr:Array):void
		{
			_arr.forEach(function(el, i, arr) { el.buttonMode = true; el.removeEventListener(MouseEvent.CLICK, MacFunc.listenHomeEvents) } )
		}
		public function enableForResize():void
		{
			target.stage.addEventListener(Event.RESIZE,MacGraphX.resize)
		}
		public function enableForKeyPress():void
		{
			target.stage.addEventListener(KeyboardEvent.KEY_DOWN,MacFunc.onKeyPress)
			target.stage.addEventListener(KeyboardEvent.KEY_UP,MacFunc.onKeyPress)
		}
	}
	
}