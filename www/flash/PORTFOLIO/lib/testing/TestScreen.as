package testing 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import frocessing.display.F5MovieClip3DBmp;
	import frocessing.f3d.F3DContainer;
	import frocessing.f3d.models.F3DCube;
	import frocessing.geom.FNumber3D;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.*;
	import org.libspark.betweenas3.tweens.ITween;
	
	/**
	 * ...
	 * @author saz
	 */
	public class TestScreen extends F5MovieClip3DBmp 
	{
		
		private var __w:int = 400;
		private var __h:int = 400 ;
		private var __screenW:int = 247 ;
		private var __screenH:int = 207 ;
		
		private var __moving:Boolean;
		private var __coordsMouse:Point;
		private var __coordsNewMouse:Point;
		private var __viewCoords3D:FNumber3D = new FNumber3D(0,0,0) ;
		private var __screen:F3DContainer;
		
		private const URL:String = "../img/home/newScreen.png";
		private var __screenBMP:Bitmap;
		private var __loaded:Boolean;
        
		
		//public function TestScreen(w:int , h:int) 
		public function TestScreen() 
		{
			var w:int = __w ;
			var h:int = __h ;
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
			dimensions = new Rectangle(0, 0, w, h) ;
		}
		
		private function loadScreen():void 
		{
			var loader:Loader = new Loader() ;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onScreenComplete) ;
			loader.load(new URLRequest(URL), new LoaderContext(true)) ;
		}
		
		private function onScreenComplete(e:Event):void 
		{
			e.target.removeEventListener(e.type, arguments.callee) ;
			__screenBMP = e.target.content ;
			initScreen() ;
			__loaded = true ;
		}
		
		private function onStage(e:Event):void 
		{
			stage.align = 'TL' ;
			stage.scaleMode = 'noScale' ;
			
			if (e.type == Event.ADDED_TO_STAGE) {
				removeEventListener(e.type, arguments.callee) ;
				addEventListener(Event.REMOVED_FROM_STAGE, arguments.callee) ;
				
				stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouse) ;
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouse) ;
				
				init() ;
			}else {
				
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouse) ;
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouse) ;
				
				removeEventListener(e.type, arguments.callee) ;
				//clean() ;
			}
		}
		private function onMouse(e:MouseEvent):void 
		{
			var cond:Boolean = e.type == MouseEvent.MOUSE_DOWN ;
			if (cond) {
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
		private function presets():void 
		{
			//__smarts = new Vector.<Smart>() ;
			
			size(__w, __h) ;
			noStroke() ;
			background(0, 0, 0, 0) ;
			smooth() ;
		}
		private function init():void 
		{
			presets() ;
			loadScreen() ;
		}
		
		
		public function draw():void
		{
			if (__loaded) {
				renderScreen() ;
			}
		}
		
		private function initScreen():void 
		{
			__screen = new F3DContainer() ;
			var side:int = 20 ;
			var p:F3DCube = __screen.userData.ecran =  new F3DCube(__screenW, __screenH, side, 5, 5) ;
			var front:BitmapData = new BitmapData(__screenW, __screenH, true,  0x0) ;
			front.draw(__screenBMP, null, null, null, new Rectangle(0, 0, __screenW, __screenH), true) ;
			var back:BitmapData = new BitmapData(__screenW, __screenH, true,  0x0) ;
			back.draw(__screenBMP, new Matrix(1,0,0,1, 0, -(__screenH+side*2)), null, null, new Rectangle(0, 0, __screenW, __screenH), true) ;
			var left:BitmapData = new BitmapData(side, __screenH, true,  0x565656) ;
			left.draw(__screenBMP, new Matrix(1,0,0,1, -__screenW, -(__screenH+side*2)), null, null, new Rectangle(0, 0, side, __screenH), true) ;
			var right:BitmapData = new BitmapData(side, __screenH, true,  0x565656) ;
			right.draw(__screenBMP, new Matrix(1, 0, 0, 1, -__screenW, 0), null, null, new Rectangle(0, 0, side, __screenH), true) ;
			var top:BitmapData = new BitmapData(__screenW, side, true,  0x989898) ;
			top.draw(__screenBMP, new Matrix(1,0,0,1, 0, -(__screenH+side)), null, null, new Rectangle(0, 0, __screenW, side), true) ;
			var bottom:BitmapData = new BitmapData(__screenW, side, true,  0x989898) ;
			bottom.draw(__screenBMP, new Matrix(1,0,0,1, 0, -(__screenH)), null, null, new Rectangle(0, 0, __screenW, side), true) ;
			
			p.setTextures(front, right, back, left, top, bottom) ;
			__screen.addChild(p) ;
		}
		
		private function renderScreen():void 
		{
			dimensions = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight) ;
			
			background(0, 0, 0, 0) ;
			//ortho();
			
			
			translate(__w / 2 , __h / 2) ;
			//translate(__w , __h) ;
			
			var angleY:Number ;
			var angleX:Number
			__coordsNewMouse = new Point(stage.mouseX, stage.mouseY) ;
				if (__moving && !__coordsNewMouse.equals(__coordsMouse)) {
					var degX:Number = (__coordsMouse.x -__coordsNewMouse.x) / stage.stageWidth * 180  ;
					angleY = (degX / 180 * Math.PI) ;
					__viewCoords3D.y += angleY ;
					var degY:Number = (__coordsMouse.y - __coordsNewMouse.y) / stage.stageHeight * 180  ;
					 angleX = (degY / 180 * Math.PI) ;
					__viewCoords3D.x += angleX ;
					__coordsMouse = __coordsNewMouse ;
			}
			rotateY(__viewCoords3D.y) ;
			rotateX(__viewCoords3D.x) ;
			
			//camera(50, 50, 50) ;
			
			model(__screen) ;
		}
		
		public function get dimensions():Rectangle 
		{
			return new Rectangle(0,0, __w, __h) ;
		}
		
		public function set dimensions(value:Rectangle):void 
		{
			__w = value.width;
			__h = value.height;
			size(__w, __h) ;
		}
	}
}