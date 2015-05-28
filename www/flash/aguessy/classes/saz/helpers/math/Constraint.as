package saz.helpers.math 
{
	
	/**
	 * ...
	 * @author saz
	 */
	public class Constraint 
	{
		static public function constraint(_num:Number, max:Number, min:Number = 0 ):Number
		{
			if (_num >= max) _num = max
			else if (_num <= min) _num = min
			return (!isNaN(_num))? _num : 0 ;
		}
		
		static public function constraintFilter(_num:Number, max:Number, min:Number = 0 ):Boolean
		{
			var val:Boolean
			if (_num < max) val = false
			else if (_num < min) val = false
			else val = true
			return val
		}
	}
	
}