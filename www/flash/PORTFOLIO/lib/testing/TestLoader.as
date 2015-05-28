/**
 * Copyright hacker_tmbt9fl2 ( http://wonderfl.net/user/hacker_tmbt9fl2 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/3e4r
 */

// forked from naoto5959's Frocessing勉強中(ローディングのやつを作ってみる)
package testing
{
	import flash.geom.Rectangle;
	import frocessing.display.*;
	
	/**
	 * FrocessingWork2
	 * 24色がクルクルする練習。
	 * @author Copyright (C) naoto koshikawa, All Rights Reserved.
	 */
	public class TestLoader extends F5MovieClip3D
	{
		private static var __sizeRect:Rectangle = new Rectangle(100, 100, 60,60) ;
		private var t:Number = 0;
		private var n:int = 12;
		private var to:int = 255;
		private var radius:Number;
		private	var eachWidth:Number = 5;
		private	var eachHeight:Number = 5;
		
		private var alphas:Array = [];
		
		public function TestLoader() 
		{
			x = __sizeRect.x ;
			y = __sizeRect.y ;
			radius = (__sizeRect.width / 2) - eachWidth ;
		}
		private function test():void 
		{
			beginBitmapFill() ;
			//triangle
		}
		public function setup():void 
		{
			size(__sizeRect.width, __sizeRect.height) ;
			background(30) ;
			colorMode(RGB, 255, 255, 255);
			noStroke();
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
				fill(208, 26, 26, alphas[(t+i) % n]);
				rect(radius, 0, eachWidth, eachHeight, 1, 1);
			}
			if (++t == 24) t = 0;
		}
	}
}
