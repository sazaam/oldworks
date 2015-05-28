package sketchbook.generators
{
	 /* 複数の波形を合成して新しい波形を作るGenerator
	 * 
	 * @example <listing version="3.0">
	 * var generator1:IGenerator = new SineGenerator(5,5);
	 * var generator2:IGenerator = new SquareGenerator(10,0);
	 * var compGenerator:IGenerator = new CompositeGenerator( [generator1, generator2], 1, 0 );
	 * 
	 * trace(compGenerator.value)  //合成した波を返す
	 * trace(compGenerator.update());
	 * </listing>
	 */
	public class CompositeGenerator extends Generator
	{
		public var amplitude:Number
		public var offset:Number
		protected var _generators:Array
		
		/**
		 * 複数の波形を合成して新しい波形を作るGenerator
		 * 
		 * @param generators 合成するIGenerator配列
		 * @param amplitude 増幅値
		 * @param offset 補正値
		 */
		public function CompositeGenerator(generators:Array, amplitude:Number=1, offset:Number=0)
		{
			this.amplitude = amplitude
			this.offset = offset
			
			_generators = new Array();
			
			var imax:int = generators.length
			for(var i:int=0; i<imax; i++)
				_generators.push( IGenerator(generators.shift()).clone() )
			
			updateValue();
		}
		
		
		override public function clone():IGenerator
		{
			return new CompositeGenerator(_generators,amplitude,offset);
		}
		
		
		override protected function updateCounter():void
		{
			var imax:int = _generators.length
			for(var i:int=0; i<imax; i++)
				IGenerator(_generators[i]).update()
		}
		
		override protected function updateValue():void
		{
			_value = 0
			var imax:int = _generators.length
			for(var i:int=0; i<imax; i++)
				_value += IGenerator(_generators[i]).value
				
			_value = offset + _value * amplitude
		}
	}
}