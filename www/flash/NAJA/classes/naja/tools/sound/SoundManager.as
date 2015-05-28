package {
    import flash.events.*;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.net.URLRequest;
 
    public class SoundManager{
 
        private var __url:String ;
        private var __song:SoundChannel;
		private var __soundFactory:Sound;
		private var __enabled:Boolean = true;
 
        public function SoundManager(url) {
			__url = url;
            var request:URLRequest = new URLRequest(url);
            __soundFactory = new Sound();
            __soundFactory.addEventListener(Event.COMPLETE, completeHandler) ;
            __soundFactory.addEventListener(Event.ID3, id3Handler) ;
            __soundFactory.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler) ;
            __soundFactory.addEventListener(ProgressEvent.PROGRESS, progressHandler) ;
            __soundFactory.load(request) ;
        }
 
		public function playSound(rep=false):void {
			if(__enabled == true)
            	__song = __soundFactory.play() ;
			if(rep == true)
				__song.addEventListener(Event.SOUND_COMPLETE, repeat ) ;
        }
 
		public function stopSound():void {
            __song.stop();
        }
 
		public function repeat(event:Event):void {
			playSound();
			__song.addEventListener(Event.SOUND_COMPLETE, repeat );
		}
 
		public function enableSound():void{
			__song = __soundFactory.play();
			__enabled = true;
		}
 
		public function disableSound():void{
			__song.stop();
			__enabled = false;
		}
 
        private function completeHandler(event:Event):void {
            trace("completeHandler: " + event);
        }
 
        private function id3Handler(event:Event):void {
            trace("id3Handler: " + event);
        }
 
        private function ioErrorHandler(event:Event):void {
            trace("ioErrorHandler: " + event);
        }
 
        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler: " + event);
        }
    }
}