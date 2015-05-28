package naja.model.commands.I
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author saz
	 */
	public interface IResponsabilityChain 
	{
		function clear():void
		function execute(command:ICommand):Boolean ;
		function dump():void ;
		function executeHandler(e:Event):void ;
		function cancelHandler(e:Event):void ;
	}
	
}