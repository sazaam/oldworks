package of.app.required.commands.I
{
	import flash.events.Event ;
	
	public interface IResponsabilityChain 
	{
		function clear():void
		function execute(command:ICommand):Boolean ;
		function dump():void ;
		function executeHandler(e:Event):void ;
		function cancelHandler(e:Event):void ;
	}
}