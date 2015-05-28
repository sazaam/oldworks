package saz.helpers.text 
{
	import flash.text.*;

	/**
	* ...
	* @author saz
	*/
	public class TextFill
	{
		private var tf:TextField
		private var content:String
		private var font:Font
		private var format:TextFormat
		private var size:Object
		private var color:Object
		
		public static var DEBUG:Boolean = false
		
		public function TextFill(_tf:TextField, _font:Font,_size:Object = undefined, _content:String = null, _color = 0x999999, bold:Object = null , _selectable = true) 
		{
			tf = _tf
			tf.embedFonts = true
			tf.selectable = _selectable
			font = _font
			size = _size || tf.getTextFormat().size
			color = _color
			format = new TextFormat(_font.fontName, size, color , bold)
			fill(_content)
		}
		
		public function style():void
		{
			tf.setTextFormat(format)
		}
		
		public function fill(_content = null):void
		{
			tf.multiline = true
			tf.autoSize = TextFieldAutoSize.LEFT
			tf.antiAliasType = AntiAliasType.ADVANCED
			tf.htmlText =  _content
			style()
		}
	}
	
}