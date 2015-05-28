package of.app.required.commands 
{

	 
	//////////////////////////////////////////////////////// WAIT
	/**
	* Creates a WaitCommand
	* 
	* @param time Number - The dalay in milliseconds
	* @return WaitCommand
	*/	
	public function Wait(time:Number = 1000):WaitCommand 
	{
		return new WaitCommand( time ) ;
	}
}