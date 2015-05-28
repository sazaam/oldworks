package saz.helpers.keys 
{
	
	/**
	 * ...
	 * @author saz
	 */
    
    import flash.events.*;
    import flash.display.*;
    import flash.utils.*;

	
	public class KeyCommand extends EventDispatcher
    {        
        
        public static var KONAMI_COMMAND:Array =  [
            {code:38},
            {code:38},
            {code:40},
            {code:40},
            {code:37},
            {code:39},
            {code:37},
            {code:39},
            {code:66},
            {code:65}

        ]; //

        private var _command:Array;
        private var _timeout:Number;
        private var _stage:Stage;
        private var _keyHistory:Array;
        private var _timeoutTimer:Timer;

        /**
         * 
         *
         * @param command 
         * @param stage 
         * @param timeout
		 * 
		 * USE : 
		 * 
			//  ¤ the base Konami static
		
			var k1:KeyCommand = new KeyCommand(KeyCommand.KONAMI_COMMAND, stage, 2000);
            k1.addEventListener(Event.COMPLETE, function(e:Event):void {
                trace("???????!!!");
            });

            // ¤ or gliss the KeyCode like this 
			
            var k2:KeyCommand = new KeyCommand(
                [{code:38}, {code:40}, {code:66, shift:true}, {code:65, shift:true}],
                stage, 5000);
			
			// then add an event to the keyControl(s)
			
            k2.addEventListener(Event.COMPLETE, function(e:Event):void {
                trace("command!!!")
            })
		 * 
         */
		public function KeyCommand(command:Array, stage:Stage, timeout:Number = 0 )
        {
            _command = command;
            _timeout = timeout;
            _keyHistory = [];
            _stage = stage;
            _stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDwonHandler);
            if (timeout != 0) {
				_timeoutTimer = new Timer(_timeout);
				_timeoutTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			}
            
		}
        

        private function keyDwonHandler(e:KeyboardEvent):void
        {
            
            if (_timeoutTimer != null) {
				_timeoutTimer.reset();
				if (!_timeoutTimer.running) _timeoutTimer.start();
			}
           
            if (e.keyCode == 16) return; // 16 = shift
            
            _keyHistory.push(e.keyCode);

            if (_keyHistory.length > _command.length) _keyHistory.shift();

            var flag:Boolean = true;
            var i:int = 0;
            var l:int = _command.length;

            for (i; i<l; i++)
            {
                if (_keyHistory[i] != _command[i].code)
                {
                    flag = false;
                    break;
                } else {
                    if(_command[i].shift)
                    {
                        if (!e.shiftKey)
                        {
                            flag = false;
                            break;
                        }
                    }
                }
            }

            if (flag) commandSuccess();
        }


        private function commandSuccess():void
        {
            dispatchEvent(new Event(Event.COMPLETE));
        }

        private function timerHandler(e:TimerEvent):void
        {
            _keyHistory = [];
            _timeoutTimer.stop();
        }

        
		override public function toString():String
        {
			return "[KeyCommand] command :" + _command;
		}
	}
}