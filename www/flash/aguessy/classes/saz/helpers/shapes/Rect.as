package saz.helpers.shapes 
{
	public class Rect extends Base
	{
		internal override function drawShape(offsetX:Number, offsetY:Number):void
		{
			graphics.drawRect(offsetX, offsetY, width, height);
		}
	}
}

