package saz.geeks.Mac.views 
{
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author saz
	 */
	public class MacSkin 
	{
		public var 		UPPER_NAV				:Sprite
		
		public var 		SECTIONS				:Array
		public var 		PARTS_MCS				:Array
		public var 		PARTS_MCS_BACKGROUNDS	:Array
	
		public var 		PARAMETERS				:Sprite
			
		public var 		VIDEOS					:Sprite
		public var 		MUSIC					:Sprite
		public var 		SECTION					:Class
		public var 		SECTION_TITLE			:Sprite
		public var 		SECTION_TITLE_TXT		:TextField
		
		public var 		PREV					:Sprite
		public var 		NEXT					:Sprite
		
		public var 		TYPO_SECTION			:Font
		public var 		TYPO_TEXTES				:Font
		
		
		public function MacSkin() 
		{
			
		}
		
		public function generateBytes(_paramsObj:Object):MacSkin
		{
			for (var i:String in _paramsObj)
				affect(i,_paramsObj[i])
			
			return this
		}
		
		private function affect(_str:String,_value:*):void
		{
			trace(_str, _value)
			this[_str] = _value
			_value.name = _str
		}
		
	}
	
}