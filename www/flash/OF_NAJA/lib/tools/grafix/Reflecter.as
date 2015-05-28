package tools.grafix 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.IBitmapDrawable;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author saz-ornorm
	 */
	public class Reflecter
	{
		
		public function Reflecter() 
		{
			throw(new IllegalOperationError('Reflecter is not instanciable...'))
		}
		
		static public function make(obj:IBitmapDrawable):BitmapData
		{
			var source:BitmapData ;
			var output:BitmapData ;
			if (obj is Bitmap) {
				source = Bitmap(obj).bitmapData;
			}else if (obj is BitmapData){
				source = obj ;	
			}else if (obj is Sprite) {
				
			}
			var w:int = source.width ;
			var h:int = source.height ;
			output = new Bitmap(new BitmapData(w, h, true, 0xFFFFFF), PixelSnapping.NEVER, true).bitmapData ;
			//output = new Bitmap(source.clone(), 'auto', true).bitmapData ;
			var flipMatrix:Matrix = new Matrix(1, 0, 0, -1, 0, h) ;
			output.draw( source, flipMatrix, new ColorTransform(1, 1, 1, .3)) ;
			var gradientMatrix:Matrix = new Matrix() ;
			gradientMatrix.createGradientBox( w, h, Math.PI / 2 ) ;
			var shape:Shape = new Shape() ;
			shape.graphics.beginGradientFill( GradientType.LINEAR, [ 0xFFFFFF, 0xd3d3d3 ], [ 0, 50], [ 0,255], gradientMatrix) ;
			shape.graphics.drawRect(0, 0, w, h) ;
			shape.graphics.endFill() ;
			output.draw(shape, null, null, BlendMode.ERASE) ;
			
			return output ;
		}
	}
}