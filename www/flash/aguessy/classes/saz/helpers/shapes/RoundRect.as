package saz.helpers.shapes 
{
	public class RoundRect extends Base
	{
		private var _ellipseWidth:Number = 10;
		public function get ellipseWidth():Number{return _ellipseWidth;}
		public function set ellipseWidth(value:Number):void
		{
			_ellipseWidth = value;
			draw();
		}

		private var _ellipseHeight:int = 10;
		public function get ellipseHeight():Number{return _ellipseHeight;}
		public function set ellipseHeight(value:Number):void
		{
			_ellipseHeight = value;
			draw();
		}

		internal override function drawShape(offsetX:Number, offsetY:Number):void
		{
			graphics.drawRoundRect(offsetX, offsetY, width, height, ellipseWidth, ellipseHeight);
		}
	}
}

