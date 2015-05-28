package of.app.required.steps.I
{
	public interface IStepList
	{
		function add(_step:IStep):IStep
		function remove(_id:Object = null):IStep
	}
}