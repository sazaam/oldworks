package mvc.structure.data.I 
{
	
	/**
	 * ...
	 * @author saz
	 */
	public interface ILoopable 
	{
		function hasNext():Boolean;
		function next():int ;
		function hasPrev():Boolean ;
		function prev():int ;
	}
}