package of.app 
{
	/**
	 * ...
	 * @author saz-ornorm
	 */
	import of.app.required.commands.Command;
	import of.app.required.commands.I.ICommand;
	import of.app.required.steps.SectionsController;
	import of.app.required.steps.VirtualSteps;
	
	public class XUnique extends VirtualSteps
	{
		public function XUnique(_id:String = null, _open:ICommand = null, _close:ICommand = null) 
		{
			if (_id == null) _id = 'SWFAddress' ;
			if (_open == null) _open = new Command(this, function():void{ trace('site opened from commandopen')}) ;
			if (_close == null) _close = new Command(this, function():void { trace('you just closed site via its root commandclose, ... very weird  -   normally u never need that !...') } ) ;
			path = _id ;
			super(_id, _open, _close) ;
		}
		
		public function addHome(closure:Function = null):void 
		{
			if (closure==null) closure = function(cond:Boolean = true):void{ trace('home opened')}
			add(new VirtualSteps("HOME", new Command(this, closure), new Command(this, closure, false))) ;
		}
	}
}