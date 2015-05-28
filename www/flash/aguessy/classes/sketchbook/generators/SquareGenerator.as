package sketchbook.generators
{
	/**
	 * 矩形波を生成するGenerator
	 */
	public class SquareGenerator extends SineGenerator
	{	
		public function SquareGenerator(amplitude:Number, period:Number, offset:Number=0)
		{
			super(amplitude, period, offset)
		}
		
		
		override public function clone():IGenerator
		{
			var sg:SquareGenerator = new SquareGenerator(_amplitude,_period,_offset)
			sg.time = time
			return sg
		}
		
		override protected function updateValue():void
		{
			var val:Number = Math.sin(Math.PI * 2 * _time / _period  )
			if(val>=0){
				val = 1
			}else{
				val = -1
			}
			_value = val * _amplitude + _offset
		}
	}
}