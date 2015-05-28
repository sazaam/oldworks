package testing 
{
	import enhancefro.models.IsoPyramid3D;
	import enhancefro.models.IsoTriangle3D;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import frocessing.display.F5MovieClip3DBmp;
	import frocessing.f3d.models.F3DPlane;
	import frocessing.geom.FNumber3D;
	import gs.easing.Quad;
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author saz
	 */
	
	[SWF(width = 465, height = 465, frameRate = 24, backgroundColor = 0x2a2a2a)]
	public class TestIsoPyramid3D extends F5MovieClip3DBmp 
	{
		
        private const BMP:String = "http://assets.wonderfl.net/images/related_images/5/50/5076/507626853fa40bc565596061e9b5f0b0eddde148" ;
		
		private var stage_width:Number  = 465;
        private var stage_height:Number = 465;
		private var pyramids:Vector.<IsoPyramid3D>;
		private var __moving:Boolean;
		private var __viewCoords3D:FNumber3D = new FNumber3D(0,0,0) ;
		private var __angle:Number = 0 ;
		private var __coordsMouse:Point;
		private var __coordsNewMouse:Point;
		
		public function TestIsoPyramid3D() 
		{
			super() ;
			stage.scaleMode = 'noScale' ;
		}
		 private function onLoadComplete(e:Event):void{
            e.target.removeEventListener(e.type, arguments.callee) ;
            e.target.content.smoothing = true ;
            var tex:BitmapData = e.target.content.bitmapData ;
			
            setTexture(tex) ;
        }
		 private function setTexture(tex:BitmapData):void {
			var front:BitmapData = tex.clone() ;
			var invertedFront:BitmapData = new DirectionBitmapData(front, DirectionBitmapData.X_AXIS_INVERTED) ;
			var reflect:BitmapData = new Reflect(invertedFront, false) ;
            var l:int = pyramids.length ;
            for (var i:int = 0 ; i < l ; i++ ) {
                var t:IsoPyramid3D = pyramids[i] ;
				t.setTexture(front) ;
				t.userData.reflect.setTexture(reflect) ;
            }
        }
		public function setup():void 
		{
			initPyramids() ;
             
            size(stage_width, stage_height) ;
            colorMode(RGB, 255, 255, 255, 1) ;
            background(0,0,0,0) ;
			noStroke() ;
            noFill() ;
			
			var l:Loader = new Loader;
            l.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete) ;
            l.load(new URLRequest(BMP), new LoaderContext(true)) ;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageDown) ;
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageDown) ;
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onStageWheel) ;
			
			tweenPyramids(1) ;
		}
		
		private function onStageWheel(e:MouseEvent):void 
		{
			tweenPyramids(e.delta / 3) ;
		}
		
		private function tweenPyramids(n:int):void 
		{
			var l:int = pyramids.length ;
			for (var i:int = 0 ; i < l ; i++ ) {
				var t:IsoPyramid3D = pyramids[i] ;
				TweenLite.killTweensOf(t) ;
				TweenLite.killTweensOf(t.userData.reflect) ;
				var d:Number = __angle + radians(n * 120) ;
				TweenLite.to(t, .5, { ease:Quad.easeOut, rotationY: d } ) ;
				TweenLite.to(t.userData.reflect, .5, { ease:Quad.easeOut, rotationY: -d +Math.PI } ) ;
			}
			__angle = d ;
		}
		
		private function onStageDown(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.MOUSE_DOWN) {
				__coordsMouse = new Point(e.stageX, e.stageY) ;
				__moving = true ;
			}else {
				__moving = false ;
			}
		}
		
		public function draw():void
        {
			background(0, 0, 0, 0) ;
			pushMatrix();
			__coordsNewMouse = new Point(stage.mouseX, stage.mouseY) ;
			//centerCamera(stage_width - stage.mouseX, stage_height - stage.mouseY) ;
            translate(stage_width / 2, stage_height / 2) ;
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
            renderPyramids() ;
			popMatrix() ;
        }
		
		private function renderCenterPlane():void 
		{
			var p:F3DPlane = new F3DPlane(30, 30) ;
			p.setColor(0xFFFFFF) ;
			model(p) ;
		}
		
		public function centerCamera(x:Number, y:Number):Point
		{
			var p:Point = new Point(stage_width/2, stage_height/2) ;
			var ca:Number = - radians(45 / p.x * (x - p.x ) - 90) ;
			var cb:Number = radians(45 / p.y * (y - p.y )) ;
			camera( p.x + 1000 * Math.cos(ca), p.y + 1000 * Math.sin(cb), 500 * Math.sin(ca), p.x, p.y, 0, 0, 1, 0) ;
			return p ;
		}
		public function renderPyramids():void
        {
			var l:int = pyramids.length ;

			for (var i:int = 0 ; i < l ; i++ ) {
				var t3:IsoPyramid3D = pyramids[i] ;
				model(t3) ;
				model(t3.userData.reflect) ;
			}
        }
		public function initPyramids():void
        {
			var rad:Number = 200 ;
			const TOTAL:Number = 3 ;
            pyramids = new Vector.<IsoPyramid3D>() ;
			
			for (var i:int = 0 ;  i < TOTAL ; i++ ) {
				var p3:IsoPyramid3D = new IsoPyramid3D(100, 1) ;
				var r3:IsoPyramid3D = new IsoPyramid3D(100, 1) ;
				r3.y = 65 ;
				r3.yow(radians(180)) ;
				p3.userData.reflect = r3 ;
				
				var baseAngle:Number = 90 ;
				p3.x = Math.cos(radians(baseAngle + (360 / TOTAL*i))) * rad ;
				p3.z = Math.sin(radians(baseAngle + (360 / TOTAL*i))) * rad/2 ;
				
				r3.x = Math.cos(radians(baseAngle + (360 / TOTAL*i))) * rad ;
				r3.z = Math.sin(radians(baseAngle + (360 / TOTAL*i))) * rad/2 ;
				
				pyramids.push(p3) ;
			}
        }
	}

}