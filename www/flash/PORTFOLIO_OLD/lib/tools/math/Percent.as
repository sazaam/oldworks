package tools.math 
{
	
	/**
	 * ...
	 * @author saz
	 */
	public class Percent 
	{
		static public function percent(val1:Number , valTotal:Number = 100, o:Object = null ):Number
		{
			if (!Boolean(o)) return val1 / valTotal ;
			if (!isNaN(o)) return (val1 - o) / (valTotal - o) ;
			return Percent.percentCalculate(val1 / valTotal , o ) ;
		}
		
		static public function percentCalculate( ratio:Number, o:Object):Number
		{
			var min:Number = o.start ;
			var max:Number = o.end ;
			var total:Number = o.end - o.start ;
			var r:Number = (ratio * total ) + o.start ;
			return r ;
		}
	}
}