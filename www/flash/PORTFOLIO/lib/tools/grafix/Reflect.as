package tools.grafix 
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.IBitmapDrawable;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Reflect extends DirectionBitmapData 
	{
		public function Reflect(src:IBitmapDrawable, invert:Boolean = true, mode:Number = -1, alphas:Array = null, ratios:Array = null) 
		{
			if (mode == -1 && Boolean(invert)) mode = Y_AXIS_INVERTED ;
			super(src, mode) ;
			init(mode, alphas, ratios) ;
		}
		
		private function init(mode:int, alphas:Array = null, ratios:Array = null):void 
		{
			drawReflectGradient(mode, alphas, ratios) ;
		}
		
		private function drawReflectGradient(mode:int, alphas:Array = null, ratios:Array = null):void 
		{
			var matrix:Matrix = new Matrix() ;
			var colors:Array = [0xFFFFFF, 0x0] ;
			alphas = alphas || [.25, 0] ;
			ratios = ratios || [0, 255] ;
			
			var rotation:Number ;
			switch(mode) {
				case X_AXIS_INVERTED :
					rotation = 0 ;
				break;
				case Y_AXIS_INVERTED:
					rotation = Math.PI * .5 ;
				break;
				default:
					rotation = -Math.PI * .5 ;
				break;
			}
			
			var sh:Shape = new Shape() ;
			
			matrix.createGradientBox(dimensions.width, dimensions.height, rotation, 0, 0) ;
			sh.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix) ;
			sh.graphics.drawRect(0, 0, dimensions.width, dimensions.height) ;
			sh.graphics.endFill() ;
			
			draw(sh, null, null, 'alpha' ,null,true) ;
		}
	}
}