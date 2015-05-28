package sketchbook.generators
{
	import sketchbook.generators.Generator;
	
	/**
	 * 乱数を出力するジェネレーター
	 * 
	 * <p>乱数は-1～1の間を取り、<code>amplitude</code>, <code>offset</code>プロパティによって補正されます。
	 * RandomGeneratorのとる値は以下の式で表されます。</p>
	 * 
	 * <p>value = (-1～1) * amplitude + offset </p>
	 * 
	 * @example <listing version="3.0">
	 * var generator:IGenerator = new RandomGenerator(10, 5);
	 * trace( generator.value ) //random value between -5 to 15
	 * </listing>
	 */
	public class RandomGenerator extends Generator
	{
		public var amplitude:Number;
		public var offset:Number;
		
		/**
		 * -1 ～ 1の間の乱数を返すGeneratorです。
		 * 
		 * <p>乱数の値は<code>amplitude</code>, <code>offset</code>プロパティによって補正され、以下の式で示す範囲をとります。</p>
		 * 
		 * @example <listing version="3.0">value = (-1～1) * amplitude + offset</listing>
		 * 
		 * @param amplitude 増幅値。この値が乱数に乗算される。
		 * @param offset オフセット。この値が乱数に加算される。
		 */
		public function RandomGenerator(amplitude:Number, offset:Number)
		{
			this.amplitude = amplitude
			this.offset = offset
			updateValue()
		}
		
		override public function clone():IGenerator
		{
			return new RandomGenerator(amplitude, offset)
		}
		
		override protected function updateValue():void
		{
			//ここ_differenceを作って効率化すること
			_value = (Math.random() *2-1)* amplitude + offset
		}		
	}
}