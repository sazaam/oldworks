package saz.geeks.sounds 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author saz
	 */
	public class SoundDisplayer 
	{
		private var channel			:SoundChannel
		private var control			:SoundTransform
		private var noFFTbytes		:ByteArray
		private var sound			:Sound
		private var req				:URLRequest
		private var source 			:String
		
		public var lp				:Number
		public var rp				:Number
		
		public function SoundDisplayer(_source:String = null) 
		{
			if(_source) source = _source
			sound 					= new Sound();
			channel 				= new SoundChannel();
		}
		
		public function load(_source:String = null):void {
			trace(_source)
			source = _source || source
			if (source) {
				req	= new URLRequest(source);
				sound.load(req);
				play()
			}else{trace("No SOURCE Defined yet...")}
			
			//snd.addEventListener(Event.ID3,onID3)
		}
		
		public function seekSpectrum():ByteArray
		{
			noFFTbytes 		= new ByteArray();
			SoundMixer.computeSpectrum(noFFTbytes, false, 2);
			return noFFTbytes
		}
		
		private function onSpectrum():void
		{
			noFFTbytes 		= new ByteArray();
			lp = channel.leftPeak
			rp = channel.rightPeak
		}
		
		public function play():void
		{
			channel = sound.play()
			channel.addEventListener(Event.SOUND_COMPLETE , replay);
			volume(.5)
		}
		
		public function volume(_newVol:Number):void
		{
			control = channel.soundTransform
			control.volume = _newVol
			channel.soundTransform = control
		}
		
		
		public function replay(e:Event = null):void {
			channel = sound.play();
		}
	}
	
}