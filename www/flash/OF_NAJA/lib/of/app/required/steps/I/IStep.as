package of.app.required.steps.I
{
	import of.app.required.steps.VirtualSteps ;
	
	public interface IStep extends IBasicStep
	{
		function cancel():Boolean ;
		function get opened():Boolean ;
		function get id():Object ;
		function get parent():VirtualSteps ;
		function set parent(v:VirtualSteps):void ;
		function get index():int ;
		function set index(value:int):void ;
		function get depth():int ;
		function set depth(value:int):void ;
		function play():void ;
		function stop():void ;
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void ;
	}
}