package sketchbook.generators.colors
{
	import sketchbook.generators.Generator;
	import sketchbook.colors.ColorSB;
	import sketchbook.generators.IGenerator;
	
	/**
	 * RGB値を波形でコントロールできるジェネレーター
	 */
	public class RGBGenerator extends ColorGenerator
	{
		private var redGenerator:IGenerator
		private var greenGenerator:IGenerator
		private var blueGenerator:IGenerator
		
		/**
		 * ベースとなる色のRGBにGeneratorで生成したオフセットを加えて、新しい色を作り出すジェネレーターです。
		 * 
		 * @param baseColorベース色となるColorSB
		 * @param redGenerator redを増減させるGenerator
		 * @param greenGenerator greenを増減させるGenerator
		 * @param blueGenerator blueを増減させるGenerator
		 */
		public function RGBGenerator(baseColor:ColorSB, redGenerator:IGenerator=null, greenGenerator:IGenerator=null, blueGenerator:IGenerator=null){
			super(baseColor)
			if(redGenerator)
				this.redGenerator = redGenerator.clone()
			if(greenGenerator)
				this.greenGenerator = greenGenerator.clone()
			if(blueGenerator)
				this.blueGenerator = blueGenerator.clone()
			updateValue();
		}
		
		override public function clone():IGenerator
		{
			return new RGBGenerator(baseColor.clone(),redGenerator.clone(),greenGenerator.clone(),blueGenerator.clone());
		}
		
		//RGBのジェネレーターを更新する
		protected override function updateCounter():void
		{
			if(redGenerator)
				redGenerator.update()
				
			if(greenGenerator)
				greenGenerator.update()
				
			if(blueGenerator)
				blueGenerator.update()
		}
		
		//RGBのジェネレーターから新しい色を作り出す
		protected override function updateValue():void
		{
			var r:uint = _baseColor.red
			var g:uint = _baseColor.green
			var b:uint = _baseColor.blue
			
			if(redGenerator)
				r+=redGenerator.value
				
			if(greenGenerator)
				g += greenGenerator.value
				
			if(blueGenerator)
				b += blueGenerator.value
				
			_color = new ColorSB();
			_color.setRGB(r,g,b);
			
			_value = uint(_color);
		}
	}
}