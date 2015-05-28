package sketchbook.generators.colors
{
	import sketchbook.generators.Generator;
	import sketchbook.colors.ColorSB;

	/**
	 * 色を生成するGeneratorの抽象基底クラス。このクラスは直接は使用されません。
	 */
	public class ColorGenerator extends Generator
	{
		protected var _baseColor:ColorSB
		protected var _color:ColorSB
		
		public function ColorGenerator(baseColor:ColorSB)
		{
			this.baseColor = baseColor
		}
		
		/**
		 * generatorが生み出す色の元となるColorSBオブジェクト
		 */
		public function set baseColor(color:ColorSB):void
		{
			_baseColor = color.clone()
		}
		
		public function get baseColor():ColorSB
		{
			return _baseColor
		}
		
		/**
		 * 生成された色のColorSBオブジェクト
		 */
		public function get color():ColorSB
		{
			return _color.clone()
		}
	}
}