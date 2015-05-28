package of.app 
{
	/**
	 * ...
	 * @author saz-ornorm
	 */
	import of.app.required.commands.Command;
	import of.app.required.commands.I.ICommand;
	import of.app.required.steps.VirtualSteps;
	
	public class XUnique extends VirtualSteps
	{
		public function XUnique(_id:String = null, _open:ICommand = null, _close:ICommand = null) 
		{
			if (_id == null) _id = 'ALL' ;
			if (_open == null) _open = new Command(this, function():void{ trace('site opened from commandopen')}) ;
			if (_close == null) _close = new Command(this, function():void{ trace('site closed from commandclose  -  but normally u never need that !...')}) ;
			super(_id, _open, _close) ;
			
			add(new VirtualSteps("HOME", new Command(this, function():void{ trace('home opened')}), new Command(this, function():void{ trace('home closed')}))) ;
		}
	}
}