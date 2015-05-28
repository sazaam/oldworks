package project 
{
	import f6.io.InputStream;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mvc.behavior.commands.Chain;
	import mvc.behavior.commands.Command;
	import mvc.behavior.commands.CommandQueue;
	import mvc.behavior.commands.I.ICommand;
	import mvc.behavior.commands.ResponsabilityChain;
	import mvc.behavior.commands.Wait;
	import mvc.behavior.commands.WaitCommand;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Test extends MovieClip
	{
		private var index:int;
		private var queue:CommandQueue;
		
		public function Test() 
		{
			var command:WaitCommand = new WaitCommand(1000) ;
			var command2:Command = new Command(this , launch) ;
			var command3:Command = new Command(this , function(){trace('azfouhaozefuba')}) ;
			
			queue = new CommandQueue(command2,Wait(2000),Wait(2000),command2,Wait()) ;
			queue.add(command3) ;
			
			
			//Chain(command).execute(command2).execute(command).execute(command2).execute(command2) ;
			stage.addEventListener(MouseEvent.CLICK, onStageClicked) ;
			
			//queue.execute() ;
			Chain(queue);
		}
		
		private function launch():void
		{
			index = 0
			test.addEventListener(Event.ENTER_FRAME, onFrame) ;
			queue.addEventListener(Event.CANCEL, onFrame) ;
		}
		
		private function onFrame(e:Event):void 
		{
			if (e.type == Event.ENTER_FRAME) {
				if (index < 50) {
					test.x = index ;
					index++ ;
				}else {
					index = 0 ;
					test.removeEventListener(Event.ENTER_FRAME, arguments.callee) ;
					queue.removeEventListener(Event.CANCEL, arguments.callee) ;
				}
			}else {
				index = 0 ;
				queue.addEventListener(Event.CANCEL, arguments.callee) ;
				test.removeEventListener(Event.ENTER_FRAME, arguments.callee) ;
			}
		}
		
		private function onStageClicked(e:MouseEvent):void 
		{
			Chain().clear() ;
			//queue.cancel();
		}
		
	}
	
}