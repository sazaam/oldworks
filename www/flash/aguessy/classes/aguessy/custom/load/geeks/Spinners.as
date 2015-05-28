package aguessy.custom.load.geeks 
{
	import asSist.$;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import frocessing.core.F5Graphics3D;
	import frocessing.display.F5MovieClip3D;
	import frocessing.f3d.models.F3DPlane;
	import frocessing.f3d.models.F3DSphere;
	import gs.TweenLite;
	import naja.model.control.context.Context;
	import naja.model.control.events.EventsRegisterer;
	import naja.model.control.resize.StageResizer;
	import saz.helpers.math.Percent;
	
	/**
	 * ...
	 * @author saz
	 */
	public class Spinners extends F5MovieClip3D
	{
		static private var ind:int = 0;
		private var circles:Array;
		private var _spinning:Boolean;
		private var way:String;
		private var coords:Object = { rate:1,scale:.2 } ;
		private var middleW:int;
		private var middleH:int;
//////////////////////////////////////////////////////// CTOR
		public function Spinners()
		{
			ind = 0 ;
			initGraphics() ;
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
		}
		///////////////////////////////////////////////////////////////////////////////// EVENTS HANDLERS
		private function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
			var blur:GlowFilter = new GlowFilter(0x777777,1,8,8,2,3) ;
			filters = [blur] ;
			initCircles() ;
		}
		private function onResize():void
		{
			var stage:Stage = Context.$query()[0] ; 
			middleW = stage.stageWidth >> 1 ;
			middleH = stage.stageHeight >> 1 ;
			x = 120 ;
			y = 170 ;
		}
		private function draw(e:Event):void
		{
			var l:int = circles.length ;
			fg.beginDraw();
			switch(way) 
			{
				case 'first' :
					TweenLite.to(coords,.4,{rate:1,scale:.4})
				break ;
				case 'second' :
					TweenLite.to(coords,.3,{rate:3,scale:.1})
				break ;
				case 'third' :
					TweenLite.to(coords, .3, { rate:2, scale:.05 } ) ;
				break;
			}
			scaleX = scaleY = coords.scale ;
			fg.applyMatrix(coords.rate, coords.rate, coords.rate, -coords.rate, 0, 0, 0, 1, 0, 1, 0, 0)
			fg.rotate(ind / 3) ;
			for( var i:int = 0 ; i < l ; i++ )
			{
				var p:F3DPlane = F3DPlane(circles[i]) ;
				fg.model(p) ;
			}
			fg.endDraw();
			ind ++ ;
		}
		///////////////////////////////////////////////////////////////////////////////// INIT
		private function initCircles():void
		{
			circles = [] ;
			var bmp:Bitmap = new Bitmap(null, "auto", true) ;
			var s:Shape = new Shape() ;
			s.graphics.beginFill(0x777777) ;
			s.graphics.drawCircle(8, 8, 8) ;
			s.graphics.endFill() ;
			bmp.bitmapData = new BitmapData(16, 16, true, 0x000000) ;
			bmp.bitmapData.draw(s) ;
			var l:int = 3 ;
			for( var i:int = 0 ; i < l ; i++ )
			{
				var p:F3DPlane = new F3DPlane(16,16) ;
				p.material.backFace = true ;
				var X:int, Y:int, Z:int;
				var coords:Object = getCoords(i, l) ;
				X = coords.x ;
				Y = coords.y ;
				Z = coords.z ;
				p.x = X ;
				p.y = Y ;
				p.setTexture(bmp.bitmapData.clone(),bmp.bitmapData.clone()) ;
				circles.push(p) ;
			}
		}
		private function initGraphics():void
		{
			onResize() ;
			fg.colorMode("hsv", 425, 1, 1, 1);
			fg.noStroke() ;
			fg.rotate(ind / 3) ;
		}
		
		///////////////////////////////////////////////////////////////////////////////// HELPERS
		private function getCoords(i:int,l:int):Object
		{
			var o:Object = { } ;
			var deg:Number = Math.PI * 2 ;
			var inc:Number = deg / l ;
			var angle:Number = inc * (i) ;
			var cosX:Number = Math.cos(angle) ;
			var sinY:Number = Math.sin(angle) ;
			var calcX:Number = 60 * (cosX) ;
			var calcY:Number = 60 * (sinY) ;
			var calcZ:Number = 0 ;
			o.x = calcX ;
			o.y = calcY ;
			o.z = calcZ ;
			return o;
		}
		///////////////////////////////////////////////////////////////////////////////// SPIN & STOPSPIN
		public function spin(_way:String = null):void
		{
			addEventListener(Event.ENTER_FRAME, draw) ;
			way = _way ;
			_spinning = true ;
		}
		public function stopSpin():void
		{
			removeEventListener(Event.ENTER_FRAME, draw) ;
			_spinning = false ;
		}
		
		
		///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get spinning():Boolean { return _spinning }
	}
}