package aguessy.custom.load.geeks 
{
	import flash.display.*;
	import flash.errors.EOFError;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.StyleSheet;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.utils.ByteArray;
	import frocessing.*
	import frocessing.core.F5Graphics3D;
	import frocessing.display.F5MovieClip3D;
	import frocessing.f3d.F3DCamera;
	import frocessing.geom.FMatrix3D;
	import frocessing.core.F5Typographics;
	import frocessing.f3d.materials.F3DColorMaterial;
	import frocessing.f3d.models.F3DCube;
	import frocessing.f3d.F3DGraphics;
	import frocessing.text.PFont;
	import frocessing.text.FFont;
	import frocessing.text.FontUtil;
	import frocessing.math.FMath;
	import naja.model.control.context.Context;
	import naja.model.control.events.EventsRegisterer;
	import naja.model.control.resize.StageResizer;
	
	import saz.helpers.math.Random;
	import saz.helpers.math.Constraint;
	import saz.geeks.sounds.SoundWave;
	import saz.geeks.sounds.SoundDisplayer
	
	
	/*-----		FONTS		---------*/
	import Fonts.NokiaLarge;
	
	/**
	 * ...
	 * @author saz
	 */
	
	public class InitLoader3D extends Sprite {
		public var g					:F5Graphics3D;
		public var tx					:F5Typographics;
		
		private var middleW				:int;
		private var middleH				:int;
		private var ind					:int = 0;
		private var cam					:F3DCamera;
		private var canvas				:Shape;
		private var f					:FFont;
		private var _size				:Number ;		
		private var _font				:Class ;
		private var _color				:uint;
		private var _text				:String;
		private var _leading			:int;
		private var _x					:Number;
		private var _y					:Number;
		private var _w					:Number;
		private var _h					:Number;
		private var _z					:Number;
			
		public function InitLoader3D(__size:Number = 12, __font:Class = null, __color:uint = 0x000000,__text:String = "" , __x:Number = 0 , __y:Number = 0 , __w:Number = 150 , __h:Number = 25 , __z:Number = 1) {
			
			if (__size) _size = __size ;
			if (__font) _font = __font else _font = NokiaLarge ;
			if (__color) _color = __color ;
			if (__text) _text = __text ;
			if (__x) _x = __x ;
			if (__y) _y = __y ;
			if (__w) _w = __w ;
			if (__h) _h = __h ;
			if (__z) _z = __z ;
			initGraphics() ;
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		private function onResize(e:Event = null):void
		{
			var stage:Stage = Context.$query()[0] ; 
			middleW = 120 ;
			middleH = 150 ;
		}
		private function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
			drawOnce() ;
		}
		private function initGraphics():void
		{
			canvas = addChild(new Shape) as Shape;
			onResize() ;
			g = new F5Graphics3D( canvas.graphics, middleW*2, middleH*2);
			g.colorMode("hsv", 425, 1, 1, 1);
			g.noStroke() ;
			tx = new F5Typographics(g);
			tx.align = "center" ;
			f = new FFont(FontUtil.convertFive3DTypo(_font)) ;
			tx.setFont(f, _size) ;
			tx.leading = _leading ;
		}
		private function drawOnce():void
		{
			g.beginDraw();
				g.beginFill(_color, 1) ;
				tx.drawTextRect(text, X, Y, _w, _h, _z)
			g.endDraw();
		}
///////////////////////////////////////////////////////////////////////////////// GETTERS & SETTERS
		public function get font():Class { return _font; }
		public function set font(value:Class):void 	{ _font = value; }
		
		public function get size():Number { return _size; }
		public function set size(value:Number):void { _size = value; }
		
		public function get color():uint { return _color; }
		public function set color(value:uint):void { _color = value; }
		
		public function get text():String { return _text; }
		public function set text(value:String):void { _text = value; drawOnce() }
		
		public function get X():Number { return middleW - this._w/2; }
		public function set X(value:Number):void { _x = value; }
		
		public function get Y():Number { return middleH - 25; }
		public function set Y(value:Number):void { _y = value; }
		
		
		public function get w():Number { return _w; }
		public function set w(value:Number):void { _w = value; }
		
		public function get h():Number { return _h; }
		public function set h(value:Number):void { _h = value; }
		
		public function get Z():Number { return _z; }
		public function set Z(value:Number):void { _z = value; }
		
		public function get leading():int { return _leading; }
		public function set leading(value:int):void { _leading = value; }
	}
}