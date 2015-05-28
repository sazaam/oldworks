package saz.helpers.layout.layers.I 
{
	
	/**
	 * ...
	 * @author saz
	 */
	public interface ILayer 
	{
		function show(instantly:Boolean = true, transitionObj:Object = null) ;
		function hide(instantly:Boolean = true, transitionObj:Object = null) ;
		//function init(_xml:XML) ;
	}
	
}