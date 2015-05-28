package sketchbook.generators
{
	/**
	 * 子Generatorの値を指定した上限下限で切り捨てるFilter系Generatorです。
	 */
	public class Cutoff extends Generator
	{
		public var min:Number
		public var max:Number
		
		protected var _generator:IGenerator
		
		public function Cutoff(generator:IGenerator, min:Number, max:Number)
		{
			_generator = generator.clone()
			this.min = min
			this.max = max	
			updateValue();
		}
		
		override public function clone():IGenerator
		{
			return new Cutoff(_generator, min, max)
		}
		
		override public function update():*
		{
			_generator.update()
			updateValue()
			return _value
		}
		
		override protected function updateValue():void
		{
			_value = Math.min(max, Math.max(_generator.value, min))
		}
	}
}