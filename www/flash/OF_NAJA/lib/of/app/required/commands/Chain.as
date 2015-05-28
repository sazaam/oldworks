package of.app.required.commands 
{
	import of.app.required.commands.I.IBasicCommand ;
	
	public function Chain(command:ICommand = null):Class
	{
		return command? Class(ResponsabilityChain.execute(command)) : ResponsabilityChain ;
	}
}