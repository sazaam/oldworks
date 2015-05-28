package graph3D 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fro.display.FroRenderer;
	import frocessing.core.F5Graphics3D;
	import frocessing.f3d.models.F3DCube;
	import frocessing.f3d.models.F3DPlane;
	import frocessing.geom.FNumber3D;
	import gs.TweenLite;
	import org.libspark.utils.ArrayUtil;
	import sketchbook.colors.ColorUtil;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Graph3DView
	{
		internal var __viewPort:FroRenderer;
		internal var __fg:F5Graphics3D;
		internal var __target:DisplayObject;
		private var __rendering:Boolean;
		private var __items:Array;
		private var __ind:int;
		private var defaultColor:uint = 0x535353;
		private var defaultHighlightColor:uint = 0x777777;
		private var sectionColor:uint = 0xFF6600;
		private var __itemSize:int;
		private var middleWidth:Number = 400;
		private var middleHeight:Number = 300;
		private var __totalAvailable:int;
		private var __sections:Array;
		private var __length:int;
		private var __currentPosition:int;
		
		public function Graph3DView() 
		{
			__viewPort = new FroRenderer() ;
		}
		
		public function init3D(_tg:F5Graphics3D):void
		{
			__fg = _tg ;
			initItems() ;
		}
		
		private function onResize():void
		{
			
		}
		
		internal function render(cond:Boolean = true):void
		{
			if (cond) {
				__target.addEventListener(Event.ENTER_FRAME, draw) ;
				__rendering = true ;
			}else {
				__target.removeEventListener(Event.ENTER_FRAME, draw) ;
				__rendering = true ;
			}
			
		}
		
		private function draw(e:Event):void 
		{
			var l:int = __items.length ;
			for( var i:int = 0 ; i < l ; i++ )
			{
				var p:F3DCube = F3DCube(__items[i]) ;
				var fg:F5Graphics3D = p.userData.graphics3D ;
				fg.beginDraw() ;
				fg.rotateX( -1.2) ;
				fg.model(p) ;
				fg.endDraw();
			}
			if (__ind == 359) __ind = -1 ;
			__ind++ ;
		}
		
		
		private function initItems():void
		{
			__itemSize = 10 ;
			__totalAvailable = 7 ;
			__items = [] ;
			__currentPosition = int(__totalAvailable / 2) ;
			//__displayed
			__sections = [] ;
			
			var l:int = __totalAvailable ;
			
			for( var i:int = 0 ; i < l ; i++ )
			{
				var sh:Sprite = new Sprite() ;
				sh.name = "graphItem_" + i ;
				var fgShape:F5Graphics3D = new F5Graphics3D(sh.graphics, middleWidth << 1, middleHeight << 1) ;
				var p:F3DCube
				if (i < 3) {
					sh.alpha = .35 ;
					Sprite(__target).addChild(sh) ;
					p = new F3DCube(__itemSize, __itemSize, __itemSize*2) ;
				}else if (i > 3) {
					Sprite(__target).addChildAt(sh, 0) ;
					p = new F3DCube(__itemSize, __itemSize, __itemSize*2) ;
				}else {
					Sprite(__target).addChild(sh) ;
					p = new F3DCube(__itemSize, __itemSize, __itemSize*2) ;
				}
				sh.addEventListener(MouseEvent.CLICK,onClick) ;
				sh.addEventListener(MouseEvent.ROLL_OVER,onRoll) ;
				sh.addEventListener(MouseEvent.ROLL_OUT,onRoll) ;
				fgShape.colorMode("hsv", 425, 1, 1, 1) ;
				fgShape.noStroke() ;
				fgShape.ortho() ;
				
				p.material.backFace = true ;
				var X:int, Y:int, Z:int;
				var coords:Object = getCoords(i, l) ;
				X = coords.x ;
				Y = coords.y ;
				Z = coords.z ;
				
				p.x = X ;
				p.y = Y ;
				p.z = Z ;
				
				p.userData = { color:i == 3 ? sectionColor : defaultColor, index: i,mc:sh,graphics3D:fgShape } ;
				
				getColors(p) ;
				var f:Object = p.userData.faces ;
				
				p.setColors(f.front, f.right, f.back, f.left, f.top, f.bottom) ;
				p.rotateZ(.75)
				__items.push(p) ;
			}
		}
		
		private function onRoll(e:MouseEvent):void 
		{
			var sh:Sprite = Sprite(e.currentTarget) ;
			var s:String = sh.name ;
			var i:int = int(s.substr(s.lastIndexOf('_') + 1, s.length - 1)) ;
			if (i == 3) return ;
			if (e.type == MouseEvent.ROLL_OVER) {
				highlight(__items[i]) ;
			}else {
				highlight(__items[i],false) ;
			}
		}
		public function variate(i:int,l:int,xml:XML):void
		{
			trace("i : " + i)
			var cube:F3DCube = F3DCube(__items[i]) ;
			TweenLite.to(cube, .3, { scaleZ:l } ) ;
			trace("L : " + l)
			
			//trace(xml)
		}
		private function highlight(p:F3DCube,cond:Boolean = true):void
		{
			var tint:uint ;
			var index:uint = p.userData.index ;
			
			if (cond == true) {
				p.userData.color = defaultHighlightColor ;
				tint = p.userData.color ;
			}else {
				p.userData.color = defaultColor ;
				tint = p.userData.color ;
			}
			
			getColors(p) ;
			var f:Object = p.userData.faces ;
			p.setColors(f.front, f.right, f.back, f.left, f.top, f.bottom) ;
		}
		
		private function onClick(e:MouseEvent):void 
		{
			trace(e.currentTarget.name)
		}
		private function getColors(p:F3DCube):void
		{
			var pObj:Object = p.userData ;
			var tint:uint = pObj.color ;
			//var 
			var tintRGB:Object = ColorUtil.getRGB(tint),frontRGB:Object,rightRGB:Object, backRGB:Object, leftRGB:Object, topRGB:Object, bottomRGB:Object ;
			tintRGB = ColorUtil.RGB2HSB(tintRGB.r, tintRGB.g, tintRGB.b) ;
			frontRGB = ColorUtil.HSB2RGB(tintRGB.h, tintRGB.s, tintRGB.b-20) ;
			topRGB = ColorUtil.HSB2RGB(tintRGB.h, tintRGB.s,  tintRGB.b) ;
			leftRGB = ColorUtil.HSB2RGB(tintRGB.h, tintRGB.s,  tintRGB.b-10) ;
			rightRGB =ColorUtil.HSB2RGB(tintRGB.h, tintRGB.s, tintRGB.b+5) ;
			bottomRGB = ColorUtil.HSB2RGB(tintRGB.h, tintRGB.s,  tintRGB.b-5) ;
			backRGB = ColorUtil.HSB2RGB(tintRGB.h, tintRGB.s,  tintRGB.b-15) ;
			
			var resultFront:uint = frontRGB.r << 16 | frontRGB.g << 8 | frontRGB.b ;
			var resultRight:uint = rightRGB.r << 16 | rightRGB.g << 8 | rightRGB.b ;
			var resultLeft:uint = leftRGB.r << 16 | leftRGB.g << 8 | leftRGB.b ;
			var resultTop:uint = topRGB.r << 16 | topRGB.g << 8 | topRGB.b ;
			var resultBottom:uint = bottomRGB.r << 16 | bottomRGB.g << 8 | bottomRGB.b ;
			var resultBack:uint = backRGB.r << 16 | backRGB.g << 8 | backRGB.b ;
			
			//pObj.faces = {front:new BitmapData(__itemSize, __itemSize, false, resultRight),right:new BitmapData(__itemSize, __itemSize, false, resultRight),back:new BitmapData(__itemSize, __itemSize, false, resultBack),left:new BitmapData(__itemSize, __itemSize, false, resultLeft),top:new BitmapData(__itemSize, __itemSize, false, resultTop),bottom:new BitmapData(__itemSize, __itemSize, false, resultBottom)} ;
			pObj.faces = {front:resultFront,right:resultRight,back:resultBack,left:resultLeft,top:resultTop,bottom:resultBottom} ;
		}
		private function getCoords(i:int,l:int):Object
		{
			var pos:Object = { } ;
			
			var x:Number, y:Number, z:Number,startx:Number, starty:Number ;
			var max:Number = 3 ;
			//startx = __fg.width >> 1 ;
			startx = 0 ;
			//starty = __fg.height >> 1 ;
			starty = 0;
			var half:Number = __itemSize >> 1 ;
			//var half:Number = 0 ;
			var sim:Number = __itemSize * .8 ;
			if (i < max) {
				//x = 0 ;
				//y = (max - i) * __itemSize ;
				x = startx + (sim * -(max - i)) ;
				y = starty + ((max - i) * sim) ;
				z = 0 ;
			}else if(i > max) {
				//x = __itemSize * -(max-i) ;
				//y = 0 ;
				x = startx + (sim * -(max-i)) ;
				y = starty + ( -(max - i) * sim) ;
				z = 0 ;
			}else {
				x = startx ;
				y = starty ;
				z = 0 ;
			}
			//y = (i * 10) ;
			
			pos.x = x ;
			//pos.x = x - half ;
			pos.y = y ;
			//pos.y = y - half ;
			pos.z = z
			return pos ;
		}
	}
	
}