package sketchbook.graphics
{
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.InterpolationMethod;
	
	public class GradientFill
	{
		public var type:String
		public var colors:Array
		public var alphas:Array
		public var ratios:Array
		public var matrix:Matrix
		public var spreadMethod:String
		public var interpolationMethod:String="rgb"
		public var focalPointRatio:Number
		
		public static const TYPE_LINEAR:String = GradientType.LINEAR
		public static const TYPE_RADIAL:String = GradientType.RADIAL
		
		public static const SPREAD_METHOD_PAD:String = SpreadMethod.PAD
		public static const SPREAD_METHOD_REFLECT:String = SpreadMethod.REFLECT
		public static const SPREAD_METHOD_REPEAT:String = SpreadMethod.REPEAT
		
		public static const INTERPOLATION_METHOD_LINEAR_RGB:String = InterpolationMethod.LINEAR_RGB
		public static const INTERPOLATION_METHOD_RGB:String = InterpolationMethod.RGB
		
		public function GradientFill(type:String,colors:Array,alphas:Array,ratios:Array,matrix:Matrix=null,spreadMethod:String="pad",interpolationMethod:String="rgb",focalPointRatio:Number=0)
		{
			this.type = type
			this.colors = colors
			this.alphas = alphas
			this.ratios = ratios
			this.matrix = matrix
			this.spreadMethod = spreadMethod
			this.interpolationMethod = interpolationMethod
			this.focalPointRatio = focalPointRatio
		}
		
		public function applySetting(g:Graphics):void
		{
			g.beginGradientFill(type,colors,alphas,ratios,matrix,spreadMethod,interpolationMethod,focalPointRatio)	
		}
		
		public function clone():GradientFill
		{
			return new GradientFill(type,colors,alphas,ratios,matrix,spreadMethod,interpolationMethod,focalPointRatio)
		}
	}
}