package naja.model.steps.I
{
	/**
	 * ...
	 * @author saz
	 */
	public interface IStepList
	{
		function add(_step:IStep):IStep
		function remove(_id:Object = null):IStep
	}
	
}