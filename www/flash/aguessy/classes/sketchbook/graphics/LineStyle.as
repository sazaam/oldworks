package sketchbook.graphics
{
	import flash.display.Sprite;
	import flash.display.LineScaleMode;
	import flash.display.JointStyle;
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	
	/**
	 * Graphics.setLineStyleをクラス化したもの
	 * applySettingでGraphicsインスタンスに設定を注入する。
	 */
	public class LineStyle
	{
		public var thickness:Number
		public var color:uint
		public var alpha:Number
		public var pixelHinting:Boolean
		public var scaleMode:String
		public var caps:String
		public var joints:String
		public var miterLimit:Number
		
		public static const SCALE_MODE_HORIZONTAL:String = LineScaleMode.HORIZONTAL
		public static const SCALE_MODE_NONE:String = LineScaleMode.NONE
		public static const SCALE_MODE_NORMAL:String = LineScaleMode.NORMAL
		public static const SCALE_MODE_VERTICAL:String = LineScaleMode.VERTICAL
		
		public static const JOINTS_BEVEL:String = JointStyle.BEVEL
		public static const JOINTS_MITER:String = JointStyle.MITER
		public static const JOINTS_ROUNT:String = JointStyle.ROUND
		
		public static const CAPS_NONE:String = CapsStyle.NONE
		public static const CAPS_ROUND:String = CapsStyle.ROUND
		public static const CAPS_SQUARE:String = CapsStyle.SQUARE
		
		public function LineStyle(thickness:Number=0, 
				color:uint=0, 
				alpha:Number=1.0, 
				pixelHinting:Boolean=false,
				scaleMode:String="normal",
				caps:String=null,
				joints:String=null,
				miterLimit:Number=3.0)
		{
			this.thickness = thickness
			this.color = color
			this.alpha = alpha
			this.pixelHinting = pixelHinting
			this.scaleMode = scaleMode
			this.caps = caps
			this.joints = joints
			this.miterLimit = miterLimit
		}
		
		/**
		 * 対象のGraphicsインスタンスの、lineStyleを実行します。
		 * 渡されるパラメーターはこのインスタンスのプロパティです。
		 */
		public function applySetting(g:Graphics):void
		{	
			g.lineStyle( 
				thickness, 
				color, 
				alpha, 
				pixelHinting,
				scaleMode,
				caps,
				joints,
				miterLimit
				)
		}
		
		public function clone():LineStyle
		{
			return new LineStyle(thickness,color,alpha,pixelHinting,scaleMode,caps,joints,miterLimit)
		}
	}
}