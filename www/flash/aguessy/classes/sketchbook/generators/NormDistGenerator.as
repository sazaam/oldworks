package sketchbook.generators
{
	/**
	 * 正規分布の乱数を生成するGenerator。
	 * 
	 * @example <listing version="3.0">offset + (-1 ～ 1 ) * amplitude + offset</listing>
	*/
	public class NormDistGenerator extends Generator
	{
		private var amplitude:Number
		private var offset:Number
		
		public function NormDistGenerator(amplitude:Number, offset:Number):void
		{
			this.amplitude = amplitude
			this.offset = offset
			
			updateValue()	
		}
		
		override public function clone():IGenerator
		{
			return new NormDistGenerator(amplitude, offset)
		}
		
		override protected function updateValue():void
		{
			_value = getNormDist()*amplitude + offset
		}
		
		private function getNormDist():Number
		{
			return (Math.random()+Math.random()+Math.random()+Math.random()+Math.random()+Math.random())/3 - 1
		}
		
	}
}