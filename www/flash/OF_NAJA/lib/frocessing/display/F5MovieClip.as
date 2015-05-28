// --------------------------------------------------------------------------
// Project Frocessing
// ActionScript 3.0 drawing library like Processing.
// --------------------------------------------------------------------------
//
// This library is based on Processing.(http://processing.org)
// Copyright (c) 2004-08 Ben Fry and Casey Reas
// Copyright (c) 2001-04 Massachusetts Institute of Technology
// 
// Frocessing drawing library
// Copyright (C) 2008-09  TAKANAWA Tomoaki (http://nutsu.com) and
//					   	  Spark project (www.libspark.org)
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
	import flash.display.DisplayObject;
	import flash.display.StageQuality;
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.net.URLLoader;
	import flash.display.Loader;
	
	import frocessing.core.F5C;
	import frocessing.core.F5Graphics;
	import frocessing.core.F5Draw;
	import frocessing.color.FColor;
	import frocessing.color.ColorLerp;
	import frocessing.color.ColorBlend;
	import frocessing.text.IFont;
	import frocessing.text.PFontLoader;
	import frocessing.math.FMath;
	import frocessing.math.FCurveMath;
	import frocessing.math.PerlinNoise;
	import frocessing.math.Random;
	import frocessing.shape.IFShape;
	import frocessing.shape.FShapeSVGLoader;
	import frocessing.bmp.FImageLoader;
	import frocessing.utils.FStringLoader;
	import frocessing.utils.FUtil;
	import frocessing.utils.FDate;
	
	import frocessing.f5internal;
	use namespace f5internal;
	
	/**
	* F5MovieClip
	* 
	* @author nutsu
	* @version 0.5.8
	* 
	* @see frocessing.core.F5Graphics
	* @see frocessing.color.FColor
	* @see frocessing.math.FMath
	* @see frocessing.math.PerlinNoise
	* @see frocessing.utils.FUtil
	*/
	public dynamic class F5MovieClip extends MovieClip
	{
		// constants
		
		public static const RGB        :String = F5C.RGB;
		public static const HSB        :String = F5C.HSB;
		public static const HSV        :String = F5C.HSV;
		public static const CORNER        :int = F5C.CORNER;
		public static const CORNERS       :int = F5C.CORNERS;
		public static const RADIUS        :int = F5C.RADIUS;
		public static const CENTER        :int = F5C.CENTER;
		public static const LEFT    	  :int = F5C.LEFT;
		public static const RIGHT   	  :int = F5C.RIGHT;
		public static const BASELINE	  :int = F5C.BASELINE;
		public static const TOP     	  :int = F5C.TOP;
		public static const BOTTOM  	  :int = F5C.BOTTOM;
		public static const POINTS        :int = F5C.POINTS;
		public static const LINES         :int = F5C.LINES; 
		public static const TRIANGLES     :int = F5C.TRIANGLES;
		public static const TRIANGLE_FAN  :int = F5C.TRIANGLE_FAN;
		public static const TRIANGLE_STRIP:int = F5C.TRIANGLE_STRIP;
		public static const QUADS         :int = F5C.QUADS;
		public static const QUAD_STRIP    :int = F5C.QUAD_STRIP;
		public static const OPEN      :Boolean = F5C.OPEN;
		public static const CLOSE     :Boolean = F5C.CLOSE;
		public static const NORMALIZED    :int = F5C.NORMALIZED;
		public static const IMAGE         :int = F5C.IMAGE;
		
		public static const PI         :Number = F5C.PI;
		public static const TWO_PI     :Number = F5C.TWO_PI;
		public static const HALF_PI    :Number = F5C.HALF_PI;
		
		public static const NORMAL      :String	= ColorBlend.NORMAL;
		public static const ADD         :String	= ColorBlend.ADD;
		public static const SUBTRACT    :String = ColorBlend.SUBTRACT;
		public static const DARKEN      :String = ColorBlend.DARKEN;
		public static const LIGHTEN     :String = ColorBlend.LIGHTEN;
		public static const DIFFERENCE  :String = ColorBlend.DIFFERENCE;
		public static const MULTIPLY    :String = ColorBlend.MULTIPLY;
		public static const SCREEN      :String = ColorBlend.SCREEN;
		public static const OVERLAY     :String = ColorBlend.OVERLAY;
		public static const HARDLIGHT   :String = ColorBlend.HARDLIGHT;
		public static const SOFTLIGHT   :String = ColorBlend.SOFTLIGHT;
		public static const DODGE       :String = ColorBlend.DODGE;
		public static const BURN        :String	= ColorBlend.BURN;
		public static const EXCLUSION   :String = ColorBlend.EXCLUSION;
		
		/** @private */
		internal var __fg:F5Graphics;
		/** @private */
		internal var __draw_method:F5Draw;
		/** @private */
		internal var __draw_target:DisplayObject;
		
		// loop
		private var __loop:Boolean;
		
		// setup flg
		private var __setup_flg:Boolean;
		private var __setup_load:Array;
		private var __start_loop:Boolean;
		
		// setting function
		private var __draw:Function;
		private var __setup:Function;
		private var __mouseClicked:Function;
		private var __mouseMoved:Function;
		private var __mousePressed:Function;
		private var __mouseReleased:Function;
		private var __keyPressed:Function;
		private var __keyReleased:Function;
		private var __keyTyped:Function;
		
		// pre mouse
		private var __pmouseX:Number;
		private var __pmouseY:Number;
		private var __isMousePressed:Boolean;
		private var __isKeyPressed:Boolean;
		private var __keyCode:uint;
		
		// noise
		private var __perlin_noise:PerlinNoise;
		
		/**
		 * setup() 内の読み込み(loadShape,loadImage,loadFont,loadString)を待つかどうか指定します.
		 */
		public var syncSetup:Boolean;
		
		/**
		 * 
		 */
		public function F5MovieClip()
		{
			super();
			
			__pmouseX = 0;
			__pmouseY = 0;
			__isMousePressed = false;
			__isKeyPressed   = false;
			__keyCode        = 0;
			
			//check setup() and draw()
			syncSetup       = true;
			__setup_flg     = false;
			__loop          = false;
			__setup         = __getfunction("setup");
			__draw          = __getfunction("draw");
			__mouseClicked  = __getfunction("mouseClicked");
			__mouseMoved    = __getfunction("mouseMoved");
			__mousePressed  = __getfunction("mousePressed");
			__mouseReleased = __getfunction("mouseReleased");
			__keyPressed    = __getfunction("keyPressed");
			__keyReleased   = __getfunction("keyReleased");
			
			//init perlin noise
			__perlin_noise = new PerlinNoise();
			
			//init
			__init();
			__draw_method = new F5Draw( __fg );
			
			//TODO:other initialize trigger
			addEventListener( Event.ADDED_TO_STAGE, __on_added_to_stage );
		}
		
		/**
		 * view object.
		 * <p>
		 * F5MovieClip,F5MovieClip2D,F5MovieClip3D -> Shape<br/>
		 * F5MovieClip2DBmp,F5MovieClip3DBmp -> Bitmap
		 * </p>
		 * 
		 * @private
		 */
		public function get viewport():DisplayObject { return __draw_target; }
		
		/**
		 * initialize F5Graphics
		 * @private 
		 */
		internal function __init():void
		{
			__draw_target = new Shape();
			__fg = new F5Graphics( Shape(__draw_target).graphics );
			__fg.size( __stage_width, __stage_height );
			addChild( __draw_target );
			
			//for framescript
			__fg.beginDraw();
		}
		
		/** @private */
		internal function get __stage_width():Number
		{
			if ( stage == null ) 				return 100;
			else if ( stage.stageWidth > 0 ) 	return stage.stageWidth;
			else								return 100;
		}
		
		/** @private */
		internal function get __stage_height():Number
		{
			if ( stage == null )				return 100;
			else if ( stage.stageHeight > 0 )	return stage.stageHeight;
			else								return 100;
		}
		
		/** @private */
		private function __getfunction( functionName:String ):Function
		{
			try 
			{
				return ( this[functionName] is Function ) ? this[functionName] : null;
			}
			catch( e:Error )
			{
				;
			}
			return null;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * setup and start draw
		 * @private
		 */
		private function __on_added_to_stage(e:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, __on_added_to_stage );
			
			//begin set up
			__start_loop = true;
			__setup_flg  = true;
			__setup_load = [];
			
			//event init
			__ui_event_init();
			
			//setup function apply
			if ( __setup != null )
				__setup.apply(this,null);
			
			//start draw
			if ( __setup_load.length == 0 )
				__start();
				
			addEventListener( Event.REMOVED_FROM_STAGE, __on_removed_from_stage );
		}
		
		private function __on_added_to_stage2(e:Event):void
		{
			__ui_event_init();
			
			if ( __start_loop ) 
				loop();
			
			addEventListener( Event.REMOVED_FROM_STAGE, __on_removed_from_stage );
		}
		
		private function __ui_event_init():void
		{
			//mouse and key Event
			if ( stage != null )
			{
				stage.addEventListener( KeyboardEvent.KEY_DOWN, _keyPressed );
				stage.addEventListener( KeyboardEvent.KEY_UP,  _keyReleased );
				stage.addEventListener( MouseEvent.MOUSE_DOWN, _mousePressed );
				stage.addEventListener( MouseEvent.MOUSE_UP,   _mouseReleased );
				if ( __mouseClicked  != null ) stage.addEventListener( MouseEvent.CLICK, _mouseClicked );
				if ( __mouseMoved    != null ) stage.addEventListener( MouseEvent.MOUSE_MOVE, _mouseMoved );
			}
			__loop           = false;
			__pmouseX        = mouseX;
			__pmouseY        = mouseY;
			__isMousePressed = false;
			__isKeyPressed   = false;
			__keyCode        = 0;
		}
		
		private function __on_removed_from_stage(e:Event):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE, __on_removed_from_stage );
			
			__start_loop = __loop;
			noLoop();
			
			stage.removeEventListener( KeyboardEvent.KEY_DOWN, _keyPressed );
			stage.removeEventListener( KeyboardEvent.KEY_UP,  _keyReleased );
			stage.removeEventListener( MouseEvent.MOUSE_DOWN, _mousePressed );
			stage.removeEventListener( MouseEvent.MOUSE_UP,   _mouseReleased );
			if ( __mouseClicked  != null ) stage.removeEventListener( MouseEvent.CLICK, _mouseClicked );
			if ( __mouseMoved    != null ) stage.removeEventListener( MouseEvent.MOUSE_MOVE, _mouseMoved );
			
			addEventListener( Event.ADDED_TO_STAGE, __on_added_to_stage2 );
		}
		
		/**
		 * callback function of load methods
		 * @private
		 */
		private function __setup_load_callback():void
		{
			__setup_load.pop();
			if ( __setup_load.length == 0 )
				__start();
		}
		
		/**
		 * start draw
		 * @private
		 */
		private function __start():void
		{
			__setup_load = null;
			
			var __predraw:Function = __getfunction("predraw");
			if ( __predraw != null )
				__predraw.apply( this, null );
			
			//1st:apply framescript.
			addEventListener( Event.ENTER_FRAME, __on_framescript_draw );
		}
		
		/**
		 * @private
		 */
		private function __on_framescript_draw( e:Event ):void
		{
			removeEventListener( Event.ENTER_FRAME, __on_framescript_draw );
			
			__setup_flg = false;
			if( stage != null )
			{
				__fg.endDraw();
				if ( __start_loop )	loop();
				else 				redraw();
			}
		}
		
		/**
		 * @private
		 */
		private function __on_enter_frame( e:Event ):void
		{
			__fg.beginDraw();
			__draw();
			__fg.endDraw();
			//mouse coordinates
			__pmouseX = mouseX;
			__pmouseY = mouseY;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * call draw()
		 */
		public function redraw():void
		{
			if ( __draw != null )
				__on_enter_frame(null);
		}
		
		/**
		 * apply draw() on enterframe.
		 */
		public function loop():void 
		{
			if ( __setup_flg )
			{
				__start_loop = true;
			}
			else
			{
				if ( __loop == false && __draw != null )
				{
					addEventListener( Event.ENTER_FRAME, __on_enter_frame );
					__loop = true;
					__pmouseX = mouseX;
					__pmouseY = mouseY;
				}
			}
		}
		
		/**
		 * stop draw() on enterframe.
		 */
		public function noLoop():void
		{
			if ( __setup_flg )
			{
				__start_loop = false;
			}
			else
			{
				if ( __loop )
				{
					removeEventListener( Event.ENTER_FRAME, __on_enter_frame );
					__loop = false;
				}
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		private function _mousePressed( e:MouseEvent ):void
		{
			__isMousePressed = true;
			if( __mousePressed!=null ) __mousePressed();
		}
		private function _mouseReleased( e:MouseEvent ):void
		{ 
			__isMousePressed = false;
			if( __mouseReleased!=null ) __mouseReleased(); 
		}
		private function _keyPressed( e:KeyboardEvent ):void
		{ 
			__isKeyPressed = true;
			__keyCode = e.keyCode;
			if( __keyPressed!=null ) __keyPressed();
		}
		private function _keyReleased( e:KeyboardEvent ):void 
		{ 
			__isKeyPressed = false;
			if( __keyReleased!=null ) __keyReleased();
		}
		private function _mouseClicked( e:MouseEvent ):void{  __mouseClicked();  }
		private function _mouseMoved( e:MouseEvent ):void{    __mouseMoved();    }
		
		public function get pmouseX():Number { return __pmouseX; }
		public function get pmouseY():Number { return __pmouseY; }
		public function get isMousePressed():Boolean { return __isMousePressed; }
		public function get isKeyPressed():Boolean { return __isKeyPressed; }
		public function get keyCode():uint { return __keyCode; }
		
		//-------------------------------------------------------------------------------------------------------------------
		
		public function size( width_:uint, height_:uint ):void{
			__fg.size( width_, height_ );
		}
		
		public function clear():void{
			__fg.clear();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Color
		//-------------------------------------------------------------------------------------------------------------------
		
		public function colorMode( mode:String, range1:Number=0xff, range2:Number=NaN, range3:Number=NaN, range4:Number=NaN ):void{
			__fg.colorMode( mode, range1, range2, range3, range4 );
		}
		public function color( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):uint{
			return __fg.color( c1, c2, c3, c4 );
		}
		public function background( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void{
			__fg.background( c1, c2, c3, c4 );
		}
		public function stroke( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void{
			__fg.stroke( c1, c2, c3, c4 );
		}
		public function fill( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void{
			__fg.fill( c1, c2, c3, c4 );
		}
		public function noStroke():void{
			__fg.noStroke();
		}
		public function noFill():void{
			__fg.noFill();
		}
		public function tint( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void{
			__fg.tint( c1, c2, c3, c4 );
		}
		public function noTint():void{
			__fg.noTint();
		}
		// Color Creating & Reading
		
		public function red( c:uint ):Number{
			return __fg.colorModeX * FColor.red( c )/0xff;
		}
		public function green( c:uint ):Number{
			return __fg.colorModeY * FColor.green( c )/0xff;
		}
		public function blue( c:uint ):Number{
			return __fg.colorModeZ * FColor.blue( c )/0xff;
		}
		public function hue( c:uint ):Number{
			return __fg.colorModeX * FColor.hue( c )/360;
		}
		public function saturation( c:uint ):Number{
			return __fg.colorModeY * FColor.saturation( c );
		}
		public function brightness( c:uint ):Number{
			return __fg.colorModeZ * FColor.brightness( c );
		}
		public function f5_alpha( c:uint ):Number{
			return __fg.colorModeA * FColor.alpha( c );
		}
		public function lerpColor( c1:uint, c2:uint, amt:Number ):uint{
			ColorLerp.mode = __fg.colorModeState;
			return ColorLerp.lerp( c1, c2, amt );
		}
		public function blendColor( c1:uint, c2:uint, blend_mode:String ):uint{
			return ColorBlend.blend( c1, c2, blend_mode );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Attribute
		//-------------------------------------------------------------------------------------------------------------------
		
		public function strokeWeight( thickness:Number ):void{
			__fg.strokeWeight( thickness );
		}
		/**
		 * @see	flash.display.JointStyle
		 */
		public function strokeJoin( jointStyle:String ):void{
			__fg.strokeJoin( jointStyle );
		}
		/**
		 * @see	flash.display.CapsStyle
		 */
		public function strokeCap( capsStyle:String ):void{
			__fg.strokeCap( capsStyle );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Style
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function pushStyle():void{
			__fg.pushStyle();
		}
		
		/**
		 * 
		 */
		public function popStyle():void{
			__fg.popStyle();
		}
		
		//------------------------------------------------------------------------------------------------------------------- Shape
		
		/**
		 * @param	mode 	CORNER | CORNERS | RADIUS | CENTER
		 */
		public function rectMode( mode:int ):void {
			__fg.rectMode( mode );
		}
		
		/**
		 * @param	mode 	CORNER | CORNERS | RADIUS | CENTER
		 */
		public function ellipseMode( mode:int ):void {
			__fg.ellipseMode( mode );
		}
		
		/**
		 *  @param	mode 	CORNER | CORNERS | CENTER
		 */
		public function imageMode( mode:int ):void {
			__fg.imageMode( mode );
		}
		
		/**
		 *  @param	mode 	CORNER | CORNERS | CENTER
		 */
		public function shapeMode( mode:int ):void {
			__fg.shapeMode( mode );
		}
		
		/**
		 * 画像を描画する場合の Smoothing を設定します.
		 */
		public function imageSmoothing( smooth:Boolean ):void {
			__fg.imageSmoothing( smooth );
		}
		
		/**
		 * 画像を変形して描画する際の精度を指定します.
		 */
		public function imageDetail( segmentNumber:uint ):void {
			__fg.imageDetail( segmentNumber );
		}
		
		//------------------------------------------------------------------------------------------------------------------- Text
		
		/**
		 * text の　size を指定します.
		 * @param	fontSize
		 */
		public function textSize( fontSize:Number ):void {
			__fg.textSize( fontSize );
		}
		
		/**
		 * text の　align を指定します.
		 * @param	align	CENTER,LEFT,RIGHT
		 * @param	alignY	BASELINE,TOP,BOTTOM
		 */
		public function textAlign( align:int, alignY:int = 0 ):void {
			__fg.textAlign( align, alignY );
		}
		
		/**
		 * text の　行高 を指定します.
		 */
		public function textLeading( leading:Number ):void {
			__fg.textLeading( leading );
		}
		
		/**
		 * not implemented
		 */
		public function textMode( mode:int ):void {
			;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Shape
		//-------------------------------------------------------------------------------------------------------------------
		
		// 2D Primitives
		
		public function point( x:Number, y:Number, z:Number = 0 ):void{
			__fg.point( x, y, z );
		}	
		public function triangle( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number ):void{
			__fg.triangle( x0, y0, x1, y1, x2, y2 ); 
		}		
		public function line( x0:Number, y0:Number, x1:Number, y1:Number ):void{
			__fg.line( x0, y0, x1, y1 );
		}		
		public function arc( x:Number, y:Number, width:Number, height:Number, start_radian:Number, stop_radian:Number ):void{
			__fg.arc( x, y, width, height, start_radian, stop_radian );
		}
		public function quad( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void{
			__fg.quad( x0, y0, x1, y1, x2, y2, x3, y3 );
		}		
		public function circle( x:Number, y:Number, radius:Number ):void{
			__fg.circle( x, y, radius );
		}		
		public function ellipse( x0:Number, y0:Number, x1:Number, y1:Number ):void{
			__fg.ellipse( x0, y0, x1, y1);
		}
		public function rect( x:Number, y:Number, x1:Number, y1:Number, rx:Number=0, ry:Number=0 ):void{
			__fg.rect( x, y, x1, y1, rx, ry );
		}
		
		// Curves
		
		public function bezier( x0:Number, y0:Number, cx0:Number, cy0:Number, cx1:Number, cy1:Number, x1:Number, y1:Number ):void{
			__fg.bezier( x0, y0, cx0, cy0, cx1, cy1, x1, y1 );
		}
		public function curve( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void{
			__fg.curve( x0, y0, x1, y1, x2, y2, x3, y3 );
		}
		
		public function bezierDetail( detail_step:uint ):void{
			__fg.bezierDetail(detail_step);
		}
		public function curveDetail( detail_step:uint ):void{
			__fg.curveDetail(detail_step);
		}
		public function curveTightness( t:Number ):void {
			__fg.curveTightness( t );
		}
		
		public function qbezierPoint( a:Number, b:Number, c:Number, t:Number ):Number {
			return FCurveMath.qbezierPoint( a, b, c, t );
		}
		public function bezierPoint( a:Number, b:Number, c:Number, d:Number, t:Number ):Number {
			return FCurveMath.bezierPoint( a, b, c, d, t );
		}
		public function curvePoint( a:Number, b:Number, c:Number, d:Number, t:Number ):Number {
			return FCurveMath.curvePoint( a, b, c, d, t, __fg.f5internal::splineTightness );
		}
		public function qbezierTangent( a:Number, b:Number, c:Number, t:Number ):Number {
			return FCurveMath.qbezierTangent( a, b, c, t );
		}
		public function bezierTangent( a:Number, b:Number, c:Number, d:Number, t:Number ):Number {
			return FCurveMath.bezierTangent( a, b, c, d, t );
		}
		public function curveTangent( a:Number, b:Number, c:Number, d:Number, t:Number ):Number {
			return FCurveMath.curveTangent( a, b, c, d, t, __fg.f5internal::splineTightness );
		}
		
		
		// VERTEX
		
		public function beginShape( mode:int=0 ):void{
			__fg.beginShape( mode );
		}
		public function texture( textureData:BitmapData ):void {
			__fg.texture( textureData );
		}
		public function textureMode( mode:int ):void {
			__fg.textureMode( mode );
		}
		public function vertex( x:Number, y:Number, u:Number=0, v:Number=0 ):void {
			__fg.vertex( x, y, u, v );
		}
		public function bezierVertex( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x1:Number, y1:Number ):void{
			__fg.bezierVertex( cx0, cy0, cx1, cy1, x1, y1 );
		}
		public function curveVertex( x:Number, y:Number ):void {
			__fg.curveVertex( x, y );
		}
		public function endShape( close_path:Boolean=false ):void {
			__fg.endShape( close_path );
		}
		
		
		// PATH
		
		public function moveTo( x:Number, y:Number, z:Number=0 ):void{
			__fg.moveTo( x, y, z );
		}
		public function lineTo( x:Number, y:Number, z:Number=0 ):void{
			__fg.lineTo( x, y, z );
		}
		public function curveTo( cx:Number, cy:Number, x:Number, y:Number ):void{
			__fg.curveTo( cx, cy, x, y );
		}
		public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void {
			__fg.bezierTo( cx0, cy0, cx1, cy1, x, y );
		}
		public function splineTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void {
			__fg.splineTo( cx0, cy0, cx1, cy1, x, y );
		}
		public function arcTo( x:Number, y:Number, rx:Number, ry:Number, begin:Number, end:Number, rotation:Number=0 ):void {
			__fg.arcTo( x, y, rx, ry, begin, end, rotation );
		}
		public function arcCurve( x0:Number, y0:Number, x:Number, y:Number, rx:Number, ry:Number, large_arc_flag:Boolean = false, sweep_flag:Boolean = true, x_axis_rotation:Number = 0 ):void {
			__fg.arcCurve( x0, y0, x, y, rx, ry, large_arc_flag, sweep_flag, x_axis_rotation );
		}
		/** @private */
		public function arcCurveTo( x0:Number, y0:Number, x:Number, y:Number, rx:Number, ry:Number, large_arc_flag:Boolean = false, sweep_flag:Boolean = true, x_axis_rotation:Number = 0 ):void {
			__fg.arcCurveTo( x0, y0, x, y, rx, ry, large_arc_flag, sweep_flag, x_axis_rotation );
		}
		public function closePath():void {
			__fg.closePath();
		}
		public function moveToLast():void {
			__fg.moveToLast();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Shape
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * paratmeters(x,y,w,h) is applyed in F5MovieClip2D or F5MovieClip3D
		 */
		public function shape( s:IFShape, x:Number=NaN, y:Number=NaN, w:Number = NaN, h:Number = NaN ):void {
			__fg.shape( s, x, y, w, h );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// IMAGE
		//-------------------------------------------------------------------------------------------------------------------
		
		public function image( img:BitmapData, x:Number, y:Number, w:Number = NaN, h:Number = NaN ):void {
			__fg.image( img, x, y, w, h );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// TEXT
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 描画する font を指定します.
		 * @param	font
		 * @param	fontSize
		 */
		public function textFont( font:IFont, fontSize:Number=NaN ):void{
			__fg.textFont( font, fontSize );
		}
		
		/**
		 * text を描画します.
		 * 
		 * <p>引数の数により色の指定が異なります.</p>
		 * 
		 * <listing>text( string, x, y )</listing>
		 * <listing>text( string, x, y, z ) when 3D</listing>
		 * <listing>text( string, x, y, width, height )</listing>
		 * <listing>text( string, x, y, width, height, z ) when 3D</listing>
		 */
		public function text( str:String, a:Number, b:Number, c:Number=0, d:Number=0, e:Number=0 ):void{
			__fg.text( str, a, b, c, d, e );
		}
		
		/**
		 * 
		 */
		public function textAscent():Number{
			return __fg.textAscent();
		}
		
		/**
		 * 
		 */
		public function textDescent():Number{
			return __fg.textDescent();
		}
		
		/**
		 * 文字列の幅を取得します.
		 */
		public function textWidth( str:String ):Number{
			return __fg.textWidth( str );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// FILE/LOAD
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * SVG Shape を読み込みます.
		 * 
		 * <p>syncSetup が true の場合、setup() で実行すると、読み込み完了後に draw() が実行されます.</p>
		 * <listing>
		 * var shapedata:FShapeSVG;
		 * function setup():void{
		 *   shapedata = loadShape("sample.svg");
		 * }
		 * function draw():void{
		 *   shape( shapedata );
		 * }
		 * </listing>
		 * 
		 * @param	url
		 * @param	loader
		 * @see frocessing.shape.FShapeSVGLoader
		 */
		public function loadShape( url:String, loader:URLLoader = null ):FShapeSVGLoader {
			if ( __setup_flg && syncSetup ){
				var s:FShapeSVGLoader = new FShapeSVGLoader( url, loader, __setup_load_callback );
				__setup_load.push( s );
				return s;
			}else{
				return new FShapeSVGLoader( url, loader );
			}
		}
		
		/**
		 * Image を読み込みます.
		 * 
		 * <p>syncSetup が true の場合、setup() で実行すると、読み込み完了後に draw() が実行されます.</p>
		 * <listing>
		 * var imgdata:FImage;
		 * function setup():void{
		 *   imgdata = loadImage("sample.jpg");
		 * }
		 * function draw():void{
		 *   image( imgdata.bitmapData );
		 * }
		 * </listing>
		 * 
		 * @param	url
		 * @param	loader
		 * @see frocessing.bmp.FImageLoader
		 */
		public function loadImage( url:String, loader:Loader = null ):FImageLoader
		{
			if ( __setup_flg && syncSetup ){
				var s:FImageLoader = new FImageLoader( url, loader, __setup_load_callback );
				__setup_load.push( s );
				return s;
			}else{
				return new FImageLoader( url, loader );
			}
		}
		
		/**
		 * PFont を読み込みます.
		 * 
		 * <p>syncSetup が true の場合、setup() で実行すると、読み込み完了後に draw() が実行されます.</p>
		 * <listing>
		 * var font:PFont;
		 * function setup():void{
		 *   font = loadFont("sample.vlw");
		 * }
		 * function draw():void{
		 *   textFont( font, 24 );
		 *   text( "Sample", 100, 100 );
		 * }
		 * </listing>
		 * 
		 * @param	url		vlw file
		 * @param	loader
		 * @see frocessing.text.PFontLoader
		 */
		public function loadFont( font_url:String, loader:URLLoader = null ):PFontLoader {
			if ( __setup_flg && syncSetup ){
				var s:PFontLoader = new PFontLoader( font_url, loader, __setup_load_callback );
				__setup_load.push( s );
				return s;
			}else{
				return new PFontLoader( font_url, loader );
			}
		}
		
		/**
		 * String を読み込みます.
		 * 
		 * <p>syncSetup が true の場合、setup() で実行すると、読み込み完了後に draw() が実行されます.</p>
		 * <listing>
		 * var strloader:FStringLoader;
		 * function setup():void{
		 *   strloader = loadString("sample.txt");
		 * }
		 * function draw():void{
		 *   trace( strloader.toString() );
		 * }
		 * </listing>
		 * 
		 * @param	url
		 * @param	loader
		 * @see frocessing.utils.FStringLoader
		 */
		public function loadString( url:String, loader:URLLoader = null ):FStringLoader {
			if ( __setup_flg && syncSetup ){
				var s:FStringLoader = new FStringLoader( url, loader, __setup_load_callback );
				__setup_load.push( s );
				return s;
			}else{
				return new FStringLoader( url, loader );
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// MATH
		//-------------------------------------------------------------------------------------------------------------------
		
		// Calculation
		public static function min( a:Number, b:Number ):Number     { return (a < b) ? a : b; }
		public static function max( a:Number, b:Number ):Number     { return (a > b) ? a : b; }
		public static function round( a:Number ):Number             { return Math.round(a); }
		public static function floor( a:Number ):Number             { return Math.floor(a); }
		public static function ceil( a:Number ):Number              { return Math.ceil(a); }
		public static function pow( num:Number, exp_:Number ):Number{ return Math.pow(num, exp_); }
		public static function exp( val:Number ):Number             { return Math.exp(val); }
		public static function sqrt( val:Number ):Number            { return Math.sqrt(val); }
		public static function abs( val:Number ):Number             { return (val < 0) ? -val : val; }
		public static function log( val:Number ):Number             { return Math.log(val); }
		
		/**
		 * @see frocessing.math.FMath
		 */
		public static function dist( x0:Number, y0:Number, x1:Number, y1:Number ):Number{
			return FMath.dist( x0, y0, x1, y1 );
		}
		/**
		 * @see frocessing.math.FMath
		 */
		public static function mag( a:Number, b:Number ):Number {
			return FMath.mag(a, b);
		}
		/**
		 * @see frocessing.math.FMath
		 */
		public static function constrain( val:Number, min_value:Number, max_value:Number ):Number {
			return FMath.constrain( val, min_value, max_value );
		}
		/**
		 * @see frocessing.math.FMath
		 */
		public static function sq( val:Number ):Number {
			return FMath.sq(val);
		}
		/**
		 * @see frocessing.math.FMath
		 */
		public static function norm( val:Number, low:Number, high:Number ):Number {
			return FMath.norm(val, low, high);
		}
		/**
		 * @see frocessing.math.FMath
		 */
		public static function lerp( a:Number, b:Number, amt:Number ):Number {
			return FMath.lerp( a, b, amt );
		}
		/**
		 * @see frocessing.math.FMath
		 */
		public static function map( val:Number, low1:Number, high1:Number, low2:Number, high2:Number):Number {
			return FMath.map( val, low1, high1, low2, high2 );
		}
		/**
		 * @see frocessing.math.FMath
		 */
		public static function dist3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number ):Number{
			return FMath.dist3d( x0, y0, z0, x1, y1, z1 );
		}
		/**
		 * @see frocessing.math.FMath
		 */
		public static function mag3d( a:Number, b:Number, c:Number ):Number {
			return FMath.mag3d(a, b, c);
		}
		
		// Trigonometry
		public static function sin( val:Number ):Number              	{ return Math.sin(val); }
		public static function cos( val:Number ):Number              	{ return Math.cos(val); }
		public static function tan( val:Number ):Number              	{ return Math.tan(val); }
		public static function asin( val:Number ):Number             	{ return Math.asin(val); }
		public static function acos( val:Number ):Number             	{ return Math.acos(val); }
		public static function atan( val:Number ):Number             	{ return Math.atan(val); }
		public static function atan2( y:Number, x:Number):Number   		{ return Math.atan2(y, x); }
		
		/**
		 * @see frocessing.math.FMath
		 */
		public static function degrees( rad:Number ):Number {
			return FMath.degrees( rad );
		}
		/**
		 * @see frocessing.math.FMath
		 */
		public static function radians( deg:Number ):Number {
			return FMath.radians( deg );
		}
		
		//Random
		
		/**
		 * @see frocessing.math.FMath
		 * @see frocessing.math.MTRandom
		 */
		public function random( high:Number, low:Number = 0 ):Number{
			return FMath.random( high, low );
		}
		
		/**
		 * @see frocessing.math.FMath
		 * @see frocessing.math.MTRandom
		 */
		public function randomSeed( seed:uint ):void{
			FMath.randomSeed( seed );
		}
		
		/**
		 * note that fallout value greater than 0.5 might result in greater than 1.0 values returned by noise().
		 * @param	lod
		 * @param	falloff
		 * @see		frocessing.math.PerlinNoise
		 */
		public function noiseDetail( lod:uint, falloff:Number = 0):void{
			__perlin_noise.noiseDetail( lod, falloff );
		}
		
		/**
		 * 
		 * @see frocessing.math.PerlinNoise
		 */
		public function noise( x:Number, y:Number = 0.0, z:Number = 0.0 ):Number{
			return __perlin_noise.noise( x, y, z );
		}
		
		/**
		 * 
		 * @see frocessing.math.PerlinNoise
		 */
		public function noiseSeed( seed:uint ):void{
			__perlin_noise.noiseSeed( seed );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// UTILS
		//-------------------------------------------------------------------------------------------------------------------
		
		public static function splitTokens( str:String, tokens:String=" "):Array {
			return FUtil.splitTokens( str, tokens );
		}
		
		public static function trim( str:String ):String {
			return FUtil.trim( str );
		}
		
		/**
		 * 
		 * @param	value
		 * @param	left	left digits
		 * @param	right	right digits
		 * @see frocessing.utils.FUtil
		 */
		public static function nf( value:Number, left:uint, right:uint = 0 ):String{
			return FUtil.nf( value, left, right );
		}
		
		/**
		 * 
		 * @param	value
		 * @param	left	left digits
		 * @param	right	right digits
		 * @see frocessing.utils.FUtil
		 */
		public static function nfs( value:Number, left:uint, right:uint = 0 ):String{
			return FUtil.nfs( value, left, right );
		}
		
		/**
		 * 
		 * @param	value
		 * @param	left	left digits
		 * @param	right	right digits
		 * @see frocessing.utils.FUtil
		 */
		public static function nfp( value:Number, left:uint, right:uint = 0 ):String{
			return FUtil.nfp( value, left, right );
		}
		
		/**
		 * 
		 * @param	value
		 * @param	right	right digits
		 * @see frocessing.utils.FUtil
		 */
		public static function nfc( value:Number, right:uint = 0 ):String{
			return FUtil.nfc( value, right );
		}
		
		//------------------------------------------------
		
		/**
		 * 数字 を 2進数 の文字列に変換します.
		 * @param	value
		 * @param	digits	文字列の桁数
		 * @see frocessing.utils.FUtil
		 */
		public static function binary( value:int, digits:int=0 ):String{
			return FUtil.binary( value, digits );
		}
		
		/**
		 * 2進数の文字列を uint に変換します.
		 * @see frocessing.utils.FUtil
		 */
		public static function unbinary( binstr:String ):uint{
			return FUtil.unbinary( binstr );
		}
		
		/**
		 * 数字 を 16進数 の文字列に変換します.
		 * @param	value
		 * @param	digits	文字列の桁数
		 * @see frocessing.utils.FUtil
		 */
		public static function hex( value:int, digits:int=0 ):String {
			return FUtil.hex( value, digits );
		}
		
		/**
		 * 16進数の文字列を uint に変換します.
		 * @see frocessing.utils.FUtil
		 */
		public static function unhex( hexstr:String ):uint {
			return FUtil.unhex( hexstr );
		}
		
		//------------------------------------------------
		
		/**
		 * 年 (2000 などの 4 桁の数字) をローカル時間で返します.
		 * @see frocessing.utils.FDate
		 */
		public static function year():Number { 		return FDate.year(); }
		
		/**
		 * 月 (1 月は 1、2 月は 2 など) をローカル時間で返します.
		 * @see frocessing.utils.FDate
		 */
		public static function month():Number {		return FDate.month(); }
		
		/**
		 * 日付 (1 ～ 31) をローカル時間で返します.
		 * @see frocessing.utils.FDate
		 */
		public static function day():Number	{		return FDate.day(); }
		
		/**
		 * 曜日 (日曜日は 0、月曜日は 1 など) をローカル時間で返します.
		 * @see frocessing.utils.FDate
		 */
		public static function weekday():Number {	return FDate.weekday(); }
		
		/**
		 * 時 (0 ～ 23) をローカル時間で返します.
		 * @see frocessing.utils.FDate
		 */
		public static function hour():Number { 		return FDate.hour(); }
		
		/**
		 * 分 (0 ～ 59) をローカル時間で返します.
		 * @see frocessing.utils.FDate
		 */
		public static function minute():Number {	return FDate.minute(); }
		
		/**
		 * 秒 (0 ～ 59) をローカル時間で返します.
		 * @see frocessing.utils.FDate
		 */
		public static function second():Number { 	return FDate.second(); }
		
		/**
		 * ミリ秒 (0 ～ 999) をローカル時間で返します.
		 * @see frocessing.utils.FDate
		 */
		public static function millis():Number { 	return FDate.millis(); }
		
		//-------------------------------------------------------------------------------------------------------------------
		// draw method
		//-------------------------------------------------------------------------------------------------------------------
		
		public function lineStyle( thickness:Number = NaN, color:uint = 0, alpha:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String=null, joints:String=null, miterLimit:Number=3 ):void{
			__fg.lineStyle( thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit );
		}
		public function lineGradientStyle( type:String, colors:Array, alphas:Array, ratios:Array,
										   matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb",
										   focalPointRatio:Number=0.0 ):void{
			__fg.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		}
		public function beginFill(color:uint, alpha:Number=1.0):void{
			__fg.beginFill( color, alpha );
		}
		public function beginBitmapFill( bitmap:BitmapData, matrix:Matrix=null, repeat:Boolean=true, smooth:Boolean=false ):void{
			__fg.beginBitmapFill( bitmap, matrix, repeat, smooth );
		}
		public function beginGradientFill(type:String, color:Array, alphas:Array, ratios:Array, matrix:Matrix=null, spreadMethod:String="pad", interpolationMethod:String="rgb",focalPointRatio:Number=0.0):void{
			__fg.beginGradientFill( type, color, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio );
		}
		public function endFill():void{
			__fg.endFill();
		}
		
		/**
		 * @see frocessing.core.F5Draw
		 */
		public function drawCircle(x:Number, y:Number, radius:Number):void {
			__draw_method.drawCircle( x, y, radius );
		}
		/**
		 * @see frocessing.core.F5Draw
		 */
		public function drawEllipse(x:Number, y:Number, width_:Number, height_:Number):void {
			__draw_method.drawEllipse( x, y, width_, height_ );
		}
		/**
		 * @see frocessing.core.F5Draw
		 */
		public function drawRect(x:Number, y:Number, width_:Number, height_:Number):void {
			__draw_method.drawRect( x, y, width_, height_ );
		}
		/**
		 * @see frocessing.core.F5Draw
		 */
		public function drawRoundRect(x:Number, y:Number, width_:Number, height_:Number, ellipseWidth:Number, ellipseHeight:Number):void {
			__draw_method.drawRoundRect( x, y, width_, height_, ellipseWidth, ellipseHeight );
		}
		/**
		 * @see frocessing.core.F5Draw
		 */
		public function drawRoundRectComplex(x:Number, y:Number, width_:Number, height_:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number):void {
			__draw_method.drawRoundRectComplex( x, y, width_, height_, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius );
		}
		/**
		 * @see frocessing.core.F5Draw
		 */
		public function drawTriangle( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number ):void {
			__draw_method.drawTriangle( x0, y0, x1, y1, x2, y2 );
		}
		/**
		 * @see frocessing.core.F5Draw
		 */
		public function drawQuad( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void {
			__draw_method.drawQuad( x0, y0, x1, y1, x2, y2, x3, y3 );
		}
		/**
		 * @see frocessing.core.F5Draw
		 */
		public function drawPolygon( coordinates:Array, close_path:Boolean = true ):void {
			__draw_method.drawPolygon( coordinates, close_path );
		}
		/**
		 * @see frocessing.core.F5Draw
		 */
		public function drawRegPolygon( x:Number, y:Number, vertex_number:uint, radius:Number, rotation:Number = 0.0 ):void {
			__draw_method.drawRegPolygon( x, y, vertex_number, radius, rotation );
		}
		/**
		 * @see frocessing.core.F5Draw
		 */
		public function drawStarPolygon( x:Number, y:Number, vertex_number:uint, radius_out:Number , radius_in:Number, rotation:Number = 0.0 ):void {
			__draw_method.drawStarPolygon( x, y, vertex_number, radius_out, radius_in, rotation );
		}
		/**
		 * @see frocessing.core.F5Draw
		 */
		public function drawArc( x:Number, y:Number, rx:Number, ry:Number, begin:Number, end:Number, rotation:Number = 0 ):void {
			__draw_method.drawArc( x, y, rx, ry, begin, end, rotation );
		}
		/**
		 * @see frocessing.core.F5Draw
		 */
		public function drawPie( x:Number, y:Number, rx:Number, ry:Number, begin:Number, end:Number, rotation:Number = 0 ):void {
			__draw_method.drawPie( x, y, rx, ry, begin, end, rotation );
		}
		/**
		 * @see frocessing.core.F5Draw
		 */
		public function drawQBezier( x0:Number, y0:Number, cx0:Number, cy0:Number, x1:Number, y1:Number ):void {
			__draw_method.drawQBezier( x0, y0, cx0, cy0, x1, y1 );
		}
		/**
		 * @see frocessing.core.F5Draw
		 */
		public function drawBezier( x0:Number, y0:Number, cx0:Number, cy0:Number, cx1:Number, cy1:Number, x1:Number, y1:Number ):void {
			__draw_method.drawBezier( x0, y0, cx0, cy0, cx1, cy1, x1, y1 );
		}
		/**
		 * @see frocessing.core.F5Draw
		 */
		public function drawSpline( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void {
			__draw_method.drawSpline( x0, y0, x1, y1, x2, y2, x3, y3 );
		}
		
		
		//--------------------------------------------------------------------------------------------------- 
		
		public function smooth():void{
			QHigh();
		}
		
		public function noSmooth():void{
			QLow();
		}
		
		/**
		 * StageQuality to LOW.
		 */
		public function QLow():void{
			if ( stage!=null ) stage.quality = StageQuality.LOW;
		}
		
		/**
		 * StageQuality to MEDIUM.
		 */
		public function QMedium():void{
			if ( stage!=null ) stage.quality = StageQuality.MEDIUM;
		}
		
		/**
		 * StageQuality to HIGH.
		 */
		public function QHigh():void{
			if ( stage!=null ) stage.quality = StageQuality.HIGH;
		}
		
		/**
		 * StageQuality to BEST.
		 */
		public function QBest():void{
			if ( stage!=null ) stage.quality = StageQuality.BEST;
		}
	}
}
