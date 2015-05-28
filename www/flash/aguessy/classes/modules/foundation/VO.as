/**
 * @author biendo@fullsix.com 
 */
package modules.foundation
{
	public interface VO
	{
		function getClass():Type;
		
		function toSource():String;
			
		function toString():String;
				
		function valueOf():Object;
	}
}