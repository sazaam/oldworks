package aguessy.custom.launch.visuals 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import naja.model.control.context.Context;
	import naja.model.Root;
	import naja.model.XUser;
	import saz.helpers.video.Playable;
	import saz.helpers.video.StreamPlayer;
	
	/**
	 * ...
	 * @author saz
	 */
	public class FLVManager extends Sprite
	{
		private static var __instance:FLVManager;
		internal var user:XUser;
		internal var __tg:Sprite;
		internal var __playable:Playable;
		internal var __player:StreamPlayer;
		internal var __displayer:PlayerGraphics;
		
		private var __stop:MovieClip;
		private var __play:MovieClip;
		private var __seek:MovieClip;
		private var __back:Sprite;
		internal var __finished:Boolean;
		private var __opened:Boolean;
		private var __seekDistance:int;
		private var __volume:MovieClip;
		private var __volumeBar:Sprite;
		private var originalVolumeX:Number;
		private var __nav:Sprite;
		private var __volumeIndicator:MovieClip;
		
		public function FLVManager() 
		{
			__instance = this ;
			user = Root.user ;
			
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
			
			if (!stage) {
				__tg = Context.$get(this).attr( { id:"FLVM", name:"FLVM" } )[0] ;
				Context.$get("#video")[0].addChild(this) ;
			}
		}
		
		private function onStage(e:Event):void 
		{
			initPlayer() ;
		}
		
		private function initPlayer():void
		{
			__player = new StreamPlayer() ;
			__player.init() ;
			__seekDistance = 0 ;
			var s:Sprite = new (user.model.data.loaded["SWF"]["clips"].loaderInfo.applicationDomain.getDefinition("NAV_MC") as Class)() ;
			__displayer = new PlayerGraphics() ;
			__displayer.NAV_MC = s ;
			__displayer.init(this) ;
			
			addEventListener(MouseEvent.ROLL_OVER, onOver) ;
			addEventListener(MouseEvent.ROLL_OUT, onOver) ;
		}
		
		public function open(url:String):void
		{
			__displayer.drawVideo() ;
			__player.play(url) ;
			__opened = true ;
		}
		
		public function close():void
		{
			__player.stop() ;
			__displayer.drawVideo(false) ;
			__opened = false ;
		}
		
		private function enable(cond:Boolean = true):void
		{
			__nav = __displayer.__nav ;
			if (cond) {
				__back = Sprite(__nav.getChildByName("back")) ;
				__stop = MovieClip(__nav.getChildByName("stop_btn")) ;
				__play = MovieClip(__nav.getChildByName("play_btn")) ;
				__seek = MovieClip(__nav.getChildByName("seek")) ;
				__volume = MovieClip(__nav.getChildByName("volume_btn")) ;
				__volumeBar = MovieClip(__nav.getChildByName("bar")) ;
				__volumeIndicator = MovieClip(__nav.getChildByName("volume_indic")) ;
				
				posVolume(__volumeBar.width * __player.playable.sound.volume) ;
				
				__play.gotoAndStop(0) ;
				__stop.gotoAndStop(0) ;
				__volume.gotoAndStop(0) ;
				
				__play.addEventListener(MouseEvent.CLICK, onOrder) ;
				__stop.addEventListener(MouseEvent.CLICK, onOrder) ;
				__volume.addEventListener(MouseEvent.MOUSE_DOWN,onVolumeDown)
				__volumeBar.addEventListener(MouseEvent.CLICK,onVolumeBar)
				
				__play.addEventListener(MouseEvent.ROLL_OVER, onOrderOver) ;
				__play.addEventListener(MouseEvent.ROLL_OUT, onOrderOver) ;
				__stop.addEventListener(MouseEvent.ROLL_OVER, onOrderOver) ;
				__stop.addEventListener(MouseEvent.ROLL_OUT, onOrderOver) ;
				__volume.addEventListener(MouseEvent.ROLL_OVER, onOrderOver) ;
				__volume.addEventListener(MouseEvent.ROLL_OUT, onOrderOver) ;
				
				__seek.addEventListener(MouseEvent.CLICK, onOrder) ;
				if (!__seek.hasEventListener(Event.ENTER_FRAME)) {
					addEnterFrame() ;
				}
			}else {
				__play.removeEventListener(MouseEvent.ROLL_OVER, onOrderOver) ;
				__play.removeEventListener(MouseEvent.ROLL_OUT, onOrderOver) ;
				__stop.removeEventListener(MouseEvent.ROLL_OVER, onOrderOver) ;
				__stop.removeEventListener(MouseEvent.ROLL_OUT, onOrderOver) ;
				__volume.removeEventListener(MouseEvent.ROLL_OVER, onOrderOver) ;
				__volume.removeEventListener(MouseEvent.ROLL_OUT, onOrderOver) ;
			}
		}
		
		private function onVolumeDown(e:MouseEvent):void 
		{
			originalVolumeX = __volume.x - __volumeBar.x ;
			__nav.addEventListener(Event.ENTER_FRAME, onVolumeChange) ;
			__nav.addEventListener(MouseEvent.MOUSE_UP, onVolumeSet) ;
		}
		
		private function clearVolumeEvents():void
		{
			__nav.removeEventListener(Event.ENTER_FRAME, onVolumeChange) ;
			__nav.removeEventListener(MouseEvent.MOUSE_UP, onVolumeSet) ;
		}
		
		private function onVolumeBar(e:MouseEvent):void
		{
			onVolumeChange(e) ;
			clearVolumeEvents() ;
			setVolume(__volumeBar.mouseX / __volumeBar.width) ;
		}
		
		private function onVolumeChange(e:Event):void 
		{
			if (__nav.getRect(__nav).contains(__nav.mouseX,__nav.mouseY)) {
				posVolume(__volumeBar.mouseX) ;
			}
			else {
				clearVolumeEvents() ;
				posVolume(originalVolumeX) ;
			}
		}
		
		private function posVolume(value:Number):void
		{
			var val:Number = value  ;
			if (val < 0) {
				val = 0 ;
			}
			if (val > __volumeBar.width) {
				val = __volumeBar.width ;
			}
			__volume.x = __volumeBar.x + val ;
			
			__volumeIndicator.width = val ;
		}
		
		private function onVolumeSet(e:MouseEvent):void 
		{
			clearVolumeEvents() ;
			setVolume(__volumeBar.mouseX / __volumeBar.width)
		}
		
		private function setVolume(val:Number):void
		{
			if (val < 0 ) {
				val = 0 ;
			}
			if (val > 1) {
				val = 1 ;
			}
			__player.playable.setSound(val) ;
		}

		private function onVolumeHandle(e:MouseEvent):void 
		{
			posVolume(__volumeBar.mouseX) ;
		}
		
		

		
		private function onOver(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.ROLL_OVER) {
				__displayer.drawNav() ;
				enable() ;
			}else {
				var coords:Point = new Point(e.localX, e.localY) ;
				var rect:Rectangle = getRect(this) ;
				if (!rect.containsPoint(coords)) {
					enable(false) ;
					__displayer.drawNav(false) ;
				}
			}
		}
		
		private function onFrame(e:Event):void 
		{
			var elapsed:Number = __player.playable.ns.time ;
			var total:Number = __player.duration ;
			drawDistance(elapsed, total) ;
			if (elapsed >= total) {
				closeEnterFrame() ;
			}
		}
		
		private function closeEnterFrame():void
		{
			__finished = true ;
			__seek.removeEventListener(Event.ENTER_FRAME, onFrame) ;
		}
		private function addEnterFrame():void
		{
			__finished = false ;
			__seek.addEventListener(Event.ENTER_FRAME, onFrame) ;
		}
		
		private function drawDistance(elapsed:Number,total:Number):void
		{
			var line:Sprite = Sprite(__seek.getChildByName("line")) ;
			var buffer:Sprite = Sprite(__seek.getChildByName("buffer")) ;
			__seekDistance = int(buffer.width / total * elapsed) ;
			line.width = __seekDistance ;
		}
		
		private function onOrderOver(e:MouseEvent):void 
		{
			var s:MovieClip = MovieClip(e.currentTarget) ;
			if (e.type == MouseEvent.ROLL_OVER) {
				s.gotoAndStop("OVER_STATE") ;
			}else {
				s.gotoAndStop(0) ;
			}
		}
		
		private function onOrder(e:MouseEvent):void 
		{
			if (e.currentTarget.name == "seek") {
				var buffer:Sprite = Sprite(__seek.getChildByName("buffer")) ;
				var p:Number = __player.duration / buffer.width * __seek.mouseX ;
				__player.playable.seek(p >= 1? p : 0) ;
				if(!__seek.hasEventListener(Event.ENTER_FRAME)) addEnterFrame() ;
			}
			if (e.currentTarget.name == "stop_btn") {
				__player.playable.stop() ;
				if (__seek.hasEventListener(Event.ENTER_FRAME)) closeEnterFrame() ;
				drawDistance(0, 50) ;
			}
			if (e.currentTarget.name == "play_btn") {
				if (__finished) {
					__player.playable.seek(0) ;
					__player.playable.play() ;
					drawDistance(0, 50) ;
					addEnterFrame() ;
				}else {
					__player.playable.togglePause() ;
				}
			}
		}
		
		///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public static function get instance():FLVManager 
		{
			return __instance || new FLVManager() ;
		}
		
		public function get opened():Boolean { return __opened }
	}
	
}