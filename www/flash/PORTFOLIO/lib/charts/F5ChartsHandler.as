package charts 
{
	import charts.fro.F3DDisk;
	import enhancefro.models.IsoTriangle3D;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import frocessing.color.FColor;
	import frocessing.core.graphics.FPath;
	import frocessing.core.graphics.FPathCommand;
	import frocessing.display.F5MovieClip3D;
	import frocessing.f3d.F3DModel;
	import frocessing.f3d.models.F3DCube;
	import frocessing.geom.FMatrix3D;
	import frocessing.geom.FMatrixMap;
	import frocessing.geom.FNumber3D;
	import frocessing.shape.FShape;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.core.easing.BackEaseIn;
	import org.libspark.betweenas3.core.easing.IEasing;
	import org.libspark.betweenas3.easing.Expo;
	import org.libspark.betweenas3.tweens.ITween;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class F5ChartsHandler extends F5MovieClip3D 
	{
		private var __dimensions:Rectangle = new Rectangle(0, 0, 100, 100) ;
		private var __rendered:Array = [1, 2, 3, 4, 5] ;
		
		public function F5ChartsHandler(dimensions:Rectangle = null) 
		{
			if (dimensions) {
				__dimensions = dimensions ;
			}
			trace('1', __dimensions)
		}
		
		public function setup():void 
		{
			trace('2', __dimensions)
			size(__dimensions.width, __dimensions.height) ;
			colorMode(RGB) ;
			//noStroke() ;
			background(255) ;
		}
		
		private function initShapes():void 
		{
			//var path:FPath = new FPath(
					//[FPathCommand.MOVE_TO,FPathCommand.LINE_TO,FPathCommand.LINE_TO,FPathCommand.LINE_TO,FPathCommand.CLOSE_PATH],
					//[ 0, 0, 15, 0, 15, 15, 0, 15]
			//) ;
			var l:int = __rendered.length ;
			for (var i:int = 0 ; i <  l ; i++ ) {
				var m:IsoTriangle3D = new IsoTriangle3D(40) ;
				//var m:F3DDisk = new F3DDisk() ;
				//var f:Object = getFaces(m) ;
				m.setColor(0xFF3300) ;
				//m.setTextures(f.front, f.right, f.back, f.left, f.top, f.bottom) ;
				__rendered[i] = m ;
			}
		}
		//private function getFaces(p:IsoTriangle3D):Object
		//{
			//var pObj:Object = p.userData ;
			//var tint:uint = 0xFF6600 ;
			//trace('0xFF6600 >> ', tint)
			//var rgbTint:Object = FColor.ValueToRGB(tint)
			//trace('r', rgbTint.r, 'g:', rgbTint.g, 'b:', rgbTint.b) ;
			//var hsvTint:Object = FColor.ValueToHSV(tint) ;
			//trace('h', hsvTint.h, 's:', hsvTint.s, 'v:', hsvTint.v)
			//var col:uint = FColor.HSVtoValue(hsvTint.h, hsvTint.s, hsvTint.v - (25/255)) ;
			//pObj.faces = { 
				//front:new BitmapData(20, 100, false, tint), 
				//back:new BitmapData(100, 100, false, col), 
				//right:new BitmapData(20, 100, false, col), 
				//left:new BitmapData(20, 100, false, col), 
				//top:new BitmapData(100, 20, false, col), 
				//bottom:new BitmapData(100, 20, false, col) } ;
			//return pObj.faces ;
		//}
		public function draw():void
		{
			ortho() ;
			translate(__dimensions.width , __dimensions.height ) ;
			//background(255) ;
			
			//rotateX(radians(55)) ;
			rotateX(radians((360 * (pmouseX / __dimensions.width)) - 180)) ;
			rotateZ(radians((360 * (pmouseY / __dimensions.height)) - 180)) ;
			
			var diameter:int = 50 ;
			var l:int = __rendered.length ;
			for (var i:int = 0 ; i <  l ; i++ ) {
				
				//var sh:FShape = FShape(__rendered[i]) ;
				//shape(sh, (i % total) * (15+5), ) ;
				
				var sh:IsoTriangle3D = IsoTriangle3D(__rendered[i]) ;
				sh.x = cos(radians( -90 + (360 *  i / l)) )  * diameter;
				sh.y = sin(radians( -90 + (360 * i / l)) ) * diameter ;
				model(sh) ;
			}
		}
		
		public function createChart(p:Array = null, cond:Boolean = true):F5ChartsHandler 
		{
			if (cond){
				trace('creating Chart')
				initShapes() ;
				tw() ;
				
				//BetweenAS3.
			}else {
				trace('killing Chart')
			}
			return this ;
		}
		
		private function tw():void 
		{
			var l:int = __rendered.length ;
			var tweenArr:Array = [] ;
			var ease:IEasing = new BackEaseIn() ;
			var time:Number = .55 ;
			var indix:Number = Math.random() * 100 ;
			for (var i:int = 0 ; i <  l ; i++ ) {
				var m:IsoTriangle3D = IsoTriangle3D(__rendered[i]) ;
				
				var n:FNumber3D = new FNumber3D(m.x, m.y, m.z) ;
				var random:Number = (Math.random() * 10) + 1 ;
				var tw1:ITween = BetweenAS3.delay(BetweenAS3.tween(m,
					{ z:random*15/2, scaleZ:random, rotationY:radians(45)},
                    { z: m.z},
                    time, Expo.easeIn), .25);
                tweenArr[i] = BetweenAS3.delay(BetweenAS3.serial(tw1), ease.calculate(i, 0, .3, l)) ;
                //tweenArr[i] = tw1 ;
			}
			
			
            var masterTw:ITween = BetweenAS3.parallelTweens(tweenArr) ;
            //masterTw.stopOnComplete = false ;
            //tw1.onComplete = tw2.onComplete = tw3.onComplete = tw4.onComplete = tw5.onComplete = function():void {
				//masterTw.stop() ;
			//}
            //masterTw.play() ;
		}
	}
}