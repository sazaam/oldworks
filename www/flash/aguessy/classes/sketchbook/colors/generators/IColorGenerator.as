package sketchbook.colors.generators
{
	import sketchbook.colors.ColorSB;
	
	public interface IColorGenerator
	{
		function update():void
		function get color():ColorSB
		function get value():uint
	}
}