package testing 
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author saz
	 */
	public class TestBitmapPerfectReflect 
	{
		private var __target:Sprite;
		
		public function TestBitmapPerfectReflect(tg:Sprite) 
		{
			__target = tg ;
			
			var s:Sprite = new Sprite() ;
			s.x = 100 ;
			s.y = 100 ;
			
			var shape:Shape = initShape() ;
			s.addChild(shape) ;
			
			var tf:TextField = initTextField() ;
			tf.x = (shape.width - tf.width) >> 1 ;
			tf.y = (shape.height - tf.height) >> 1 ;
			s.addChild(tf) ;
			
			
			
			var reflect:Bitmap = new Reflect(s).toBitmap('auto', true) ;
			reflect.x = 100 ;
			reflect.y = 210 ;
			
			var reflect2:Bitmap = new Reflect(s, true, 1).toBitmap('auto', true) ;
			reflect2.x = 210 ;
			reflect2.y = 100 ;
			
			
			__target.addChild(s) ;
			__target.addChild(reflect) ;
			__target.addChild(reflect2) ;
		}
		
		private function initTextField():TextField 
		{
			var tf:TextField = new TextField() ;
			var fmt:TextFormat = tf.defaultTextFormat ;
			fmt.color = 0xFFFFFF ;
			fmt.font = 'Neo Tech Dacia Regular' ;
			fmt.size = 55 ;
			fmt.align = 'center';
			tf.autoSize = 'left' ;
			fmt.leftMargin = fmt.rightMargin = 15 ;
			tf.defaultTextFormat = fmt ;
			tf.selectable = false ;
			tf.text = 'Ps' ;
			return tf ;
		}
		
		private function initShape():Shape
		{
			var shape:Shape = new Background(100, 100) ;
			return shape ;
		}
	}
}

//////////////////////////////////////////////////
// Backgroundクラス
//////////////////////////////////////////////////

import flash.display.Shape;
import flash.geom.Matrix;
import flash.display.GradientType;

class Background extends Shape {
	private static var _width:uint;
	private static var _height:uint;
	private static var color1:uint = 0x77B2EE;
	private static var color2:uint = 0x3F68AB ;

	public function Background(w:uint, h:uint) {
		_width = w;
		_height = h;
		draw();
	}

	private function draw():void {
		var colors:Array = [color1, color2];
		var alphas:Array = [1, 1];
		var ratios:Array = [0, 255];
		var matrix:Matrix = new Matrix();
		matrix.createGradientBox(_width, _height, 0.5*Math.PI, 0, 0);
		graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
		graphics.drawRect(0, 0, _width, _height);
		graphics.endFill();
	}

}