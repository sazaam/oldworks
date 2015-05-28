package naja.model.commands.I
{
	
	/**
	 * ...
	 * @author saz
	 */
	public interface IBasicCommand 
	{
		function dispatchComplete():void ;
		function dispatchCancel():void ;
	}
	
}