package naja.model.steps.I
{
	
	/**
	 * ...
	 * @author saz
	 */
	public interface IBasicStep 
	{
		function open():void ;
		function close():void ;
		function dispatchStep():void ;
		function dispatchClose():void ;
		function dispatchCancel():void ;
	}
	
}