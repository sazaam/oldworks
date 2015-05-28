package saz.helpers.math 
{
	
	/**
	 * ...
	 * @author saz
	 */
	public class Percent 
	{
		static public function percent(val1:Number , valTotal:Number, limitObj:Object = null ):Number
		{
			return (limitObj)? Percent.percentLimited(val1 / valTotal , limitObj ) :  (val1 / valTotal)*100 ;
		}
		
		static private function percentLimited( num:Number, limitObj:Object):Number
		{
			var min:Number = limitObj.start ;
			var max:Number = limitObj.end ;
			var range:Number = max - min ;
			return (num*range) ;
		}
	}
}