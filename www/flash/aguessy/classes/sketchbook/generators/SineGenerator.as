package sketchbook.generators
{
	import sketchbook.generators.Generator;
	
	/**
	 * サイン波を生成するGenerator
	 */
	public class SineGenerator extends Generator
	{
		protected var _time:Number
		
		protected var _offset:Number
		protected var _amplitude:Number
		protected var _period:Number
		
		/**
		 * 
		 * @param 波形の大きさ。4ならば±4の範囲で波が発生する。
		 * @param 波の周期。何回アップデートすれば波が繰り返すか。
		 * @param 波形の値に対するオフセット。
		 */
		public function SineGenerator(amplitude:Number, period:Number, offset:Number=0)
		{
			_time = 0
			_amplitude = amplitude
			_period = period
			_offset = offset
			updateValue()
		}
		
		public function set amplitude(value:Number):void
		{
			_amplitude = value
		}
		
		public function get amplitude():Number
		{
			return _amplitude	
		}
		
		public function set offset(value:Number):void
		{
			_offset = value
		}
		
		public function get offset():Number
		{
			return _offset
		}
		
		public function set period(value:Number):void
		{
			if(time > value)
				time = time % _period
				
			_period = value
		}
		
		public function get period():Number
		{
			return _period
		}
		
		public function set time(value:int):void
		{
			if(_time==value) return
			_time = value % _period
			updateValue()
		}
		
		public function get time():int
		{
			return _time
		}
		
		override public function clone():IGenerator
		{
			var sg:SineGenerator = new SineGenerator(_amplitude,_period,_offset)
			sg.time = time
			return sg
		}
		
		override protected function updateCounter():void
		{
			_time ++
			if(_time==_period)
				_time = 0
		}
		
		override protected function updateValue():void
		{
			_value = Math.sin(Math.PI * 2 * _time / _period  ) * _amplitude + _offset
		}
	}
}