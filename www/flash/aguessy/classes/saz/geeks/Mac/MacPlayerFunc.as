package saz.geeks.Mac 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author saz
	 */
	public class MacPlayerFunc 
	{
		private var 	macPlayer			:MacPlayer
		public var 	spaceNavOpened			:Boolean		= false
		
		public function MacPlayerFunc() 
		{
			
		}
		
		
		public function init(_player:MacPlayer):MacPlayerFunc
		{
			macPlayer			 = _player
			macPlayer.MacDepot	 = new MacPlayerDeposit()
			macPlayer.MacDepot.init(macPlayer)
			return this
		}
		
		
		public function initGraphics()
		{
			macPlayer.MacGraphX = new MacPlayerGraphics()
			macPlayer.MacGraphX.init(macPlayer)
		}
		
		public function onKeyPress(e:KeyboardEvent):void
		{
			var eventDown:Boolean = e.type == KeyboardEvent.KEY_DOWN
			
			if (e.keyCode == Keyboard.SPACE)
			{
				if (eventDown) 
				{
					if (!spaceNavOpened) addNav()
				}
				else
				{
					if(spaceNavOpened) removeNav()
				}
			}
			else if (e.keyCode == Keyboard.ESCAPE || e.keyCode == Keyboard.UP)
			{
				if(spaceNavOpened && eventDown) removeNav()
			}
			else if (e.keyCode == Keyboard.LEFT)
			{
				if(spaceNavOpened && eventDown) changeSection(-1)
			}
			else if (e.keyCode == Keyboard.RIGHT)
			{
				if(spaceNavOpened && eventDown) changeSection(1)
			}
			else if (e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.NUMPAD_ENTER || e.keyCode == Keyboard.DOWN)
			{
				if (spaceNavOpened && eventDown) {
					openSection()
					removeNav()
				}
			}
		}
		
		public function addNav():void
		{
			spaceNavOpened = true
			macPlayer.MacGraphX.currentView.showNav(spaceNavOpened)
		}
		
		public function removeNav():void
		{
			spaceNavOpened = false
			macPlayer.MacGraphX.currentView.showNav(spaceNavOpened)
		}
		
		public function listenHomeEvents(e:MouseEvent):void
		{
			switch(e.currentTarget.name) {
				case 'PREV':
					changeSection(-1)
				break;
				case 'NEXT':
					changeSection(1)
				break;
				case 'SECTION':
					openSection()
					spaceNavOpened = false
					macPlayer.MacGraphX.currentView.showNav(spaceNavOpened)
				break;
			}
		}
		
		private function changeSection(_num):void
		{
			macPlayer.MacDepot.sectionIndex+=_num
			macPlayer.MacGraphX.currentView.SectionsTween(_num)
			macPlayer.MacGraphX.currentView.showCurrent()
		}
		private function openSection():void
		{
			macPlayer.MacGraphX.currentView.showCurrent()
			macPlayer.MacGraphX.currentView.toRequestedSection()
		}
	}
	
}