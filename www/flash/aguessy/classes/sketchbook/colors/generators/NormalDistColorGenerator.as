package sketchbook.colors.generators
{
	import sketchbook.colors.ColorSB
	
	/**
	 * ノーマルディストリビューションに従った色分布でカラーをジェネレートします 
	 */
	public class NormalDistColorGenerator extends ColorGeneratorBase
	{
		private var _range:Number
		
		public function NormalDistColorGenerator(baseColor:ColorSB, range:Number)
		{
			this.baseColor = baseColor.clone()
			this._color = new ColorSB()
			_range = range
			update()
		}
		
		override public function update():void
		{
			var rOffset:Number = (normDist()-0.5) * _range * 2
			var gOffset:Number = (normDist()-0.5) * _range * 2
			var bOffset:Number = (normDist()-0.5) * _range * 2
			
			_color.setRGB( _color.red+rOffset, _color.green+gOffset, _color.blue + bOffset)
		}
	}
}