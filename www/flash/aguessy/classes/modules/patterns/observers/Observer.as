package modules.patterns.observers
{
	public interface Observer
	{
		/**
		 * A class can implement the Observer interface when it wants to be informed 
		 * of changes in observable objects.
		 */
		function update(o:Observable, arg:Object=null):void;
	}
}