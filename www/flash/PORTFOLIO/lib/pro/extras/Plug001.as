package pro.extras 
{
	import enhancefro.BaseView;
	import enhancefro.FroEnhancer;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import frocessing.core.F5Graphics3D;
	import frocessing.f3d.F3DModel;
	import frocessing.f3d.materials.F3DBmpMaterial;
	import frocessing.f3d.materials.F3DColorMaterial;
	import frocessing.f3d.models.F3DCube;
	import frocessing.f3d.models.F3DPlane;
	import frocessing.f3d.models.F3DSphere;
	import frocessing.geom.FNumber3D;
	import frocessing.math.FMath;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.core.easing.CubicEaseIn;
	import org.libspark.betweenas3.core.easing.IEasing;
	import org.libspark.betweenas3.easing.Bounce;
	import org.libspark.betweenas3.easing.Expo;
	import org.libspark.betweenas3.tweens.ITween;
	/**
	 * ...
	 * @author saz
	 */
	public class Plug001 extends Plugable
	{
		private static const FOCUS_POSITION:int = 1000;
		private static const MAX_NUM:int = 150;
		private static const SNOW_MAX_DEPTH:int = 24;
		
		
		private var __target:Sprite ;
		private var __helper:FroEnhancer ;
		private var __blurs:Vector.<BitmapData>;
		private var __particles:Vector.<F3DSphere>;
		private var __pitch:Number = 0;
		private var __radius:Number = 1000;
		private var __targetVertexs:Vector.<FNumber3D>;
		private var __yaw:Number = 0;
		private var __pearl:Bitmap;
		private var masterTw:ITween;
		
		
		public function Plug001() 
		{
			super() ;
			
			__helper = new FroEnhancer() ;
			var sh:Shape = new Shape() ;
			sh.graphics.beginFill(0xe42322, .85) ;
			sh.graphics.drawCircle(50, 50, 50) ;
			sh.graphics.endFill() ;
			__pearl = new Bitmap(new BitmapData(100, 100, true, 0x0), 'auto', true) ;
			__pearl.bitmapData.draw(sh) ;
		}
		
		override public function initialize():void 
		{
			__target = this ;
			super.initialize() ;
			
			init() ;
		}
		override public function terminate():void 
		{
			__target.removeEventListener(Event.ENTER_FRAME, enterFrame) ;
			masterTw.stop() ;
			super.terminate() ;
		}
		private function initTweens(vertexts:Array):void
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
				var time:Number = .8 ;

                // init
                __targetVertexs[ i ] = t3 ;
                // sphere
                var tw1:ITween = BetweenAS3.delay(BetweenAS3.tween(__targetVertexs[ i ],
                    { x: t1.x, y: t1.y, z: t1.z },
                    { x: t5.x, y: t5.y, z: t5.z },
                    time, Expo.easeInOut), 1) ;
                // cube
                var tw2:ITween = BetweenAS3.delay(BetweenAS3.tween(__targetVertexs[ i ],
                    { x: t2.x, y: t2.y, z: t2.z },
                    { x: t1.x, y: t1.y, z: t1.z },
                    time, Expo.easeInOut), 1) ;
                // random
                var tw3:ITween = BetweenAS3.delay(BetweenAS3.tween(__targetVertexs[ i ],
                    { x: t3.x, y: t3.y, z: t3.z },
                    { x: t2.x, y: t2.y, z: t2.z },
                    time, Expo.easeInOut), 1) ;
                // earth
                var tw4:ITween = BetweenAS3.delay(BetweenAS3.tween(__targetVertexs[ i ],
                    { x: t4.x, y: t4.y, z: t4.z },
                    { x: t3.x, y: t3.y, z: t3.z },
                    time, Bounce.easeOut), 1) ;
                // plane
                var tw5:ITween = BetweenAS3.delay(BetweenAS3.tween(__targetVertexs[ i ],
                    { x: t5.x, y: t5.y, z: t5.z },
                    { x: t4.x, y: t4.y, z: t4.z },
                    time, Expo.easeInOut), 1);
                tweenArr[ i ] = BetweenAS3.delay(BetweenAS3.serial(tw1, tw2, tw3, tw4, tw5), ease.calculate(i, 0, 0.2, MAX_NUM)) ;
            }
			
            masterTw = BetweenAS3.parallelTweens(tweenArr) ;
            masterTw.stopOnComplete = false ;
            tw1.onComplete = tw2.onComplete = tw3.onComplete = tw4.onComplete = tw5.onComplete = function():void {
				//masterTw.stop() ;
			}
            masterTw.play() ;
		}
		
		private function initVertexs():Array
		{
            var vertexts:Array = [] ;
			var d:F3DModel ;
			var w:F3DColorMaterial ;
			var p:Point = __helper.getHalfDimensions(__target.stage) ;
			// sphere
            d = new F3DSphere(400, 13) ;
            vertexts[ 0 ] = d.vertices ;
            
			// cube
            d = new F3DCube(700, 700, 700, 5, 5, 5) ;
            vertexts[ 1 ] = d.vertices ;
            
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
			
			// plane
            vertexts[ 4 ] = [];
           d = new F3DPlane(500, 500, 12, 12) ;
            vertexts[ 4 ] = d.vertices ;
			
			return vertexts ;
		}
		
		private function initParticles():void
		{
			for (i = 0; i < MAX_NUM; i++) {
				var p:F3DSphere = new F3DSphere(10,3) ;
				p.setTexture(__pearl.bitmapData) ;
                __particles[ i ] = p ;
            }
		}
		
		private function init():void
		{
			__helper.setup(function():void {
				__particles =  new Vector.<F3DSphere>(MAX_NUM,true) ;
				initParticles() ;
				var v:Array = initVertexs() ;
				initTweens(v) ;
				
				this.__params__ = {
					x: 150 ,
					y: 200
				}
			}) ;
			
			__helper.init(__target, '3D', function():void {
				var w:int = this.getDimensions(this.target.stage).x  ;
				var h:int = this.getDimensions(this.target.stage).y ;
				this.__params__ = {
					w: w ,
					h: h
				}
				this.renderer = new F5Graphics3D(this.target.graphics, w, h) ;
			}) ;
			
			__target.addEventListener(Event.ENTER_FRAME, enterFrame) ;
		}
		
		private function enterFrame(e:Event):void 
		{
			__helper.draw3D(function():void {
					var pm:Point = this.getHalfDimensions(__target.stage) ;
					__pitch += (__target.mouseY / __target.stage.stageHeight - 0.5) * 1 ;
					__yaw += (__target.mouseX / __target.stage.stageWidth - 0.5) * 4 ;
					
					this.noStroke() ;
					
					this.centerCamera(this.stage.stageWidth-this.stage.mouseX, this.stage.stageHeight-this.stage.mouseY) ;
					for (var i:int = 0; i < MAX_NUM; i++) {
						var cube:F3DSphere = __particles[ i ] ;
						cube.x = __targetVertexs[ i ].x + pm.x ;
						cube.y = __targetVertexs[ i ].y + pm.y;
						cube.z = __targetVertexs[ i ].z -500;
						var f:Number = Math.abs(cube.z) ;
						this.model(cube) ;
					}
				}) ;
		}
	}
}