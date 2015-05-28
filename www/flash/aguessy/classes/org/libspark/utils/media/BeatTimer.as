package org.libspark.utils.media
{
	import flash.utils.getTimer;
	
	public class BeatTimer
	{
		public function BeatTimer()
		{
		}
		
		private var _bpm:Number;
		private var _startTime:uint;
		private var _beatPosition:Number;
		private var _phase:Number;
		private var _isOnBeat:Boolean = false;
		
		public function get bpm():Number
		{
			return _bpm;
		}
		
		public function get beatPosition():Number
		{
			return _beatPosition;
		}
		
		public function get phase():Number
		{
			return _phase;
		}
		
		public function get isOnBeat():Boolean
		{
			return _isOnBeat;
		}
		
		public function start(bpm:Number):void
		{
			_bpm = bpm;
			_startTime = getTimer();
			update();
		}
		
		public function update():void
		{
			var currentTime:uint = getTimer();
			var beatInterval:Number = (60 * 1000) / _bpm;
			var oldPosition:Number = _beatPosition;
			
			_beatPosition = (currentTime - _startTime) / beatInterval;
			_phase = _beatPosition - int(_beatPosition);
			_isOnBeat = int(oldPosition) != int(_beatPosition);
		}
	}
}