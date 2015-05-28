package pro.extras 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import enhancefro.models.IsoTriangle3D ;
	import frocessing.f3d.F3DModel;
	import frocessing.f3d.materials.F3DColorMaterial;
	import frocessing.f3d.models.F3DCube;
	import frocessing.f3d.models.F3DPlane;
	import frocessing.f3d.models.F3DSimpleCube;
	import frocessing.f3d.models.F3DSphere;
	import frocessing.geom.FNumber3D;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.core.easing.CubicEaseIn;
	import org.libspark.betweenas3.core.easing.IEasing;
	import org.libspark.betweenas3.easing.Back;
	import org.libspark.betweenas3.easing.Bounce;
	import org.libspark.betweenas3.easing.Expo;
	import org.libspark.betweenas3.tweens.ITween;
	import tools.fl.sprites.Smart;
	import tools.grafix.Draw;
	/**
	 * ...
	 * @author saz
	 */
	public class Plug002 extends PlugableFro3D
	{
		private static const MAX_NUM:int = 144;
		
		private var __mask:Sprite;
		private var __tg:Smart;
		private var __bgBmpDt:BitmapData;
		private var __bgBmp:Bitmap;
		
		private var __unitHeight:int;
		private var __unitWidth:int;
		
		private var __particles:Vector.<F3DCube>;
		private var __pitch:Number = 0;
		private var __radius:Number = 1000;
		private var __targetVertexs:Vector.<FNumber3D>;
		private var __yaw:Number = 0;
		private var masterTw:ITween;
		private var __halfStageDims:Point;
		private var __decal:int;
		private var __moving:Boolean;
		private var __viewCoords3D:FNumber3D = new FNumber3D(0,0,0) ;
		private var __angle:Number = 0 ;
		private var __coordsMouse:Point;
		private var __coordsNewMouse:Point;
        
		public function Plug002() 
		{
			super() ;
		}
		
		override public function initialize(...rest:Array):void 
		{
			__tg = rest[0] ;
			
			initPresets() ;
			initMask() ;
			__tg.addChild(this) ;
			initEvents() ;
			super.initialize() ;
		}
		
		private function initEvents(cond:Boolean = true):void 
		{
			if (cond) {
				stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageDown) ;
				stage.addEventListener(MouseEvent.MOUSE_UP, onStageDown) ;
			}else {
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageDown) ;
				stage.removeEventListener(MouseEvent.MOUSE_UP, onStageDown) ;
			}
		}
		private function initPresets():void 
		{
			__decal = 19 ;
			x = y = __decal ;
			__unitWidth = 245 ;
			__unitHeight = 161 ;
			__halfStageDims = new Point(__unitWidth * .5, __unitHeight * .5) ;
		}
		
		private function initMask(cond:Boolean = true):void 
		{
			if(cond) {
				__mask = new Sprite() ;
				Draw.draw('roundRect', { g:__mask.graphics, color:0xFF6600, alpha:0 },  0, 0, __unitWidth, __unitHeight, 10) ;
				__bgBmpDt = new BitmapData(__unitWidth, __unitHeight, true, 0x0) ;
				__bgBmp  = new Bitmap(__bgBmpDt) ;
				
				__bgBmp.mask = __mask ;
				addChild(__mask) ;
				addChild(__bgBmp) ;
			}else {
				__bgBmp.mask = null ;
				removeChild(__bgBmp) ;
				removeChild(__mask) ;
			}
		}
		
		override public function terminate(...rest:Array):void 
		{
			initMask(false) ;
			initEvents(false) ;
			super.terminate() ;
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
		
		private function onStageDown(e:MouseEvent):void 
        {
            if (e.type == MouseEvent.MOUSE_DOWN) {
                __coordsMouse = new Point(e.stageX, e.stageY) ;
                __moving = true ;
            }else {
				resetView() ;
                __moving = false ;
            }
        }
		
		private function resetView():void 
		{
			var twReset:ITween = BetweenAS3.to(__viewCoords3D,
				{ x: 0, y: 0, z: 0},
				.5, Back.easeInOut) ;
			twReset.play() ;
		}
        
		private function initParticles():void
		{
			__particles = new Vector.<F3DCube>() ;
			for (i = 0; i < MAX_NUM; i++) {
				var p:F3DCube = new F3DCube(30,30, 30) ;
				p.setColors(0xc8003e,0xdf0549,0xb4063c,0xdf0549,0xf30c54,0xa00535) ;
                __particles[ i ] = p ;
            }
		}
		
		public function draw():void {
			background(0, 0, 0, 0) ;
			var pm:Point = __halfStageDims ;

			noStroke() ;
			
            __coordsNewMouse = new Point(stage.mouseX, stage.mouseY) ;
				if (__moving && !__coordsNewMouse.equals(__coordsMouse)) {
				var degX:Number = (__coordsMouse.x -__coordsNewMouse.x) / stage.stageWidth * 180  ;
				var angleY:Number = (degX / 180 * Math.PI) ;
				__viewCoords3D.y += angleY ;
				
				var degY:Number = (__coordsMouse.y - __coordsNewMouse.y) / stage.stageHeight * 180  ;
				var angleX:Number = (degY / 180 * Math.PI) ;
				__viewCoords3D.x += angleX ;
				__coordsMouse = __coordsNewMouse ;
			}
			rotateY(__viewCoords3D.y) ;
			rotateX(__viewCoords3D.x) ;
			
			for (var i:int = 0; i < MAX_NUM; i++) {
				var cube:F3DCube = __particles[ i ] ;
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
			var ca:Number = -radians(45 / p.x * (x - p.x ) - 90) ;
			var cb:Number = radians(45 / p.y * (y - p.y )) ;
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
            d = new F3DSphere(200, 13) ;
            vertexts[ 0 ] = d.vertices ;
            //trace('sphere', d.vertices.length) ;
			
			// cube
            d = new F3DSimpleCube(300, 300, 300, 6, 6, 6) ;
            vertexts[ 1 ] = d.vertices ;
            //trace('cube', d.vertices.length)
			
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
           d = new IsoTriangle3D(700, 10) ;
		  
		   d.vertices.map(function(el:*, i:int, arr:*):* {
				el.y += 100 ;
				return el ;
			}) ;
            vertexts[ 4 ] = d.vertices ;
			
			//trace('triangle', d.vertices.length)
			
			// plane
            vertexts[ 5 ] = [];
           d = new F3DPlane(1000, 650, 11, 11) ;
		   d.z = 0 ;
            vertexts[ 5 ] = d.vertices ;
			//trace('plane', d.vertices.length)
			
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
            //masterTw.stopOnComplete = false ;
            tw1.onComplete = tw2.onComplete = tw3.onComplete = tw4.onComplete = tw5.onComplete = function():void {
				//masterTw.stop() ;
			}
            masterTw.play() ;
		}
	}
}