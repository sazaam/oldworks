package saz.geeks.Mac.parts 
{
	import caurina.transitions.Tweener;
	import f6.helpers.essentials.collections.SpriteCollection;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import saz.helpers.text.TextFill;
	import saz.geeks.Mac.MacPlayer;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class SectionManager
	{
		public var onInit:Function = function(){}
		public var onKill:Function = function(){}
		public var onKeyDowned:Function = function(e:KeyboardEvent){}
		public var target:SpriteCollection
		public var targetClip:Sprite
		public var paramsTitle:TextField
		
		public function SectionManager() 
		{
			
		}
		
		public function init(_tg:SpriteCollection):void
		{
			target = _tg
			targetClip = target.toArray()[0]
			onInit()
		}
		
		public function kill():void
		{
			onKill()
			//if(target.parent) trace("IM STILL HERE !! ")
		}
		public function launchText(_msg:String):void
		{
			paramsTitle = new TextField() as TextField
			paramsTitle.name = "TITLE"
			new TextFill(paramsTitle, MacPlayer.player.MacGraphX.currentView.skin.TYPO_SECTION, 44, _msg , 0xFFFFFF, null, false)
			paramsTitle.x = 155
			paramsTitle.y = 9
			paramsTitle.alpha = 0
			target.addChild(paramsTitle)
			//Tweener.addTween(paramsTitle, { transition:"easeInExpo", alpha:1, time:.5, delay:.5, onComplete:removeText, onStart:function() { this.x += 30 }/*, _DropShadow_alpha:100, _DropShadow_blurX:5, _DropShadow_blurY:5, _DropShadow_color:0x000000, _DropShadow_quality:3, _DropShadow_distance:3, _DropShadow_angle:90 */} )
			Tweener.addTween(paramsTitle, { transition:"easeInExpo", alpha:1, time:.5, delay:.5, onComplete:removeText, onStart:function() { this.x += 30 }, _DropShadow_alpha:100, _DropShadow_blurX:5, _DropShadow_blurY:5, _DropShadow_color:0x000000, _DropShadow_quality:3, _DropShadow_distance:3, _DropShadow_angle:90 } )
		}
		
		public function removeText():void
		{
			Tweener.addTween(paramsTitle, { transition:"easeOutExpo", alpha:0, time:.8, delay:2.2, onComplete:function(){paramsTitle.parent.removeChild(paramsTitle)}})
		}
		public function enableForKeyPress()
		{
			enable()
		}
		private function enable():void
		{
			targetClip.stage.addEventListener(KeyboardEvent.KEY_DOWN,onSpaceKeyDown)
		}
		
		public function disableSectionKeyBoard():void
		{
			targetClip.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onSpaceKeyDown)
			targetClip.stage.addEventListener(KeyboardEvent.KEY_UP, onSpaceKeyReleased)
		}
		
		private function onSpaceKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode != Keyboard.SPACE)
			{
				onKeyDowned(e)
			}else {
				disableSectionKeyBoard()
			}
		}
		private function onSpaceKeyReleased(e:KeyboardEvent):void 
		{
			if(target.parent)
				if (e.keyCode == Keyboard.SPACE) {
					enable()
					targetClip.stage.removeEventListener(KeyboardEvent.KEY_UP,arguments.callee)
				}
		}
	}
	
}