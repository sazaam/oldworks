package sketchbook
{
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	
	/**
	 * Sketchbookで使用する<code>stage</code>の参照を持つクラス。
	 * 
	 * <p>sketchbookライブラリを使用する場合は、一番最初にこのクラスを初期化してください。</p>
	 * 
	 * @see flash.display.Stage
	 */
	public class SketchBook
	{
		private static var _stage:Stage
		
		/**
		 * sketchbookを使用する準備をします。
		 * 
		 * <p>SpriteHelper等を使用する為には、まずこの関数を呼び出す必要があります。
		 * 初期化後はSketchBook.stageを通じて、addChild前のDeisplayObjetからもstageを参照することができます。</p>
		 * 
		 * @param Stageの参照 
		 */
		public static function init(stage:Stage):void
		{
			SketchBook._stage = stage
		}
		
		/** stageの参照。この変数を使用する為には<code>Stage.init</code>を通じてあらかじめ初期化を行う必要があります。 */
		public static function get stage():Stage
		{
			if(_stage==null)
				throw new Error("SketchBook is not initialized yet. call SketchBook.init() first.");
			return _stage
		}
		
		/** スケール変更を無効化 */
		public static function noScale():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE
		}
		
		/** 原点を左上に */
		public static function topLeft():void
		{
			stage.align = StageAlign.TOP_LEFT
		}
		
		public static function highQuality():void
		{
			stage.quality = StageQuality.HIGH
		}
		
		/** 描画クオリティをStageQuality.LOWに */
		public static function lowQuality():void
		{
			stage.quality = StageQuality.LOW
		}
		
		public static function mediumQuality():void
		{
			stage.quality = StageQuality.MEDIUM
		}
		
		
		/*
		----------------------------------------------------------
		座標系関数
		----------------------------------------------------------
		 */
		 
		/** グローバル系でのマウスX座標 */
		public static function get mouseX():Number
		{
			return stage.mouseX
		}
		
		/** グローバル系でのマウスY座標 */
		public static function get mouseY():Number
		{
			return stage.mouseY
		}
		
		/** 画面の幅 */
		public static function get stageWidth():Number
		{
			return stage.stageWidth
		}
		
		/** 画面の高さ */
		public static function get stageHeight():Number
		{
			return stage.stageHeight
		}
		
		/** 画面の中央X座標 */
		public static function get centerX():Number
		{
			return stage.stageWidth * 0.5
		}
		
		/** 画面の中央Y座標 */
		public static function get centerY():Number
		{
			return stage.stageHeight * 0.5
		}
		
		public static function set frameRate(value:uint):void
		{
			stage.frameRate = frameRate
		}
		
		public static function get frameRate():uint
		{
			return stage.frameRate
		}
	}
}