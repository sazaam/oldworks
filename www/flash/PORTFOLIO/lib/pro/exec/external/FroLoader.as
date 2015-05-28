package pro.exec.external
{
	import flash.display.CapsStyle;
	import flash.display.IBitmapDrawable;
	import flash.display.JointStyle;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import frocessing.color.FColor;
	import frocessing.display.F5MovieClip2D;
	
	public class FroLoader extends F5MovieClip2D
	{
		private static var __sizeRect:Rectangle = new Rectangle(0, 0, 60,60) ;
		private var t:Number = 0;
		private var n:int = 12;
		private var to:int = 255;
		private var radius:Number;
		private	var eachWidth:Number;
		private	var eachHeight:Number;
		private var rotationPt:Point;
		private var rndCor:Number;
		private var col:uint ;
		private var alphas:Array = [] ;
		
		
		public function FroLoader(dimensions:Rectangle = null, diameter:Number = NaN, itemWidth:Number = NaN, itemHeight:Number = NaN, rotationPoint:Point = null, roundRectIndix:Number = NaN, color:uint = 0xAAAAAA)
		{
			if (dimensions) {
				__sizeRect = dimensions ;
			}
			initialSettings() ;
			x = __sizeRect.x ;
			y = __sizeRect.y ;
			eachWidth = itemWidth || 5 ;
			eachHeight = itemHeight || 5 ;
			rotationPt = rotationPoint || new Point() ;
			rndCor = roundRectIndix || 1 ;
			radius = diameter || (__sizeRect.width / 2) - Math.max(eachWidth, eachHeight) ;
			
			col = color ;
		}
		
		private function initialSettings():void 
		{
			size(__sizeRect.width, __sizeRect.height) ;
		}
		public function setup():void 
		{
			loaderSetup() ;
		}
		private function loaderSetup():void 
		{
			makeAlphas();
		}
		private function makeAlphas():void
		{
			for (var i:int = 0; i <= n; i++)
			{
				alphas.push(i/n + 0.1);
			}
		}
		public function draw():void
		{
			translate( fg.width / 2, fg.height / 2 ) ;
			for (var i:int  = 0; i <= n; i++)
			{
				rotate( -Math.PI * 2 / n) ;
				lineStyle(eachHeight, col, alphas[(t + i) % n], false, 'none', CapsStyle.SQUARE, JointStyle.MITER, 10) ;
				translate(rotationPt.x, rotationPt.y) ;
				line(rotationPt.x+radius, rotationPt.y+0, rotationPt.x+radius+eachWidth, rotationPt.y+0) ;
			}
			if (++t == 24) t = 0;
		}
	}
}
