package of.app.required.steps.I
{
	public interface IBasicStep 
	{
		function open():void ;
		function close():void ;
		function dispatchOpen():void ;
		function dispatchClose():void ;
		function dispatchCancel():void ;
	}
}