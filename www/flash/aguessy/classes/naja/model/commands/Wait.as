package naja.model.commands
{
	
	/**
	 * ...
	 * @author saz
	 */
	public function Wait(_time:Number = 1000):WaitCommand 
	{
		return new WaitCommand( _time ) ;
	}
}