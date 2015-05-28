package{    
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import frocessing.display.F5MovieClip2DBmp;
	import frocessing.display.F5MovieClip2DBmp;
	import frocessing.display.F5MovieClip3D;
	import frocessing.display.F5MovieClip3DBmp;
	import frocessing.f3d.F3DModel;
	import frocessing.f3d.materials.F3DColorMaterial;
	import frocessing.f3d.models.F3DPlane;
	import frocessing.f3d.models.F3DSimpleCube;
	import frocessing.f3d.models.F3DSphere;
	import frocessing.geom.FNumber3D;
	import frocessing.math.FMath;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.core.easing.CubicEaseIn;
	import org.libspark.betweenas3.core.easing.IEasing;
	import org.libspark.betweenas3.easing.Bounce;
	import org.libspark.betweenas3.easing.Expo;
	import org.libspark.betweenas3.tweens.ITween;
    [SWF(width=465,height=465, frameRate=24, backgroundColor=0x222222)]
    public class FrocessingTestMrDoob extends F5MovieClip3D
    {
		private var __unitHeight:int;
		private var __unitWidth:int;
		private var particles:Vector.<IsoTriangle3D> ;
		private static const FOCUS_POSITION:int = 1000;
		private static const MAX_NUM:int = 144;
		private static const SNOW_MAX_DEPTH:int = 24;
		
		
		private var __blurs:Vector.<BitmapData>;
		private var __particles:Vector.<IsoTriangle3D>;
		private var __pitch:Number = 0;
		private var __radius:Number = 1000;
		private var __targetVertexs:Vector.<FNumber3D>;
		private var __yaw:Number = 0;
		private var masterTw:ITween;
		private var __halfStageDims:Point;
        
        public function FrocessingTestMrDoob()
        {
            super() ;
			stage.scaleMode = 'noScale' ;
			__unitWidth = 465 ;
			__unitHeight = 465 ;
			__halfStageDims = new Point(__unitWidth * .5, __unitHeight * .5) ;
        }
        
		private function resetSettings():void 
		{
			size(__unitWidth, __unitHeight) ;
			background(0, 0, 0, 0) ;
		}
		public function setup():void
        {
			resetSettings() ;
			
			initParticles() ;
			var v:Vector.<Array> = initVertexs() ;
			initTweens(v) ;
			
        }
		
		private function initParticles():void
		{
			__particles = new Vector.<IsoTriangle3D>() ;
			for (i = 0; i < MAX_NUM; i++) {
				var p:IsoTriangle3D = new IsoTriangle3D(10,1) ;
				p.setColor(0xFF6600) ;
                __particles[ i ] = p ;
            }
		}
		
		public function draw():void {
			
			background(0,0,0,0)
			var pm:Point = __halfStageDims ;
					__pitch += (stage.mouseY / __unitHeight - 0.5) * 1 ;
					__yaw += (stage.mouseX / __unitWidth - 0.5) * 4 ;
					
				noStroke() ;
				centerCamera(__unitWidth-stage.mouseX, __unitHeight - stage.mouseY) ;
				for (var i:int = 0; i < MAX_NUM; i++) {
					var cube:IsoTriangle3D = __particles[ i ] ;
					cube.x = __targetVertexs[ i ].x + pm.x ;
					cube.y = __targetVertexs[ i ].y + pm.y;
					cube.z = __targetVertexs[ i ].z -500;
					var f:Number = Math.abs(cube.z) ;
					model(cube) ;
				}
		}
		public function centerCamera(x:Number, y:Number):Point
		{
			var p:Point = __halfStageDims ;
			var ca:Number = -FMath.radians(45 / p.x * (x - p.x ) - 90) ;
			var cb:Number = FMath.radians(45 / p.y * (y - p.y )) ;
			camera( p.x + 500 * Math.cos(ca), p.y + 500 * Math.sin(cb), 500 * Math.sin(ca), p.x, p.y, 0, 0, 1, 0) ;
			return p ;
		}
		private function initVertexs():Vector.<Array>
		{
            var vertexts:Vector.<Array> = new Vector.<Array>() ;
			var d:F3DModel ;
			var w:F3DColorMaterial ;
			var p:Point = __halfStageDims ;
			// sphere
            d = new F3DSphere(400, 13) ;
            vertexts[ 0 ] = d.vertices ;
            trace('sphere', d.vertices.length) ;
			
			// cube
            d = new F3DSimpleCube(700, 700, 700, 6, 6, 6) ;
            vertexts[ 1 ] = d.vertices ;
            trace('cube', d.vertices.length)
			
			// random
            vertexts[ 2 ] = [] ;
            for (i = 0; i < MAX_NUM; i++)
                vertexts[ 2 ][ i ] = new FNumber3D((Math.random() - 0.5) * 3000, (Math.random() - 0.5) * 3000, (Math.random() - 0.5) * 3000) ;
            
			// earth
            vertexts[ 3 ] = [];
            for (i = 0; i < MAX_NUM; i++) {
				var n:FNumber3D = FNumber3D(vertexts[ 2 ][ i ]) ;
                vertexts[ 3 ][ i ] = new FNumber3D(n.x, 500, n.z) ;
            }
			
			// triangle
            vertexts[ 4 ] = [];
           d = new IsoTriangle3D(500, 10) ;
            vertexts[ 4 ] = d.vertices ;
			trace('triangle', d.vertices.length)
			
			// plane
            vertexts[ 5 ] = [];
           d = new F3DPlane(500, 500, 11, 11) ;
            vertexts[ 5 ] = d.vertices ;
			trace('plane', d.vertices.length)
			
			return vertexts ;
		}
		
		private function initTweens(vertexts:Vector.<Array>):void
		{
			__targetVertexs = new Vector.<FNumber3D>(MAX_NUM, true) ;
            var tweenArr:Array = [] ;
            var ease:IEasing = new CubicEaseIn() ;
            for (var i:int = 0; i < MAX_NUM; i++) {
                var t1:FNumber3D = vertexts[ 0 ][ i ] ;
                var t2:FNumber3D = vertexts[ 1 ][ i ] ;
                var t3:FNumber3D = vertexts[ 2 ][ i ] ;
                var t4:FNumber3D = vertexts[ 3 ][ i ] ;
                var t5:FNumber3D = vertexts[ 4 ][ i ] ;
                var t6:FNumber3D = vertexts[ 5 ][ i ] ;
				var time:Number = .8 ;
				
				
				
                // init
                __targetVertexs[ i ] = t3 ;
                // sphere
				//if (!Boolean(t1) || !Boolean(t6)) continue ;
                var tw1:ITween = BetweenAS3.delay(BetweenAS3.tween(__targetVertexs[ i ],
                    { x: t1.x, y: t1.y, z: t1.z },
                    { x: t6.x, y: t6.y, z: t6.z },
                    time, Expo.easeInOut), 1) ;
                // cube
				//if (!Boolean(t2) || !Boolean(t1)) continue ;
                var tw2:ITween = BetweenAS3.delay(BetweenAS3.tween(__targetVertexs[ i ],
                    { x: t2.x, y: t2.y, z: t2.z },
                    { x: t1.x, y: t1.y, z: t1.z },
                    time, Expo.easeInOut), 1) ;
                // random
				//if (!Boolean(t3) || !Boolean(t2)) continue ;
                var tw3:ITween = BetweenAS3.delay(BetweenAS3.tween(__targetVertexs[ i ],
                    { x: t3.x, y: t3.y, z: t3.z },
                    { x: t2.x, y: t2.y, z: t2.z },
                    time, Expo.easeInOut), 1) ;
                // earth
				//if (!Boolean(t4) || !Boolean(t3)) continue ;
                var tw4:ITween = BetweenAS3.delay(BetweenAS3.tween(__targetVertexs[ i ],
                    { x: t4.x, y: t4.y, z: t4.z },
                    { x: t3.x, y: t3.y, z: t3.z },
                    time, Bounce.easeOut), 1) ;
                // triangle
				//if (!Boolean(t5) || !Boolean(t4)) continue ;
                var tw5:ITween = BetweenAS3.delay(BetweenAS3.tween(__targetVertexs[ i ],
                    { x: t5.x, y: t5.y, z: t5.z },
                    { x: t4.x, y: t4.y, z: t4.z },
                    time, Expo.easeInOut), 1);
				// plane
				//if (!Boolean(t6) || !Boolean(t5)) continue ;
                var tw6:ITween = BetweenAS3.delay(BetweenAS3.tween(__targetVertexs[ i ],
                    { x: t6.x, y: t6.y, z: t6.z },
                    { x: t5.x, y: t5.y, z: t5.z },
                    time, Expo.easeInOut), 1);
                tweenArr[ i ] = BetweenAS3.delay(BetweenAS3.serial(tw1, tw2, tw3, tw4, tw5, tw6), ease.calculate(i, 0, 0.2, MAX_NUM)) ;
            }
			
            masterTw = BetweenAS3.parallelTweens(tweenArr) ;
            masterTw.stopOnComplete = false ;
            tw1.onComplete = tw2.onComplete = tw3.onComplete = tw4.onComplete = tw5.onComplete = function():void {
				//masterTw.stop() ;
			}
            masterTw.play() ;
		}
		
    }
}



import frocessing.f3d.*;
import frocessing.geom.*;
import frocessing.f3d.materials.*;
import flash.display.BitmapData;

class IsoTriangle3D extends F3DModel 
{
    public function IsoTriangle3D( size:Number = 50, segment:int = 2 ) 
    {
        super();
        backFaceCulling = false;
        //backFaceCulling = true ;
        initModel( size , segment);
    }
    
    /** @private */
    private function initModel( size:Number, seg:int):void
    {
        beginVertex(TRIANGLES) ;
        
        var total:int = seg + 1 ;
        var hh:Number = 0 ;
        var midSize:Number = size * .5 ;
        hh = int(Math.sqrt((size*size) - (midSize*midSize))) ;
        
        var midW:Number = size * .5 ;
        var midH:Number = hh * .5 ;
        var divX:Number = size / (total) ;
        var divY:Number = hh / (total) ;
        var startX:Number = - midW ;
        var startY:Number = - midH + divY *.5 ;
        var startIndY:Number = (size - hh)/2 / size;
        var unitX:Number = 1/ (total*2) ;
        
         for ( var i:int = 0 ; i <= seg; i++ ) {
            var curX:Number =  midW + ( - i * divX * .5) ;
            var curX2:Number =  midW + ( - i * divX) ;
            var curY:Number =  divY * i ;
            
            for ( var j:int = 0; j <= i ; j ++ ) {
                var xx:Number = curX + divX * j ;
                var yy:Number = curY ;
                var indX:Number = xx / size - unitX ;
                var indY:Number = yy / hh ;
                
                var result0:Number = indX + (divX  / size / 2) ;
                var result1:Number = indX + (divX  / size) ;
                var result2:Number = indX ;
                
                if (j != 0) {
                    addVertex(startX + xx - divX, startY + (yy - divY / 2), 0,
                            result1 - unitX*3, indY - startIndY) ;
                    addVertex(startX + xx, startY + (yy - divY / 2), 0,
                            result1 - unitX, indY - startIndY) ;
                    addVertex(startX + (xx - divX / 2), startY + (yy + divY / 2), 0,
                            result1 - unitX*2, indY + (divY / hh) - startIndY) ;
                }
                addVertex(startX + xx, startY + (yy - divY / 2), 0, 
                         result0, indY - startIndY) ;
                addVertex(startX + (xx + divX / 2), startY + (yy + divY / 2), 0, 
                        result1, indY + (divY / hh) - startIndY) ;
                addVertex(startX + (xx - divX / 2), startY + (yy + divY / 2), 0, 
                        result2, indY + (divY / hh) - startIndY) ;
            }
        }
        endVertex() ;
    }
    
    public function toString():String 
    {
        return '[object IsoTriangle3D] >> ( x:'+x+', y:'+y+', z:'+z+')' ;
    }
}