package sketchbook.colors.generators
{
	import sketchbook.colors.Color;
	
	/**
	 * 特定の色を基点にSineで,RGB値がゆらいた新しい色を返すジェネレーター
	*/
	public class SimpleSineColorGenerator extends ColorGeneratorBase
	{
		private var _time:uint
		private var _period:uint
		private var _amplitude:Number
		
		public function SimpleSineColorGenerator(baseColor:Color, amplitude:Number, period:uint)
		{
			_time = 0	
			_amplitude = amplitude
			_period = period
			_color = new Color()
			
			this.baseColor = baseColor.clone()
			
			update()
		}
		
		override public function update():void
		{
			var offset:Number = _amplitude * Math.sin( _time / _period * Math.PI*2)
			var r:uint = fixRange(baseColor.red + offset)
			var g:uint = fixRange(baseColor.green + offset)
			var b:uint = fixRange(baseColor.blue + offset)
			
			_time++
			if(_time>=_period)
				_time = _time%_period
			
			_color.setRGB(r,g,b)
		}
	}
}