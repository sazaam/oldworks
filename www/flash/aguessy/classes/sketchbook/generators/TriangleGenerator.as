package sketchbook.generators
{
	/**
	 * 三角波を生成するジェネレーター
	 */
	public class TriangleGenerator extends SineGenerator
	{
		public function TriangleGenerator(amplitude:Number, period:Number, offset:Number=0)
		{
			super(amplitude, period, offset)
		}
		
		
		override public function clone():IGenerator
		{
			var tg:TriangleGenerator = new TriangleGenerator(_amplitude,_period,_offset)
			tg.time = time
			return tg
		}
		
		override protected function updateValue():void
		{
			var ratio:Number = time / _period
			var val:Number
			if(ratio<0.25){
				val = 4 * ratio
			}else if(ratio<0.75){
				val = -4 * ratio + 2
			}else{
				val = 4 * (ratio - 1)
			}
			
			_value = val * _amplitude + _offset
		}
	}
}