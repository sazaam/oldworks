package pro.exec.external 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import frocessing.core.F5Graphics3D;
	import frocessing.display.F5MovieClip3D;
	import frocessing.f3d.F3DContainer;
	import frocessing.f3d.models.F3DCube;
	import frocessing.f3d.models.F3DPlane;
	import frocessing.geom.FNumber3D;
	import frocessing.math.FMath;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.Back;
	import org.libspark.betweenas3.easing.Expo;
	import org.libspark.betweenas3.tweens.ITween;
	import tools.fl.sprites.Smart;
	import tools.grafix.Draw;
	import tools.grafix.Reflect;
	
	/**
	 * ...
	 * @author saz
	 */
	public class FroNav extends F5MovieClip3D 
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
		private var __color:uint ;
		
		private var __moving:Boolean;
		private var __coordsMouse:Point;
		private var __coordsNewMouse:Point;
		private var __viewCoords3D:FNumber3D = new FNumber3D(0,0,0) ;
		
		
		public function FroNav(w:int , h:int ,max:Number = NaN, color:uint = 0xFFFFFF) 
		{
			__color = color ;
			__maxDisplay = isNaN(max) ? MAX_NUM : max  ;
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
			dimensions = new Rectangle(0,0, w, h) ;
		}
		
		private function onStage(e:Event):void 
		{
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
				clean() ;
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
		
		private function clean():void 
		{
			__smarts.map(function(el:*, i:int, arr:Vector.<Smart>):Smart {
				return Smart(el).destroy() ;
			})
		}
		
		private function presets():void 
		{
			__smarts = new Vector.<Smart>() ;
			
			size(__w, __h) ;
			
			
			__uW = 12 ;
			__uH = 80 ;
			__uD = 10 ;
		}
		private function init():void 
		{
			presets() ;
			initCubes() ;
		}
		private function onClick(e:MouseEvent):void 
		{
			//var smart:Smart = e.target ;
			//var ind:int = __smarts.indexOf(smart) ;
			//select(ind) ;
		}
		
		private function onOver(e:MouseEvent):void 
		{
			//var smart:Smart = e.target ;
			//if (e.type == MouseEvent.ROLL_OVER) {
				//if(!smart.properties.selected) smart.properties.over() ;
			//}else {
				//if(!smart.properties.selected) smart.properties.over(false) ;
			//}
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
		
		private function initCubes():void 
		{
			var l:int = __maxDisplay ;
			
			for (var i:int = 0 ; i < l ; i++ ) {
				
				var g3:F3DContainer = new F3DContainer() ;
				
				
				var cube:F3DCube = new F3DCube(__uW, __uH, __uD) ;
				//cube.setColors(0xc8003e,0xdf0549,0xb4063c,0xdf0549,0xf30c54,0xa00535) ;
				//cube.setColors(0xFF3300,0xdf0549,0xb4063c,0xdf0549,0xf30c54,0xa00535) ;
				var middle:int = int(l / 2) ;
				var space:int = __uW + 1 ;
				var locX:Number = (- middle * space) + space * i  ;
				//var locZ:Number = Math.sin(i/l * Math.PI) * 50;
				var locZ:Number = 0 ;
				g3.x = locX ;
				g3.y = 0 ;
				g3.z = locZ ;
				g3.addChild(cube) ;
				var dimH:Number = 30 + Math.random() * (__uH-30-5) ;
				var plane:F3DPlane =  new F3DPlane(__uW, dimH, 1,1) ;
				plane.userData.plane = plane ;
				plane.userData.draw = function(col:uint, alph:Number = 1):void {
					var pl:F3DPlane = this.plane ;
					var material:BitmapData = new BitmapData(__uW, __uH, false, col) ;
					var materialAlpha:BitmapData = new BitmapData(__uW, __uH, true, col) ;
					materialAlpha.draw(material,null, new ColorTransform(1,1,1,alph)) ;
					var reflect:BitmapData = new Reflect(materialAlpha, false, -1, [1, .65], [0, 255]) ;
					pl.setTexture(reflect) ;
				}
				plane.userData.draw(__color) ;
				plane.y = (__uH - dimH)/2 ;
				plane.z = 30 ;
				g3.addChild(plane) ;
				
				
				var smart:Smart = new Smart( { name:'smart_' + i, group:g3, cube:cube, plane:plane } ) ;
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
						plane.userData.draw(__color, 1) ;
					}else {
						cube.setColors(0x2d2d2d, 0x0, 0x0, 0x0, 0x767676, 0x0) ;
						plane.userData.draw(__color, .65) ;
					}
				}
				smart.properties.select = function(cond:Boolean = true):void {
					var sm:Smart = this.smart ;
					sm.properties.over(cond) ;
					sm.properties.selected = cond ;
				}
				
				var fg:F5Graphics3D = smart.properties.fg = new F5Graphics3D(smart.graphics, __w, __h) ;
				fg.noStroke() ;
				fg.size(__w, __h) ;
				__smarts[__smarts.length] = Smart(addChild(smart)) ;
				
				smart.properties.select(false) ;
			}
		}
		
		public function draw():void
		{
			noStroke() ;
			smooth() ;
			renderGroups() ;
		}
		
		private function renderGroups():void 
		{
			if (!stage) {
				return ;
			}
			var l:int = __smarts.length ;
			clear() ;
			//background(204, 204, 204, .45) ;
			ortho() ;
			translate(__w, __h) ;
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
			
			for (var i:int = 0 ; i < l ; i++ ) {
				var smart:Smart = __smarts[i] ;
				var group:F3DContainer = smart.properties.group ;
				
				rotateY(__viewCoords3D.y) ;
				rotateX(__viewCoords3D.x) ;
				
				model(group) ;
				
				smart.alpha = 0 ;
				
				smart.properties.fg.beginDraw() ;
				smart.properties.fg.clear() ;
				smart.properties.fg.ortho() ;
				smart.properties.fg.translate(__w, __h) ;
				smart.properties.fg.model(group) ;
				smart.properties.fg.endDraw() ;
			}
		}
		
		
		
		public function get smarts():Vector.<Smart>{ return __smarts }
		
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