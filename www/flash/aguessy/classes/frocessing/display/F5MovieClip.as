// --------------------------------------------------------------------------
// Project Frocessing
// ActionScript 3.0 drawing library like Processing.
// --------------------------------------------------------------------------
//
// This library is based on Processing. 
// Copyright (c) 2001-04 Massachusetts Institute of Technology
// Copyright (c) 2004-07 Ben Fry and Casey Reas
// http://processing.org
//
// Frocessing drawing library
// Copyright (C) 2008  TAKANAWA Tomoaki (http://nutsu.com) and
//					   Spark project (www.libspark.org)
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
// 
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//
// contact : face(at)nutsu.com
//

package frocessing.display {
	
	import flash.display.Shape;
	import flash.display.StageQuality;
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import frocessing.FC;
	import frocessing.core.F5Graphics;
	import frocessing.color.FColor;
	import frocessing.color.IFColor;
	import frocessing.color.IColor;
	import frocessing.math.FMath;
	import frocessing.math.PerlinNoise;
	import frocessing.math.Random;
	import frocessing.utils.FUtil;
	
	/**
	* F5MovieClip
	* @author nutsu
	* @version 0.1.4
	* 
	* @see frocessing.core.F5Graphics
	* @see frocessing.math.FMath
	* @see frocessing.math.PerlinNoise
	* @see frocessing.utils.FUtil
	* @see frocessing.FC
	*/
	public dynamic class F5MovieClip extends MovieClip{
		
		public static const RGB        :String = FC.RGB;
		public static const HSB        :String = FC.HSB;
		public static const HSV        :String = FC.HSV;
		public static const CORNER        :int = FC.CORNER;
		public static const CORNERS       :int = FC.CORNERS;
		public static const RADIUS        :int = FC.RADIUS;
		public static const CENTER        :int = FC.CENTER;
		public static const POINTS        :int = FC.POINTS;
		public static const LINES         :int = FC.LINES; 
		public static const TRIANGLES     :int = FC.TRIANGLES;
		public static const TRIANGLE_FAN  :int = FC.TRIANGLE_FAN;
		public static const TRIANGLE_STRIP:int = FC.TRIANGLE_STRIP;
		public static const QUADS         :int = FC.QUADS;
		public static const QUAD_STRIP    :int = FC.QUAD_STRIP;
		public static const POLYGON       :int = FC.POLYGON;
		public static const OPEN      :Boolean = FC.OPEN;
		public static const CLOSE     :Boolean = FC.CLOSE;
		public static const PI         :Number = FC.PI;
		public static const TWO_PI     :Number = FC.TWO_PI;
		public static const HALF_PI    :Number = FC.HALF_PI;
		
		protected var _fg:F5Graphics;
		protected var draw_shape:Shape;
		protected var _draw:Function;
		protected var _perlin_noise:PerlinNoise;
		
		private var _loop:Boolean;
		
		/**
		 * 
		 */
		public function F5MovieClip()
		{
			super();
			init();
			_loop = false;
			addEventListener( Event.ADDED_TO_STAGE, _setup );
		}
		
		/**
		 * 
		 */
		protected function init():void
		{
			draw_shape = new Shape();
			_fg = new F5Graphics( draw_shape.graphics );
			addChild( draw_shape );
		}
		
		/**
		 * 
		 */
		private function _setup(e:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, _setup );
			_fg.size( stage.stageWidth, stage.stageHeight );
			loop();
			if ( !_loop )
			{
				_fg.beginDraw();
				addEventListener( Event.ENTER_FRAME, one_time_draw );
			}
			try {
				if ( this["setup"]  is Function )
					this["setup"].apply(this,null);
			}
			catch( e:Error )
			{
				;//nothing
			}
		}
		
		/**
		 * 
		 */
		private function on_enter_frame( e:Event ):void
		{
			_fg.beginDraw();
			_draw();
			_fg.endDraw();
		}
		
		/**
		 * 
		 */
		private function one_time_draw( e:Event ):void
		{
			removeEventListener( Event.ENTER_FRAME, one_time_draw );
			_fg.endDraw();
		}
		
		/**
		 * 
		 */
		public function loop():void 
		{
			if ( _loop == false )
			{
				try {
					if ( this["draw"]  is Function )
					{
						addEventListener( Event.ENTER_FRAME, on_enter_frame );
						_draw = this["draw"];
						_loop = true;
					}
				}
				catch( e:Error )
				{
					;//nothing
				}
			}
		}
		
		/**
		 * 
		 */
		public function noLoop():void
		{
			if ( _loop )
			{
				removeEventListener( Event.ENTER_FRAME, on_enter_frame );
				_loop = false;
			}
		}
		
		//--------------------------------------------------------------------------------------------------- 
		
		public function size( width_:uint, height_:uint ):void{
			_fg.size( width_, height_ );
		}
		
		public function clear():void{
			_fg.clear();
		}
		
		//--------------------------------------------------------------------------------------------------- Color
		
		// Setting
		
		public function colorMode( mode:String, range1_:Number=NaN, range2_:Number=NaN, range3_:Number=NaN, range4_:Number=NaN ):void{
			_fg.colorMode( mode, range1_, range2_, range3_, range4_ );
		}
		public function color( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):FColor{
			return _fg.color( c1, c2, c3, c4 );
		}
		public function color32( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):uint{
			return _fg.color32( c1, c2, c3, c4 );
		}
		public function color24( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):uint{
			return _fg.color24( c1, c2, c3, c4 );
		}
		public function background( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void{
			_fg.background( c1, c2, c3, c4 );
		}
		public function stroke( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void{
			_fg.stroke( c1, c2, c3, c4 );
		}
		public function fill( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void{
			_fg.fill( c1, c2, c3, c4 );
		}
		public function noStroke():void{
			_fg.noStroke();
		}
		public function noFill():void{
			_fg.noFill();
		}
		
		// Creating & Reading
		
		public function red( c:IFColor ):Number{
			return _fg.red( c );
		}
		public function green( c:IFColor ):Number{
			return _fg.green( c );
		}
		public function blue( c:IFColor ):Number{
			return _fg.blue( c );
		}
		public function hue( c:IFColor ):Number{
			return _fg.hue( c );
		}
		public function saturation( c:IFColor ):Number{
			return _fg.saturation( c );
		}
		public function brightness( c:IFColor ):Number{
			return _fg.brightness( c );
		}
		public function f5_alpha( c:IFColor ):Number{
			return _fg.alpha( c );
		}
		public function lerpColor( c1:IFColor, c2:IFColor, amt:Number ):FColor{
			return _fg.lerpColor( c1, c2, amt );
		}
		public function blendColor( c1:IColor, c2:IColor, blend_mode:String ):FColor{
			return _fg.blendColor( c1, c2, blend_mode );
		}
		
		//--------------------------------------------------------------------------------------------------- Shape
		
		// Attribute
		
		public function strokeWeight( thickness:Number ):void{
			_fg.strokeWeight( thickness );
		}
		/**
		 * @see	flash.display.JointStyle
		 */
		public function strokeJoin( jointStyle:String ):void{
			_fg.strokeJoin( jointStyle );
		}
		/**
		 * @see	flash.display.CapsStyle
		 */
		public function strokeCap( capsStyle:String ):void{
			_fg.strokeCap( capsStyle );
		}
		/**
		 * @see frocessing.core.DrawPosMode
		 */
		public function rectMode( mode:int ):void{
			_fg.rectMode( mode );
		}
		/**
		 * @see frocessing.core.DrawPosMode
		 */
		public function ellipseMode( mode:int ):void{
			_fg.ellipseMode( mode );
		}
		
		// Image
		
		public function imageMode( mode:int ):void {
			_fg.imageMode( mode );
		}
		
		public function imageSmoothing( smooth:Boolean ):void {
			_fg.imageSmoothing = smooth;
		}
		
		public function image( img:BitmapData, x_:Number, y_:Number, w:Number = NaN, h:Number = NaN ):void {
			_fg.image( img, x_, y_, w, h );
		}
		
		// 2D Primitives
		
		public function triangle( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number ):void{
			_fg.triangle( x0, y0, x1, y1, x2, y2 ); 
		}		
		public function line( x0:Number, y0:Number, x1:Number, y1:Number ):void{
			_fg.line( x0, y0, x1, y1 );
		}		
		public function arc( x_:Number, y_:Number, width:Number, height:Number, start_radian:Number, stop_radian:Number ):void{
			_fg.arc( x_, y_, width, height, start_radian, stop_radian );
		}
		public function point( x_:Number, y_:Number ):void{
			_fg.point( x_, y_ );
		}		
		public function quad( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void{
			_fg.quad( x0, y0, x1, y1, x2, y2, x3, y3 );
		}		
		public function circle( x_:Number, y_:Number, size:Number ):void{
			_fg.circle( x_, y_, size );
		}		
		public function ellipse( x0:Number, y0:Number, x1:Number, y1:Number ):void{
			_fg.ellipse( x0, y0, x1, y1);
		}
		public function rect( x_:Number, y_:Number, x1:Number, y1:Number ):void{
			_fg.rect( x_, y_, x1, y1 );
		}
		
		// Curves
		
		public function bezier( x0:Number, y0:Number, cx0:Number, cy0:Number, cx1:Number, cy1:Number, x1:Number, y1:Number ):void{
			_fg.bezier( x0, y0, cx0, cy0, cx1, cy1, x1, y1 );
		}
		public function curve( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void{
			_fg.curve( x0, y0, x1, y1, x2, y2, x3, y3 );
		}
		
		public function bezierDetail( detail_step:uint ):void{
			_fg.bezierDetail(detail_step);
		}
		public function curveDetail( detail_step:uint ):void{
			_fg.curveDetail(detail_step);
		}
		public function curveTightness( t:Number ):void {
			_fg.curveTightness( t );
		}
		
		public function qbezierPoint( a:Number, b:Number, c:Number, t:Number ):Number {
			return _fg.qbezierPoint( a, b, c, t );
		}
		public function bezierPoint( a:Number, b:Number, c:Number, d:Number, t:Number ):Number {
			return _fg.bezierPoint( a, b, c, d, t );
		}
		public function curvePoint( a:Number, b:Number, c:Number, d:Number, t:Number ):Number {
			return _fg.curvePoint( a, b, c, d, t );
		}
		
		public function qbezierTangent( a:Number, b:Number, c:Number, t:Number ):Number {
			return _fg.qbezierTangent( a, b, c, t );
		}
		public function bezierTangent( a:Number, b:Number, c:Number, d:Number, t:Number ):Number {
			return _fg.bezierTangent( a, b, c, d, t );
		}
		public function curveTangent( a:Number, b:Number, c:Number, d:Number, t:Number ):Number {
			return _fg.curveTangent( a, b, c, d, t );
		}
		
		
		// VERTEX
		
		public function beginShape( mode:int=99 ):void{
			_fg.beginShape( mode );
		}
		public function texture( texture_:BitmapData ):void {
			_fg.texture( texture_ );
		}
		public function vertex( x_:Number, y_:Number, u_:Number=0, v_:Number=0 ):void {
			_fg.vertex( x_, y_, u_, v_ );
		}
		public function bezierVertex( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x1:Number, y1:Number ):void{
			_fg.bezierVertex( cx0, cy0, cx1, cy1, x1, y1 );
		}
		public function curveVertex( x_:Number, y_:Number ):void {
			_fg.curveVertex( x_, y_ );
		}
		public function endShape( close_path:Boolean=false ):void {
			_fg.endShape( close_path );
		}
		
		
		//--------------------------------------------------------------------------------------------------- MATH WRAP
		
		// Calculation
		public function min( a:Number, b:Number ):Number     { return Math.min(a, b); }
		public function max( a:Number, b:Number ):Number     { return Math.max(a, b); }
		public function round( a:Number ):Number             { return Math.round(a); }
		public function floor( a:Number ):Number             { return Math.floor(a); }
		public function ceil( a:Number ):Number              { return Math.ceil(a); }
		public function pow( num:Number, exp_:Number ):Number{ return Math.pow(num, exp_); }
		public function exp( val:Number ):Number             { return Math.exp(val); }
		public function sqrt( val:Number ):Number            { return Math.sqrt(val); }
		public function abs( val:Number ):Number             { return Math.abs(val); }
		public function log( val:Number ):Number             { return Math.log(val); }
		
		/**
		 * @copy frocessing.math.FMath#dist
		 */
		public function dist( x0:Number, y0:Number, x1:Number, y1:Number ):Number{
			return FMath.dist( x0, y0, x1, y1 );
		}
		public function mag( a:Number, b:Number ):Number {
			return FMath.mag(a, b);
		}
		public function constrain( val:Number, min_value:Number, max_value:Number ):Number {
			return FMath.constrain( val, min_value, max_value );
		}
		public function sq( val:Number ):Number {
			return FMath.sq(val);
		}
		public function norm( val:Number, low:Number, high:Number ):Number {
			return FMath.norm(val, low, high);
		}
		public function lerp( a:Number, b:Number, amt:Number ):Number {
			return FMath.lerp( a, b, amt );
		}
		public function map( val:Number, low1:Number, high1:Number, low2:Number, high2:Number):Number {
			return FMath.map( val, low1, high1, low2, high2 );
		}
		public function dist3d( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number ):Number{
			return FMath.dist3d( x0, y0, x1, y1, x2, y2 );
		}
		public function mag3d( a:Number, b:Number, c:Number ):Number {
			return FMath.mag3d(a, b, c);
		}
		// Trigonometry
		public function sin( val:Number ):Number              { return Math.sin(val); }
		public function cos( val:Number ):Number              { return Math.cos(val); }
		public function tan( val:Number ):Number              { return Math.tan(val); }
		public function asin( val:Number ):Number             { return Math.asin(val); }
		public function acos( val:Number ):Number             { return Math.acos(val); }
		public function atan( val:Number ):Number             { return Math.atan(val); }
		public function atan2( y_:Number, x_:Number):Number   { return Math.atan2(y_, x_); }
		
		public function degrees( rad:Number ):Number {
			return FMath.degrees( rad );
		}
		public function radians( deg:Number ):Number {
			return FMath.radians( deg );
		}
		
		//Random
		public function random( high:Number, low:Number = 0 ):Number
		{
			return FMath.random( high, low );
		}
		
		public function noiseDetail( lod:int, falloff:Number = 0):void
		{
			if ( _perlin_noise == null )
				_perlin_noise = new PerlinNoise();
			_perlin_noise.noiseDetail( lod, falloff );
		}
		
		public function noise( x:Number, y:Number = 0.0, z:Number = 0.0 ):Number
		{
			if ( _perlin_noise == null )
				_perlin_noise = new PerlinNoise();
			return _perlin_noise.noise( x, y, z );
		}
		
		//--------------------------------------------------------------------------------------------------- UTILS
		
		/**
		 * Number を 2進数 の文字列に変換します.
		 * @param	value
		 * @param	digits	文字列の桁数
		 * @see frocessing.utils.FUtil#binary
		 */
		public function binary( value:Number, digits:int=0 ):String{
			return FUtil.binary( value, digits );
		}
		
		/**
		 * 2進数の文字列を uint に変換します.
		 * @see frocessing.utils.FUtil#unbinary
		 */
		public function unbinary( binstr:String ):uint{
			return FUtil.unbinary( binstr );
		}
		
		/**
		 * Number を 16進数 の文字列に変換します.
		 * @param	value
		 * @param	digits	文字列の桁数
		 * @see frocessing.utils.FUtil#hex
		 */
		public function hex( value:Number, digits:int=0 ):String {
			return FUtil.hex( value, digits );
		}
		
		/**
		 * 16進数の文字列を uint に変換します.
		 * @see frocessing.utils.FUtil#unhex
		 */
		public function unhex( hexstr:String ):uint {
			return FUtil.unhex( hexstr );
		}
		
		/**
		 * 年 (2000 などの 4 桁の数字) をローカル時間で返します.
		 * @see frocessing.utils.FUtil#year
		 */
		public function year():Number {
			return FUtil.year();
		}
		
		/**
		 * 月 (1 月は 1、2 月は 2 など) をローカル時間で返します.
		 * @see frocessing.utils.FUtil#month
		 */
		public function month():Number {
			return FUtil.month();
		}
		
		/**
		 * 日付 (1 ～ 31) をローカル時間で返します.
		 * @see frocessing.utils.FUtil#day
		 */
		public function day():Number	{
			return FUtil.day();
		}
		
		/**
		 * 曜日 (日曜日は 0、月曜日は 1 など) をローカル時間で返します.
		 * @see frocessing.utils.FUtil#weekday
		 */
		public function weekday():Number {
			return FUtil.weekday();
		}
		
		/**
		 * 時 (0 ～ 23) をローカル時間で返します.
		 * @see frocessing.utils.FUtil#hour
		 */
		public function hour():Number {
			return FUtil.hour();
		}
		
		/**
		 * 分 (0 ～ 59) をローカル時間で返します.
		 * @see frocessing.utils.FUtil#minute
		 */
		public function minute():Number {
			return FUtil.minute();
		}
		
		/**
		 * 秒 (0 ～ 59) をローカル時間で返します.
		 * @see frocessing.utils.FUtil#second
		 */
		public function second():Number {
			return FUtil.second();
		}
		
		/**
		 * ミリ秒 (0 ～ 999) をローカル時間で返します.
		 * @see frocessing.utils.FUtil#millis
		 */
		public function millis():Number {
			return FUtil.millis();
		}
		
		//--------------------------------------------------------------------------------------------------- Graphics
		
		public function moveToLast():void {
			_fg.moveToLast();
		}
		public function moveTo( x:Number, y:Number ):void{
			_fg.moveTo( x, y );
		}
		public function lineTo( x:Number, y:Number ):void{
			_fg.lineTo( x, y );
		}
		public function curveTo( cx:Number, cy:Number, x:Number, y:Number ):void{
			_fg.curveTo( cx, cy, x, y );
		}
		public function closePath():void {
			_fg.closePath();
		}
		public function rlineTo( x:Number, y:Number ):void {
			_fg.rlineTo( x, y );
		}
		public function scurveTo( x:Number, y:Number ):void {
			_fg.scurveTo( x, y );
		}
		public function sbezierTo( cx1:Number, cy1:Number, x:Number, y:Number ):void {
			_fg.sbezierTo( cx1, cy1, x, y );
		}
		public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void {
			_fg.bezierTo( cx0, cy0, cx1, cy1, x, y );
		}
		public function arcline( x0:Number, y0:Number, x:Number, y:Number, rx:Number, ry:Number, large_arc_flag:Boolean = false, sweep_flag:Boolean = true, x_axis_rotation:Number = 0 ):void {
			_fg.arcline( x0, y0, x, y, rx, ry, large_arc_flag, sweep_flag, x_axis_rotation );
		}
		
		public function drawCircle(x:Number, y:Number, radius:Number):void {
			_fg.drawCircle( x, y, radius );
		}
		public function drawEllipse(x:Number, y:Number, width_:Number, height_:Number):void {
			_fg.drawEllipse( x, y, width_, height_ );
		}
		public function drawRect(x:Number, y:Number, width_:Number, height_:Number):void {
			_fg.drawRect( x, y, width_, height_ );
		}
		public function drawRoundRect(x:Number, y:Number, width_:Number, height_:Number, ellipseWidth:Number, ellipseHeight:Number):void {
			_fg.drawRoundRect( x, y, width_, height_, ellipseWidth, ellipseHeight );
		}
		public function drawRoundRectComplex(x:Number, y:Number, width_:Number, height_:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number):void {
			_fg.drawRoundRectComplex( x, y, width_, height_, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius );
		}
		public function drawPoint( x:Number, y:Number, col:uint = 0, alpha:Number = 1.0 ):void {
			_fg.drawPoint( x, y, col, alpha );
		}
		public function drawLine( x0:Number, y0:Number, x1:Number, y1:Number ):void{
			_fg.drawLine( x0, y0, x1, y1 );
		}
		public function drawTriangle( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number ):void {
			_fg.drawTriangle( x0, y0, x1, y1, x2, y2 );
		}
		public function drawQuad( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void {
			_fg.drawQuad( x0, y0, x1, y1, x2, y2, x3, y3 );
		}
		public function drawPolyline( ...coordinates ):void {
			_fg.drawPolyline.apply( _fg, coordinates );
		}
		public function drawPolygon( coordinates:Array, close_path:Boolean = true ):void {
			_fg.drawPolygon( coordinates, close_path );
		}
		public function drawRegPolygon( x:Number, y:Number, vertex_number:uint, radius:Number, rotation:Number = 0.0 ):void {
			_fg.drawRegPolygon( x, y, vertex_number, radius, rotation );
		}
		public function drawStarPolygon( x:Number, y:Number, vertex_number:uint, radius_out:Number , radius_in:Number, rotation:Number = 0.0 ):void {
			_fg.drawStarPolygon( x, y, vertex_number, radius_out, radius_in, rotation );
		}
		public function drawArc( x:Number, y:Number, rx:Number, ry:Number, begin:Number, end:Number, rotation:Number = 0 ):void {
			_fg.drawArc( x, y, rx, ry, begin, end, rotation );
		}
		public function drawQBezier( x0:Number, y0:Number, cx0:Number, cy0:Number, x1:Number, y1:Number ):void {
			_fg.drawQBezier( x0, y0, cx0, cy0, x1, y1 );
		}
		public function drawBezier( x0:Number, y0:Number, cx0:Number, cy0:Number, cx1:Number, cy1:Number, x1:Number, y1:Number ):void {
			_fg.drawBezier( x0, y0, cx0, cy0, cx1, cy1, x1, y1 );
		}
		public function drawSpline( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void {
			_fg.drawSpline( x0, y0, x1, y1, x2, y2, x3, y3 );
		}
		
		//--------------------------------------------------------------------------------------------------- 
		
		/**
		 * StageQuality を LOW に設定します.
		 */
		public function QLow():void
		{
			if ( stage ) stage.quality = StageQuality.LOW;
		}
		
		/**
		 * StageQuality を MEDIUM に設定します.
		 */
		public function QMedium():void
		{
			if ( stage ) stage.quality = StageQuality.MEDIUM;
		}
		
		/**
		 * StageQuality を HIGH に設定します.
		 */
		public function QHigh():void
		{
			if ( stage ) stage.quality = StageQuality.HIGH;
		}
		
		/**
		 * StageQuality を BEST に設定します.
		 */
		public function QBest():void
		{
			if ( stage ) stage.quality = StageQuality.BEST;
		}
	}
}
