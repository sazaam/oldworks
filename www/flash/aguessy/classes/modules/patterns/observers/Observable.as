package modules.patterns.observers
{
	public interface Observable
	{
		function addObserver(o:Observer):void;
		
		function clearChanged():void;
		
		function countObservers():int;
		
		function deleteObservers():void;
		
		function hasChanged():Boolean;
		
		function removeObserver(o:Observer):void;
		
		function notifyObservers(arg:Object=null):void;
		
		function setChanged():void;
	}
}