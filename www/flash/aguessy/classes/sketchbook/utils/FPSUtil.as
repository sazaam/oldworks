package sketchbook.utils
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * FPSを計測するユーティリティクラスです。
	 * FPSUtilを使用する場合は、まずFPSUtil.initを呼んで初期化を行ってください。
	 * 
	 * FPSUtil.init( stage );	//Event.ENTER_FRAMEの為の初期化, 30フレーム分の平均値でFPSを算出
	 * trace( FPSUtil.fps );
	 */
	public class FPSUtil
	{
		protected static var _initialized:Boolean = false;
		protected static var _timer:Timer
		
		protected static var _enterFrameCount:int = 0;
		
		protected static var _sampleFrameNum:int	//FPS計測を何フレームの平均値とするか
		protected static var _times:Array	
		
		protected static var _needUpdate:Boolean = true;
		protected static var _fps:Number = 0;
		
		
		
		/**
		 * FPSUtilにStageのEvent.ENTER_FRAMEを結びつけて初期化します。
		 * 
		 * @param stage Stageの参照
		 * @param sampleFrameNum フレームレートの計測に何フレーム分の平均値を用いるか
		 */
		public static function init( stage:Stage ):void
		{
			
			if( _initialized == true ) 
				return
				
			_timer = new Timer(1000,0);
			_timer.addEventListener(TimerEvent.TIMER, function(e:Event):void{update()});
			_timer.start();

			stage.addEventListener(Event.ENTER_FRAME, function(e:Event):void{onEnterFrame()});
			_initialized = true;
		}
		
		
		/**
		 * FPSを取得
		 * 
		 * @return Number
		 */
		public static function getFPS():Number
		{
			return _fps;
		}
		
		/**
		 * FPSを取得のGetter版
		 */
		public static function get fps():Number
		{
			return _fps;
		}
		
		
		/**
		 * ---------------------------------------------------------
		 * INTERNAL USE ONLY
		 * ---------------------------------------------------------
		 */
		
		protected static function onEnterFrame():void
		{
			_enterFrameCount++
		}
		
		protected static function update():void
		{
			_fps = _enterFrameCount;
			
			_enterFrameCount = 0;
		}
		
		
	}
}