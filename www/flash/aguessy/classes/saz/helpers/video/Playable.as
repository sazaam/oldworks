package saz.helpers.video 
{
	import flash.net.*
	import flash.media.*
	
	/**
	* @author saz
	*/
	public class Playable 
	{
		internal var __ns:NetStream
		internal var __url:String
		internal var __muted:Boolean = false
		
		public function Playable(_url:String,_ns:NetStream)
		{
			__ns = _ns ;
			__url = _url ;
		}

		public function play():void
		{
			__ns.play(__url) ;
		}
		
		public function halt():void
		{
			__ns.pause() ;
		}
		
		public function togglePause():void
		{
			__ns.togglePause() ;
		}
		
		public function resume():void
		{
			__ns.resume() ;
		}
		
		public function toggleSound()
		{
			if (__muted) __ns.soundTransform = new SoundTransform(1) ;
			else __ns.soundTransform = new SoundTransform(0) ;
			__muted = !__muted ;
		}
		
		public function seek(_num:Number):void
		{
			__ns.seek(_num) ;
		}
		public function stop():void
		{
			halt() ;
			__ns.seek(.0) ;
		}
		public function abandon():void
		{
			__ns.close() ;
		}
		
		public function get url():String { return __url }
		
		public function set url(value:String):void 
		{
			__url = value ;
		}
		
		public function get ns():NetStream { return __ns }
		
		public function set ns(value:NetStream):void 
		{
			__ns = value
		}
		
		public function get sound():SoundTransform { return __ns.soundTransform }
		public function set sound(value:SoundTransform):void 
		{
			__ns.soundTransform = value;
		}
		
		public function setSound(value:Number, pan:Number = 0):void
		{
			sound = new SoundTransform(value,pan) ;
		}
	}
}