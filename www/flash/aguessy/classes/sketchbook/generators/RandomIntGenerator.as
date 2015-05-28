package sketchbook.generators
{
	import sketchbook.generators.Generator;
	
	/**
	 * 指定した範囲で整数の乱数を返すGenerator
	 * 
	 * @example <listing version="3.0">
	 * var generator:IGenerator = new RandomIntGenerator(0,100);
	 * trace(generator.value); //returns random int
	 * trace(generator.update());
	 * trace(generator.value); //returns another random int</listing>
	*/
	public class RandomIntGenerator extends RandomGenerator
	{
		public function RandomIntGenerator(amplitude:Number, offset:Number)
		{
			super(amplitude, offset);
		}
		
		override public function clone():IGenerator
		{
			return new RandomIntGenerator(amplitude, offset)
		}
		
		override protected function updateValue():void
		{
			super.updateValue();
			_value = Math.round(_value);
		}
	}
}