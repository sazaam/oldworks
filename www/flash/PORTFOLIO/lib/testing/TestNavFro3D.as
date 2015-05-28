package testing 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import frocessing.core.F5Graphics3D;
	import frocessing.display.F5MovieClip3D;
	import frocessing.f3d.models.F3DCube;
	import frocessing.f3d.models.F3DPlane;
	import frocessing.math.FMath;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Back;
	import org.libspark.betweenas3.easing.Expo;
	import org.libspark.betweenas3.tweens.ITween;
	import tools.fl.sprites.Smart;
	import tools.grafix.Draw;
	
	/**
	 * ...
	 * @author saz
	 */
	public class TestNavFro3D extends F5MovieClip3D 
	{
		private static const MAX_NUM:int = 10 ;
		
		private var __smarts:Vector.<Smart>;
		
		private var __w:int;
		private var __h:int;
		private var __uW:int;
		private var __uH:int;
		private var __uD:int;
		private var __maxDisplay:int;
		private var __currentIndex:int = -1;
		
		
		public function TestNavFro3D(max:Number = NaN) 
		{
			__maxDisplay = max || MAX_NUM ;
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
		}
		
		private function onStage(e:Event):void 
		{
			if (e.type == Event.ADDED_TO_STAGE) {
				removeEventListener(e.type, arguments.callee) ;
				addEventListener(Event.REMOVED_FROM_STAGE, arguments.callee) ;
				init() ;
			}else {
				removeEventListener(e.type, arguments.callee) ;
				clean() ;
			}
		}
		
		private function clean():void 
		{
			__smarts.map(function(el:*, i:int, arr:Array):Smart {
				return Smart(el).destroy() ;
			})
		}
		
		private function presets():void 
		{
			__smarts = new Vector.<Smart>() ;
			
			__w = 300 ;
			__h = 250 ;
			
			__uW = 12 ;
			__uH = 80 ;
			__uD = 10 ;
		}
		private function init():void 
		{
			presets() ;
			//listeners() ;
			initCubes() ;
			
			//stage.dispatchEvent(new Event(Event.RESIZE)) ;
		}
		///////////// EVENTS
		//private function listeners(cond:Boolean = true):void 
		//{
			//if (cond) {
				//stage.addEventListener(Event.RESIZE, onResize) ;
				//stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel) ;
			//}else {
				//stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel) ;
				//stage.removeEventListener(Event.RESIZE, onResize) ;
			//}
		//}
		//private function onResize(e:Event):void 
		//{
			//x = (stage.stageWidth - __w) /2 ;
			//y = (stage.stageHeight - __h) /2 ;
		//}
		//private function onWheel(e:MouseEvent):void 
		//{
			//var n:int = -e.delta / 3 ;
			//if (n > 0) {
				//shift(n) ;
			//}else {
				//shift(n) ;
			//}
		//}
		private function onClick(e:MouseEvent):void 
		{
			var smart:Smart = e.target ;
			var ind:int = __smarts.indexOf(smart) ;
			select(ind) ;
		}
		
		private function render():void 
		{
			draw() ;
		}
		
		private function onOver(e:MouseEvent):void 
		{
			var smart:Smart = e.target ;
			if (e.type == MouseEvent.ROLL_OVER) {
				trace('is over')
				if(!smart.properties.selected) smart.properties.over() ;
			}else {
				trace('is out')
				if(!smart.properties.selected) smart.properties.over(false) ;
			}
		}
		
		//////////// CONTROL
		public function shift(n:int):void 
		{
			var r:int = __currentIndex + n ;
			if ( r >= __maxDisplay ) {
				r = r - __maxDisplay ;
			}
			if (r < 0){
				r =  __maxDisplay + n;
			}
			select(r) ;
		}
		public function select(n:int):void
		{
			if (__currentIndex == n) return ;
			if (__currentIndex != -1) {
				var old:Smart = __smarts[__currentIndex] ;
				old.properties.select(false) ;
			}
			var smart:Smart = __smarts[n] ;
			smart.properties.select() ;
			__currentIndex = n ;
		}
		
		public function setup():void 
		{
			//size(__w, __h) ;
			//colorMode(RGB) ;
			//background(30) ;
		}
		
		private function initCubes():void 
		{
			var l:int = __maxDisplay ; 
			for (var i:int = 0 ; i < l ; i++ ) {
				var cube:F3DCube = new F3DCube(__uW, __uH, __uD) ;
				//cube.setColors(0xc8003e,0xdf0549,0xb4063c,0xdf0549,0xf30c54,0xa00535) ;
				//cube.setColors(0xFF3300,0xdf0549,0xb4063c,0xdf0549,0xf30c54,0xa00535) ;
				var middle:int = int(l / 2) ;
				var space:int = __uW + 1 ;
				var locX:Number = (- middle * space) + space * i  ;
				//var locZ:Number = Math.sin(i/l * Math.PI) * 50;
				var locZ:Number = 0 ;
				cube.x = locX ;
				cube.y = 0 ;
				//cube.z = 
				cube.z = locZ ;
				var dimH:Number = 30 + Math.random() * (__uH-30-5) ;
				var plane:F3DPlane =  new F3DPlane(__uW, dimH, 1, 1) ;
				plane.userData.plane = plane ;
				plane.userData.draw = function(col:uint, alph:Number = 1):void {
					var pl:F3DPlane = this.plane ;
					var material:BitmapData = new BitmapData(__uW, __uH, false, col) ;
					var materialAlpha:BitmapData = new BitmapData(__uW, __uH, true, col) ;
					materialAlpha.draw(material,null, new ColorTransform(1,1,1,alph)) ;
					//var reflect:BitmapData = new Reflect(materialAlpha, false, -1, [.65, 1], [0, 255]) ;
					pl.setTexture(materialAlpha) ;
				}
				plane.userData.draw(0xc8003e) ;
				plane.x = locX ;
				plane.y = (__uH - dimH)/2 ;
				plane.z = __uW/2 + 10 ;
				var smart:Smart = new Smart( { name:'smart_' + i, cube:cube , plane:plane } ) ;
				smart.addEventListener(MouseEvent.ROLL_OVER, onOver) ;
				smart.addEventListener(MouseEvent.ROLL_OUT, onOver) ;
				smart.addEventListener(MouseEvent.CLICK, onClick) ;
				smart.properties.smart = smart ;
				smart.properties.over = function(cond:Boolean = true):void {
					var sm:Smart = this.smart ;
					var cube:F3DCube = this.cube ;
					var plane:F3DPlane = this.plane ;
					if (cond) {
						cube.setColors(0x3d3d3d, 0x0, 0x0, 0x222222, 0x989898, 0x0) ;
						plane.userData.draw(0xc8003e, 1) ;
					}else {
						cube.setColors(0x2d2d2d, 0x0, 0x0, 0x0, 0x767676, 0x0) ;
						plane.userData.draw(0xc8003e, .65) ;
					}
				}
				smart.properties.select = function(cond:Boolean = true):void {
					var sm:Smart = this.smart ;
					sm.properties.over(cond) ;
					sm.properties.selected = cond ;
				}
				
				var fg:F5Graphics3D = smart.properties.fg = new F5Graphics3D(smart.graphics, __w, __h) ;
				fg.noStroke() ;
				__smarts[__smarts.length] = Smart(addChildAt(smart, 0)) ;
				
				smart.properties.select(false) ;
			}
		}
		
		public function draw():void
		{
			renderCubes() ;
			//noLoop() ;
		}
		
		private function renderCubes():void 
		{
			var l:int = __smarts.length ;
			
			for (var i:int = 0 ; i < l ; i++ ) {
				var smart:Smart = __smarts[i] ;
				var cube:F3DCube = smart.properties.cube ;
				var shadow:F3DPlane = smart.properties.plane ;
				var fg:F5Graphics3D = smart.properties.fg ;
				
				fg.ortho() ;
				
				fg.beginDraw() ;
				fg.translate(__w/2, __h/2) ;
				fg.model(cube) ;
				fg.translate(-7, -2) ;
				fg.model(shadow) ;
				fg.endDraw() ;
				fg.beginCamera() ;
				fg.camera( - 150, - 40, fg.cameraZ, 0, 0, 0) ;
				fg.endCamera() ;
			}
		}
		
		
		public function get smarts():Vector.<Smart>{ return __smarts }
	}
}