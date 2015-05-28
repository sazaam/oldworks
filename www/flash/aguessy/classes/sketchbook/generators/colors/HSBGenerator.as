package sketchbook.generators.colors
{
	import sketchbook.generators.Generator;
	import sketchbook.generators.IGenerator;
	import sketchbook.colors.ColorSB;
	
	/**
	 * 指定した色をベースにHSB値に揺らぎを与えた値を返すジェネレーター
	 * 
	 */
	public class HSBGenerator extends ColorGenerator
	{
		private var hueGenerator:IGenerator
		private var saturationGenerator:IGenerator
		private var brightnessGenerator:IGenerator
		
		public function HSBGenerator(baseColor:ColorSB, hueGenerator:IGenerator=null, saturationGenerator:IGenerator=null, brightnessGenerator:IGenerator=null)
		{
			super(baseColor)
			
			if(hueGenerator)
				this.hueGenerator = hueGenerator.clone()
				
			if(saturationGenerator)
				this.saturationGenerator = saturationGenerator.clone()
				
			if(brightnessGenerator)
				this.brightnessGenerator = brightnessGenerator.clone()
			
			updateValue();
		}
		
		override protected function updateCounter():void
		{
			
			
			if(hueGenerator)
				hueGenerator.update()
				
			if(saturationGenerator)
				saturationGenerator.update()
		
			if(brightnessGenerator)
				brightnessGenerator.update()
		}
		
		override protected function updateValue():void
		{
			var h:Number = _baseColor.hue
			var s:Number = _baseColor.saturation
			var b:Number = _baseColor.brightness
			
			
			
			if(hueGenerator)
				h += hueGenerator.value
			
			if(saturationGenerator)
				s += saturationGenerator.value
			
			if(brightnessGenerator)
				b += brightnessGenerator.value

			

			_color = new ColorSB();
			_color.setHSB(h,s,b)
			
			_value = uint(color);
		}
	}
}