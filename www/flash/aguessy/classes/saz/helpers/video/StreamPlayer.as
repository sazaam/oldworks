package saz.helpers.video 
{
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import naja.model.control.dialog.ExternalDialoger;
	
	/**
	 * ...
	 * @author saz
	 */
	public class StreamPlayer 
	{
		internal var __vid:Video ;
		internal var __ns:NetStream ;
		private var __client:Object;
		internal var __playable:Playable;
		private var __duration:Number;
		
		public function StreamPlayer() 
		{
			
		}
		
		public function init():void
		{
			var conn:NetConnection = new NetConnection() ;
			conn.connect(null) ;
			
			//	init MainStream
			__ns = new NetStream(conn) ;
			__ns.addEventListener(NetStatusEvent.NET_STATUS, onVideoStatus) ;
			__ns.bufferTime = 1 ;
			//	add MetaData Control
			__client = new Object() ;
			__client.onMetaData = onMetaData ;
			__ns.client = __client ;
			
			//	init Video
			__vid = new Video(420,340) ;
			__vid.smoothing = true ;
			
		}
		
		public function play(url:String):void {
			//trace('FIRST BITCH')
			//
			__vid.attachNetStream(__ns) ;
			__playable = new Playable(url, __ns) ;
			__playable.play() ;
			__playable.setSound(0.24) ;
		}
		public function stop():void {
			__playable.stop() ;
		}
		
		
		
		
		private function onVideoStatus(e:NetStatusEvent):void 
		{
			//trace('SECOND BITCH')
			//trace(e.info.code)
			switch (e.info.code)
			{
				case "NetStream.Play.Start":
					//trace("HEYY STARTED")
				break;
				case "NetStream.Play.Stop":
					//__ns.seek(0) ;
				break;
				case "NetStream.Play.StreamNotFound":
				//
				break;
			}
		}
		
		private function onMetaData(o:Object):void
		{
			//trace('THIRD BITCH') ;
			//trace("METADATA__________________________________") ;
			//for (var i:String in o) {
				//trace(i + "  >>  " + o[i]) ;
			//}
			//trace("END METADATA__________________________________") ;
			//__vid.width = _data.width ;
			//__vid.height = _data.height ;
			__ns.bufferTime = ExternalDialoger.calculateBuffer(Math.round(o.duration), o.videodatarate) ;
			__duration = o.duration ;
			//var e:Event = new Event(Event.CONNECT) ;
			//__vid.dispatchEvent(e) ;
		}
		
		public function get video():Video { return __vid; }
		public function set video(value:Video):void 
		{ __vid = value	}
		
		public function get playable():Playable { return __playable }
		
		public function set playable(value:Playable):void 
		{ __playable = value } 
		
		public function get duration():Number { return __duration }
	}
}