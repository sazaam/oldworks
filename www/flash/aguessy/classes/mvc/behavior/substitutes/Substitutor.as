package mvc.behavior.substitutes 
{
	
	/**
	 * ...
	 * @author saz
	 */
	public class Substitutor 
	{
		static public var IF:Function = function(thisObj:Object,cond:Boolean,funcTrue:Function,funcFalse:Function = null ):void
		{
			with (thisObj)
			if (cond) {
				try {
					funcTrue() ;
				}catch (e:Error)	{
					trace(e) ;
				}
			}else {
				if(funcFalse != null)
				try {
					funcFalse() ;
				}catch (e:Error)	{
					trace(e) ;
				}
			}
		}
	}
}