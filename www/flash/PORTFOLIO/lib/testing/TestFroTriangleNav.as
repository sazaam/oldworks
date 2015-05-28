package testing 
{
	import enhancefro.models.IsoTriangle3D;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import frocessing.core.F5C;
	import frocessing.f3d.materials.F3DBmpMaterial;
	import gs.TweenLite;
	/**
	 * ...
	 * @author saz
	 */
	public class TestFroTriangleNav 
	{
		////////////// CONST
		static private const LENGTH:int = 50 ;
		
		
		
		////////////// VARS
		private var __target:Sprite;
		private var __fro:Sprite;
		private var triangles:Vector.<IsoTriangle3D> = new Vector.<IsoTriangle3D>() ;
		////////////// STATIC
		static private var F5MovieClipClass:Class;
		private var __texture:BitmapData;
		
		////////////// CTOR
		public function TestFroTriangleNav(tg:Sprite) 
		{
			__target = tg ;
			init() ;
		}
		////////////// INIT
		private function init():void 
		{
			loadFro() ;
		}
		////////////// LOAD FRO
		private function loadFro():void 
		{
			var url:String = './annexes.swf' ;
			var loader:Loader = new Loader() ;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadFroComplete) ;
			loader.load(new URLRequest(url)) ;
		}
		private function onLoadFroComplete(e:Event):void 
		{
			e.target.removeEventListener(e.type, arguments.callee) ;
			var froClip:Sprite = Sprite(e.target.content) ;
			F5MovieClipClass = froClip.loaderInfo.applicationDomain.getDefinition('frocessing.display::F5MovieClip3D') ;
			
			loadImg() ;
		}
		
		////////////// LOAD IMG
		private function loadImg():void 
		{
			var url:String = '../img/home.jpg' ;
			var loader:Loader = new Loader() ;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImgComplete) ;
			loader.load(new URLRequest(url)) ;
		}
		
		private function onLoadImgComplete(e:Event):void 
		{
			e.target.removeEventListener(e.type, arguments.callee) ;
			__texture = BitmapData(e.target.content.bitmapData) ;
			
			resume() ;
		}
		
		private function resume():void 
		{
			initTriangles(1) ;
			initFro() ;
		}
		
		private function initFro():void 
		{
			var $:* ;
			var w:int = 240, h:int = 400;
			var uW:int = 50, uH:int = 40;
			var x:int = -(uW >> 1), y:int = 0, z:int = 0 ;
			var s:int = 0 ;
			
			F5MovieClipClass.prototype.setup = function():void {
				$ = this ;
				trace('ok setup')
				$.size(w, h) ;
				$.colorMode('rgb', 255, 255, 255) ;
				//$.noStroke() ;
				//$.imageMode('center') ;
				//$.ortho() ;
			}
			//TweenLite
			//F5MovieClipClass.prototype.draw = function():void {
				//$.background(30) ;
				//$.pushMatrix();
				//$.beginBitmapFill(__texture.bitmapData)
				//$.translate(w / 2, h / 2, z) ;
				//$.beginShape(F5C.TRIANGLES) ;
				//$.rotateY(Math.PI / 180.0 * (s)) ;
					//$.triangle (10,10 , 40,40, 70,10)
					//$.bezier3d(0,0,0, 25,-20,0, 45,-25,0, 50,0,0) ;
					//$.bezier3d(50,0,0, 35,15,0, 25,40,0, 15,20,0) ;
					//$.bezier3d(15,20,0, 0,20,0, 0,0,0, 0,0,0) ;
					//$.vertex3d(-uW/2, uH/2, 0) ;
					//$.vertex3d(0, - uH/2, 0) ;
					//$.vertex3d(uW/2 , uH/2 , 0) ;
				//$.endShape() ;
				//$.popMatrix() ;
				//if (s > 360) {
					//s = 0 ;
				//}
				//s += 5 ;
			//}
			
			F5MovieClipClass.prototype.draw = function():void {
				//$.background(30) ;
				var l:int = triangles.length ;
				for (var i:int = 0 ; i < l ; i++ ) {
					//$.pushMatrix();
					$.translate(w / 2, h / 2, z) ;
					var t:IsoTriangle3D = triangles[i] ;
					$.model(t) ;
					//$.popMatrix() ;
				}
			}
			
			
			__fro = make(F5MovieClipClass) ;
			__fro.x = 150 ;
			__fro.y = 50 ;
			__target.addChild(__fro) ;
		}
		
		private function initTriangles(l:int):void 
		{
			for (var i:int = 0 ; i < l ; i++ ) {
				var t:IsoTriangle3D = triangles[i] = new IsoTriangle3D(40) ;
				t.setTexture(__texture, __texture) ;
				trace(t) ;
			}
		}
		
		private function make(c:Class):Object
		{
			return new(c) ;
		}
	}
}

//class Triangle3D 
//{
	////////////// VARS
	//
	////////////// CTOR
	//public function Triangle3D(size:Number = 40, coords3D:Object = null) 
	//{
		//calculateVertexes(size) ;
	//}
	//
	//private function calculateVertexes(size:Number):Point3D
	//{
		//var x:int = 0, y:int = 0, z:int = 0 ;
		//
		//
		//
		//
		//
	//}
	//
	//public function toString():String 
	//{
		//return '[Object Triangle3D]' ;
	//}
//}
//
//class Point3D 
//{
	////////////// VARS
	//public var x:Number
	//public var y:Number
	//public var z:Number
	////////////// CTOR
	//public function Point3D(x:Number = 0 , y:Number = 0 , z:Number = 0) 
	//{
		//this.x = x ;
		//this.y = y ;
		//this.z = z ;
	//}
	//
	//public function toString():String 
	//{
		//return '[object Point3D] >> ( x:'+x+', y:'+y+', z:'+z+')' ;
	//}
//}
