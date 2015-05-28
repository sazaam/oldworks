package saz.geeks.Mac 
{
	
	/**
	 * ...
	 * @author saz
	 */
	public class MacPlayerDeposit 
	{
		private var 	macPlayer			:MacPlayer
		
		public var 		sectionList			:XMLList
		private var 	_sectionIndex		:int
		
		public function MacPlayerDeposit() 
		{
			
		}
		
		public function init(_player:MacPlayer):MacPlayerDeposit
		{
			macPlayer = _player
			launchOnce()
			return this
		}

		private function launchOnce():void
		{
			var xml:XML = macPlayer.xml
			sectionList = xml.*
			_sectionIndex = 0
			macPlayer.MacFunc.initGraphics()
		}
		
		public function get sectionIndex():int { return _sectionIndex; }
		
		public function set sectionIndex(_num:int):void {
			var max:int = sectionList.length() - 1
			if (_num > max) _num = 0
			else if(_num < 0) _num = max
			_sectionIndex = _num 
		}
	}
}