package testing 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import frocessing.display.F5MovieClip3DBmp;
	import frocessing.f3d.models.F3DCube;
	import frocessing.f3d.models.F3DPlane;
	import org.libspark.betweenas3.BetweenAS3;
	import org.libspark.betweenas3.easing.*;
	import org.libspark.betweenas3.tweens.ITween;
	
	/**
	 * ...
	 * @author saz
	 */
	public class F5LiveRenderer3D extends F5MovieClip3DBmp 
	{
		
		private var __dimensions:Rectangle;
		private var __segW:int;
		private var __segH:int;
		private var __depthCube:int;
		
		
		private var __cubes:Vector.<F3DPlane>;
		
		private var __output:BitmapData;
		
		private var __coordsMouse:Point;
		private var __coordsNewMouse:Point;
		private var __viewCoords3D:Vector3D = new Vector3D(0,0,0) ;
		private var __source:IBitmapDrawable;
		private var __twReset:ITween;
		private var __target:Sprite;
		private var __resetting:Boolean;
		private var __newDimensions:Rectangle;
		private var __initialCoordsMouse:Point;
		
		
		public function F5LiveRenderer3D(tg:Sprite) 
		{
			__target = tg ;
			presets() ;
		}
		
		private function presets():void 
		{
			__segW = 12 ;
			__segH = 10 ;
			__depthCube = 50 ;
		}
		
		public function setup():void 
		{
			addEventListener(Event.RESIZE, onResize) ;
			size(stage.stageWidth, stage.stageHeight) ;
			background(0, 0, 0, 0) ;
			noStroke() ;
		}
		
		private function onResize(e:Event):void 
		{
			size(Sprite(__target).stage.stageWidth, Sprite(__target).stage.stageHeight) ;
		}
		
		// EXTERNALL CALL OF EFFECT
		public function render(source:IBitmapDrawable, pMouseX:Number = NaN,  pMouseY:Number = NaN):F5LiveRenderer3D
		{
			if (__resetting) {
				__twReset.onStop = __twReset.onComplete ;
				__twReset.stop() ;
			}
			var isStage:Boolean = source is Stage ;
			__source = source ;
			__newDimensions = __dimensions = getRightDimensions(source) ;
			if (__source is BitmapData) {
				__output = __source ;
			}else {
				__output = new BitmapData(__dimensions.width, __dimensions.height, true, 0x0) ;
				__output.draw(source, null, null, null, null, true) ;
			}
			__initialCoordsMouse = __coordsMouse = new Point(pMouseX || __dimensions.width >> 1, pMouseY || __dimensions.height >> 1) ;
			
			
			initCubes() ;
			draw() ;
			showSource(false) ;
			return this ;
		}
		
		private function initCubes():void 
		{
			__cubes = new Vector.<F3DPlane>() ;
			var s3D:Vector3D = new Vector3D() ;
			s3D.x = int(__dimensions.width / __segW) ;
			//s3D.y = __dimensions.height ;
			s3D.y =  int(__dimensions.height / __segH) ;
			//s3D.z = int(__dimensions.height / __segH) ;
			var startX:int = -(__dimensions.width >> 1) + (s3D.x >> 1) ;
			var startY:int = -(__dimensions.height >> 1) + (s3D.y >> 1) ;
			for (var i:int = 0 ; i <= __segW ; i++ ) {
				for (var j:int = 0 ; j <= __segH ; j++ ) {
					var indX:int = s3D.x * i ;
					var indY:int = s3D.y * j ;
					
					var cube:F3DPlane = new F3DPlane(s3D.x, s3D.y, 1, 1) ;
					cube.x = startX + indX ;
					cube.y = startY + indY ;
					
					var front:BitmapData = new BitmapData(s3D.x, s3D.y, true, 0x0) ;
					front.draw(__output, new Matrix(1, 0, 0, 1, -indX , -indY), null, null, null, true) ;
					var back:BitmapData = new BitmapData(s3D.x, s3D.y, true, 0x0) ;
					back.draw(front, new Matrix( -1, 0, 0, 1, s3D.x , 0), null, null, null, true) ;
					
					cube.setTexture(front, back) ;
					
					__cubes.push(cube) ;
				}
				
				
				//var cube:F3DCube = new F3DCube(s3D.x, s3D.y, s3D.z, 1, 1) ;
				
				
				//cube.z = - s3D.z >> 1 ;
				// TEXTURES
				
				//var right:BitmapData = new BitmapData(s3D.z, s3D.y, false, 0x2a2a2a) ;
				//var left:BitmapData = new BitmapData(s3D.z, s3D.y, false, 0x343434) ;
				//var top:BitmapData = new BitmapData(s3D.x, s3D.z, false, 0x888888) ;
				//var bottom:BitmapData = new BitmapData(s3D.x, s3D.z, false, 0x0) ;
				//cube.setTextures(front, right, back, left, top, bottom) ;
				
			}
		}
		
		
		
		// INNER DRAW
		public function draw():void 
		{
			var dims:Rectangle = getRightDimensions(__target.stage) ;
			if (__newDimensions.width != dims.width || __newDimensions.height != dims.height ) {
				__newDimensions = dims ;
				size(__newDimensions.width, __newDimensions.height) ;
			}
			background(0, 0, 0, 0) ;
			translate(__newDimensions.width>>1, __newDimensions.height>>1) ;
			
			renderCubes() ;
		}
		
		private function getRightDimensions(src:IBitmapDrawable):Rectangle
		{
			if (Boolean(src as Stage)) {
				return new Rectangle(0, 0, __target.stage.stageWidth, __target.stage.stageHeight) ;
			} else if (Boolean(src as DisplayObject)) {
				var rightDO:DisplayObject = getRightDO(src) ;
				return new Rectangle(rightDO.x, rightDO.y, rightDO.width, rightDO.height) ;
			}else {
				var bdt:BitmapData = BitmapData(src) ;
				return new Rectangle(0, 0, bdt.width, bdt.height) ;
			}
		}
		private function getRightDO(src:IBitmapDrawable):DisplayObject 
		{
			return (src is Stage) ? __target : 
				(src is DisplayObject) ? DisplayObject(src) :
				__target ;
		}
		private function renderCubes():void 
		{
			var l:int = __cubes.length ;
			var st:Stage = __target.stage ;
			
			if (!__resetting) {
				var angleY:Number ;
				var angleX:Number ;
				__coordsNewMouse = new Point(st.mouseX, st.mouseY) ;
				if (!__coordsNewMouse.equals(__coordsMouse)) {
					var degX:Number = (__coordsMouse.x -__coordsNewMouse.x) / st.stageWidth * 180  ;
					angleY = (degX / 180 * Math.PI) ;
					__viewCoords3D.y += angleY ;
					var degY:Number = (__coordsMouse.y - __coordsNewMouse.y) / st.stageHeight * 180  ;
					 angleX = (degY / 180 * Math.PI) ;
					__viewCoords3D.x += angleX ;
					__coordsMouse = __coordsNewMouse ;
				}
			}
			
			
			
			
			for (var i:int = 0 ; i < l ; i++ ) {
				var cube:F3DPlane = __cubes[i] ;
				rotateY(__viewCoords3D.y *.2) ;
				rotateX(__viewCoords3D.x *.2) ;
				
				model(cube) ;
			}
		}
		
		public function reset(closure:Function = null, ...args:Array):void 
		{
			__resetting = true ;
			if (closure is Function) {
				resetView.apply(this, [closure].concat(args))
			}else {
				resetView() ;
			}
		}
		
		private function resetView(closure:Function = null, ...args:Array):void 
		{
			var resetComplete:Function = function():void {
				if (closure is Function) {
					closure.apply(null, args) ;
				}
				showSource(true) ;
				__twReset = null ;
				__initialCoordsMouse = null ;
				__resetting = false ;
			}
			if (__initialCoordsMouse.equals(__coordsMouse)) {
				resetComplete() ;
				return ;
			}
			__twReset = BetweenAS3.to(__viewCoords3D,
				{ x: 0, y: 0, z: 0},
				__dimensions.width/465/100*25, Expo.easeOut) ;
			__twReset.onComplete = resetComplete ;
			__twReset.play() ;
		}
		
		private function showSource(cond:Boolean = true):void 
		{
			trace('should appear second')
			getRightDO(__source).visible = cond ;
		}
	}
}