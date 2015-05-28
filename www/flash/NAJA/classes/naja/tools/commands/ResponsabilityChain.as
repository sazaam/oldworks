package naja.tools.commands 
{
	import flash.events.IEventDispatcher;
	import naja.tools.commands.I.ICommand;
	import naja.tools.commands.I.ICommands;
	import naja.tools.commands.I.IResponsabilityChain;
	import flash.utils.Dictionary;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author saz
	 */
	public class ResponsabilityChain implements IResponsabilityChain
	{
		protected static var _commandDict:Dictionary
		protected static var _numCommands:int = 0;
		protected static var _chain:ResponsabilityChain;

//////////////////////////////////////////////////////////////STATIC LAUNCH
		public static function execute(command:ICommand):Class
		{
			if (!_chain) {
				_chain = new ResponsabilityChain();
			}
			if (_commandDict == null) {
				_commandDict = new Dictionary();
			}
			if(_commandDict[command]){
				throw new Error("CommandContainer.execute() this command is alrealdy registerd");
				//trace("CHAIN ERROR ::::  Conflict in commands entered in chain")
				//return ResponsabilityChain
			}
			
			_chain.execute(command) ;
			return ResponsabilityChain ;
		}
		
		
		
		public static function clear():void
		{
			for (var i:* in _commandDict) {
				var command:* = _commandDict[i] ;
				if (command as ICommand) {
					var cmd:ICommand = ICommand(command) ;
					cmd.cancel();
					if (command.hasEventListener(Event.COMPLETE)) {
						var cmdDisp:IEventDispatcher = IEventDispatcher(command) ;
						cmdDisp.removeEventListener(Event.CANCEL, _chain.cancelHandler) ;
						cmdDisp.removeEventListener(Event.COMPLETE, _chain.executeHandler) ;
						_numCommands-- ;
						_commandDict[cmd] = null ;
						delete _commandDict[cmd] ;
					}
				}else{
					trace("sa mere pas clean ici") ;
				}
			}
			_commandDict = null;
		}
//////////////////////////////////////////////////////////////EXECUTING
		public function execute(command:ICommand):Boolean
		{
			_commandDict[command] = command;
			_numCommands++;
			command.addEventListener(Event.COMPLETE, executeHandler);
			command.addEventListener(Event.CANCEL, cancelHandler);
			command.execute();
			return true
		}
		public function clear():void
		{
			ResponsabilityChain.clear() ;
		}

//////////////////////////////////////////////////////////////SPECIALS
		public function get numCommands():int
		{
			return _numCommands;
		}
		
		public function dump():void
		{
			for (var i:* in _commandDict) {
				trace(ICommand(_commandDict[i])) ;
			}
		}
		
		public function executeHandler(e:Event):void
		{
			var command:ICommand = ICommand(e.target) ;
			command.removeEventListener(Event.CANCEL, cancelHandler) ;
			command.removeEventListener(Event.COMPLETE, executeHandler) ;
			_numCommands-- ;
			
			_commandDict[command] = null ;
			delete _commandDict[command] ;
		}
		
		public function cancelHandler(e:Event):void 
		{
			trace("YO")
		}
		
//////////////////////////////////////////////////////////////CONSTRUCTOR
		public function ResponsabilityChain() 
		{
			
		}
	}
}