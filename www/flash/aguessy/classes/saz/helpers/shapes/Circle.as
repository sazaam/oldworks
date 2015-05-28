package saz.helpers.shapes 
{
	public class Circle extends Base
	{
		internal override function drawShape(offsetX:Number, offsetY:Number):void
		{
			graphics.drawEllipse(offsetX, offsetY, width, height);
		}
	}
}

