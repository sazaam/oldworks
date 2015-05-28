package sketchbook.colors.generators
{
	import sketchbook.colors.ColorSB
	
	public class ColorGeneratorBase implements IColorGenerator
	{
		protected var baseColor:ColorSB
		protected var _color:ColorSB
		
		public function update():void
		{
		}
		
		public function get color():ColorSB
		{
			return _color.clone()
		}
		
		public function get value():uint
		{
			return _color.value
		}
		
		// constraint value range 0-255
		protected function fixRange(val:Number):uint
		{
			return Math.round(Math.min(255,Math.max(0,val)))
		}
		
		protected function normDist():Number
		{
			return (Math.random()+Math.random()+Math.random()+Math.random()+Math.random()+Math.random())/6
		}
	}
}