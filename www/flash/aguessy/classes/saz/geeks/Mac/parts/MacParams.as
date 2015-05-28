package saz.geeks.Mac.parts 
{
	import caurina.transitions.properties.FilterShortcuts;
	import caurina.transitions.Tweener;
	import f6.lang.reflect.Type;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	import saz.geeks.Mac.MacPlayer;
	import saz.helpers.text.TextFill;
	
	/**
	 * ...
	 * @author saz
	 */
	public class MacParams extends SectionManager
	{
		private var optionsMenu			:Sprite
		private var optionsNames		:Array
		private var options				:Array
		private var _currentIndex		:int
		private var oldIndex			:int
		private var frozenIndex:int;
		private var upwards:Boolean;
		private var arrow:Sprite;
		private var stateOpened:Boolean;
		
		
		private var onInited:Function = function() {
			frozenIndex = 1
			addOptionsMenu()
		}
		private var onKilled:Function = function() {
			targetClip.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown)
		}
		
		public function MacParams() 
		{
			onInit = onInited
			onKill = onKilled
			onKeyDowned = onKeyDown
		}
		private function launch():void
		{
			launchText("PARAMETERS")
			arrow.blendMode = BlendMode.ADD
			
			Tweener.addTween(optionsMenu, { transition:"easeOutExpo", alpha:1, time:.4, delay:.9 , _DropShadow_alpha:100, _DropShadow_blurX:5, _DropShadow_blurY:5, _DropShadow_color:0x000000, _DropShadow_quality:3, _DropShadow_distance:3, _DropShadow_angle:90 } )
		}
		
		private function addOptionsMenu():void
		{	
			optionsMenu = target.addChild(new Sprite()) as Sprite
			optionsMenu.alpha = 0
			//
			trace((MacPlayer.player.target as Testte).music_xml.*)
			optionsNames = [" BROWSE_FOLDER   ", " NOW_PLAYING   ", " PLAYLISTS   ", " STREAMING   ", " RADIOS   "]
			options = []
			currentIndex = 0
			optionsNames.forEach(createOption)
			createArrow()
			enableForKeyPress()
			launch()
		}
		
		private function createArrow():void
		{
			var s:Sprite = new (Type.getClass(MacPlayer.player.MacGraphX.currentView.skin.NEXT)) as Sprite
			s.scaleX = -.3
			s.scaleY = .3
			s.y = 175
			arrow = optionsMenu.addChild(s) as Sprite
			var arrr:Sprite = arrow.getChildByName('arr') as Sprite
			arrr.alpha = 1
			//Tweener.addTween(arrow,{_DropShadow_inner:true,_DropShadow_alpha:100,_DropShadow_strength:30, _DropShadow_blurX:5, _DropShadow_blurY:5, _DropShadow_color:0xFFFFFF, _DropShadow_quality:3, _DropShadow_distance:3, _DropShadow_angle:90})
		}
		
		private function createOption(el:String,i:int,arr:Array):void
		{
			var tf:TextField = optionsMenu.addChild(new TextField()) as TextField
			tf.name = optionsNames[i]
			new TextFill(tf, MacPlayer.player.MacGraphX.currentView.skin.TYPO_SECTION, 65, el, 0xFFFFFF, null, false)
			
			pos(tf, i, options)
			options[i] = tf
			//if (i == optionsNames.length - 1)
			//{
				//
				//
			//}
		}
		
		private function upperOption():void
		{
			oldIndex = currentIndex
			upwards = false
			currentIndex--
			posOptions()
		}
		
		private function lowerOption():void
		{
			oldIndex = currentIndex
			upwards = true
			currentIndex++
			posOptions()
		}
		
		private function posOptions():void
		{
			sort()
			options.forEach(pos)
			var cur:TextField = options[frozenIndex] as TextField
			Tweener.addTween(arrow, { transition:"easeOutExpo", alpha:3, time:.8, onStart:function() { this.x = cur.width + cur.x + this.width-50 } } )

		}
		
		private function sort():void
		{
			if (upwards) {
				options.push(options.shift())
			}
			else {
				options.unshift(options.pop())
			}
		}
		
		private function pos(el:TextField,i:int,arr:Array):void
		{
			el.background = (i == frozenIndex)? true : false ;
			el.backgroundColor = (i == frozenIndex)? 0x131313 : 0x131313 ;
			el.x = (i == frozenIndex)? 100 : 150 ;
			el.y = 75 + (el.height) * (i)
			Tweener.addTween(el, { _color:(i == frozenIndex)? null : 0x000000 } )
			el.alpha = (i == frozenIndex)? .85 : .53 ;
			
			if(i == arr.length-1) TweenNewOption()
		}
		
		private function TweenOldOption():void
		{
			//old
		}
		
		private function TweenNewOption():void
		{
			//setTimeout(showArrow,500)
		
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.DOWN)
				lowerOption() 
			if (e.keyCode == Keyboard.UP)
				upperOption()
			if (e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.ESCAPE)
				//if (stateOpened) 
				closeWindow()
					
			if (e.keyCode == Keyboard.ENTER || e.keyCode == Keyboard.RIGHT)
				initWindow()
		}
		
		private function closeWindow():void
		{
			var tf:TextField = options[frozenIndex] as TextField
			tf.background = true
			optionsMenu.scrollRect = null
			optionsMenu.scaleX = optionsMenu.scaleY = 1
			optionsMenu.x = 0
			optionsMenu.y = 0
		}
		
		private function initWindow():void
		{
			var tf:TextField = options[frozenIndex] as TextField
			tf.background = false
			optionsMenu.scrollRect = new Rectangle(tf.x,tf.y,tf.stage.stageWidth,tf.height)
			optionsMenu.scaleX = optionsMenu.scaleY = .4
			optionsMenu.x = 160
			optionsMenu.y = 20
		}
		
		public function get currentIndex():int { return _currentIndex; }
		
		public function set currentIndex(_num:int):void 
		{
			var max:int = options.length - 1
			if (_num > max) _num = 0
			else if(_num < 0) _num = max
			_currentIndex = _num 
		}
	}
	
}