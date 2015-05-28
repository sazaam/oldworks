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

package frocessing.core {
	
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	import flash.net.URLLoader;
	import flash.display.Loader;
	import frocessing.bmp.FImageLoader;
	import frocessing.shape.FShapeSVGLoader;
	import frocessing.text.PFontLoader;
	
	import frocessing.geom.FMatrix2D;
	import frocessing.color.FColor;
	import frocessing.shape.IFShape;
	import frocessing.text.IFont;
	
	import frocessing.f5internal;
	use namespace f5internal;
	
	/**
	 * F5Graphics クラスは、Processing の描画メソッドを実装したクラスです.
	 * 
	 * @author nutsu
	 * @version 0.5.8
	 */
	public class F5Graphics 
	{
		// Color Mode
		public static const RGB        :String = F5C.RGB;
		public static const HSB        :String = F5C.HSB;
		public static const HSV        :String = F5C.HSV;
		
		// Rect Ellipse Image Mode
		public static const CORNER        :int = F5C.CORNER;
		public static const CORNERS       :int = F5C.CORNERS;
		public static const RADIUS        :int = F5C.RADIUS;
		
		public static const CENTER        :int = F5C.CENTER;
		
		// text
		public static const LEFT    	  :int = F5C.LEFT;
		public static const RIGHT   	  :int = F5C.RIGHT;
		public static const BASELINE	  :int = F5C.BASELINE;
		public static const TOP     	  :int = F5C.TOP;
		public static const BOTTOM  	  :int = F5C.BOTTOM;
		
		// Vertex Mode
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
		
		// PI
		public static const PI         :Number = Math.PI;
		public static const TWO_PI     :Number = Math.PI*2;
		public static const HALF_PI    :Number = Math.PI/2;
		public static const QUART_PI   :Number = Math.PI/4;
		
		//------------------------------
		/** @private */
		internal var gc:GraphicsEx;
		
		// size -------------------------
		/** @private */
		internal var _width:uint;
		/** @private */
		internal var _height:uint;
		
		// color mode -------------------------
		public var colorModeState:String;
		public var colorModeX:Number;
		public var colorModeY:Number;
		public var colorModeZ:Number;
		public var colorModeA:Number;
		
		// calc -------------------------
		/** @private */
		internal var __calc_color:uint;
		/** @private */
		internal var __calc_alpha:Number;
		
		// Shape Attributes -------------------------
		/** @private */
		internal var _rect_mode:int;		//@default CORNER
		/** @private */
		internal var _ellipse_mode:int;	//@default CENTER
		/** @private */
		internal var _shape_mode:int;	//@default CORNER
		/** @private */
		internal var _vertex_mode:int;	//@default 0
		/** @private */
		internal var _vertex_mode_polygon:Boolean;
		
		// Vertex -------------------------
		/** @private */
		internal var verticesX:Array;
		/** @private */
		internal var verticesY:Array;
		/** @private */
		internal var vertexCount:uint;
		/** @private */
		internal var splineVerticesX:Array;
		/** @private */
		internal var splineVerticesY:Array;
		/** @private */
		internal var splineVertexCount:uint;
		/** @private */
		internal var verticesU:Array;
		/** @private */
		internal var verticesV:Array;
		
		// Image -------------------------
		/** @private */
		internal var _image_mode:int;	//@default CORNER
		/** @private */
		internal var _tint_color:uint;
		/** @private */
		internal var _tint_do :Boolean;
		/** @private */
		internal var tintImageCache:TintCache;
		
		// Texture -------------------------
		/** @private */
		internal var __texture:Boolean;
		/** @private */
		internal var _texture_mode:int;
		/** @private */
		internal var _texture_width:int = 1;
		/** @private */
		internal var _texture_height:int = 1;
		 
		// Style -------------------------
		/** @private */
		internal var _style_tmp:Array;
		
		//Fill Matrix
		/** @private */
		internal var _fill_matrix:FMatrix2D;		
		
		// Typographics -------------------------
		private var __text_gc:F5Typographics;
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 * @param	graphics
		 */
		public function F5Graphics( graphics:Graphics ) 
		{
			__initGC(graphics);
			tintImageCache	= new TintCache();
			__text_gc 		= new F5Typographics( this );
			
			_width = 100;
			_height = 100;
			
			gc.bezierDetail = 20;
			gc.splineDetail = 20;
			gc.splineTightness = 1.0;
			gc.imageSmoothing = false;
			gc.imageDetail	= 4;
			
			__texture = false;
			
			_style_tmp = [];
			defaultSettings();
			
			//
			_fill_matrix = new FMatrix2D();
		}
		
		/*
		public function setGraphics( graphics:Graphics ):void {
			pushStyle();
			gc.gc = graphics;
			popStyle();
		}
		*/
		
		/** @private */
		protected function __initGC( graphics:Graphics ):void
		{
			gc = new GraphicsEx(graphics);
		}
		
		/**
		 * default settings
		 * @private
		 */
		protected function defaultSettings():void
		{
			__calc_color	= 0x000000;
			__calc_alpha	= 1.0;
			
			//mode
			colorModeState	= RGB;
			colorModeX		= colorModeY = colorModeZ = 255;
			colorModeA		= 1.0;
			
			//fill
			gc.fillColor	= 0xffffff;
			gc.fillAlpha	= 1.0;
			gc.fillDo		= true;
			
			//stroke
			gc.strokeColor	= 0x000000;
			gc.strokeAlpha  = 1.0;
			gc.thickness    = 0;
			gc.pixelHinting = false;
			gc.scaleMode    = "normal";
			gc.caps         = null;
			gc.joints       = null;
			gc.miterLimit   = 3;
			
			//shape mode
			_rect_mode		= CORNER;
			_ellipse_mode	= CENTER;
			_texture_mode   = NORMALIZED;
			
			//image
			_image_mode     = CORNER;
			_tint_color		= 0xffffffff;
			_tint_do		= false;
			
			//
			gc.applyStroke();
		}
		
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * F5Graphics が保持する幅を示します.
		 */
		public function get width():uint { return _width; }
		/**
		 * F5Graphics が保持する高さを示します.
		 */
		public function get height():uint{ return _height; }
		
		/**
		 * 幅と高さを設定します.
		 */
		public function size( width_:uint, height_:uint ):void
		{
			_width  = width_;
			_height = height_;
		}
		
		/**
		 * 描画を開始するときに実行します.
		 * beginDraw時、graphics は clear() されます.
		 */
		public function beginDraw():void {
			clear();
		}
		
		/**
		 * 描画を終了するときに実行します.
		 */
		public function endDraw():void { ; }
		
		//-------------------------------------------------------------------------------------------------------------------
		// DRAW
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 描画されているグラフィックをクリアします.
		 */
		public function clear():void
		{
			gc.clear();
			tintImageCache.dispose();
		}
		
		//------------------------------------------------------------------------------------------------------------------- Path
		
		/**
		 * 現在の描画位置を指定座標に移動します.
		 */
		public function moveTo( x:Number, y:Number, z:Number=0 ):void
		{
			gc.moveTo( x, y );
		}
		
		/**
		 * 現在の描画位置から指定座標まで描画します.
		 */
		public function lineTo( x:Number, y:Number, z:Number=0 ):void
		{
			gc.lineTo( x, y );
		}
		
		/**
		 * 指定されたをコントロールポイント(controlX, controlY) を使用し、現在の描画位置から (anchorX, anchorY)まで2次ベジェ曲線を描画します.
		 */
		public function curveTo( controlX:Number, controlY:Number, anchorX:Number, anchorY:Number ):void
		{
			gc.curveTo( controlX, controlY, anchorX, anchorY );
		}
		/** @private */
		internal function _curveTo( cx:Number, cy:Number, cz:Number, x:Number, y:Number, z:Number ):void {
			curveTo( cx, cy, x, y );
		}
		
		/**
		 * 3次ベジェ曲線を描画します.
		 */
		public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			gc.bezierTo( cx0, cy0, cx1, cy1, x, y );
		}
		
		/**
		 * スプライン曲線を描画します.
		 * 
		 * @param	cx0		pre point x
		 * @param	cy0		pre point y
		 * @param	cx1		next point x 
		 * @param	cy1 	next point y
		 * @param	x		target point x
		 * @param	y		target point x
		 */
		public function splineTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			gc.splineTo( cx0, cy0, cx1, cy1, x, y  );
		}
		
		/**
		 * 描画しているシェイプを閉じます.
		 */
		public function closePath():void
		{
			gc.closePath();
		}
		
		
		public function moveToLast():void
		{
			gc.moveToLast();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 現在の位置から指定の円弧を描きます.
		 * 
		 * @param	x			center x
		 * @param	y			center y
		 * @param	rx			radius x
		 * @param	ry			radius y
		 * @param	begin		begin radian
		 * @param	end			end radian
		 * @param	rotation
		 */
		public function arcTo( x:Number, y:Number, rx:Number, ry:Number, begin:Number, end:Number, rotation:Number=0 ):void
		{
			if( rotation==0 )
			{
				lineTo( x + rx*Math.cos(begin), y + ry*Math.sin(begin) );
				__arc( x, y, rx, ry, begin, end, rotation );
			}
			else
			{
				var rc:Number = Math.cos(rotation);
				var rs:Number = Math.sin(rotation);
				var xx:Number = rx*Math.cos(begin);
				var yy:Number = ry*Math.sin(begin);
				lineTo( x + xx*rc - yy*rs, y + xx*rs + yy*rc );
				__arc( x, y, rx, ry, begin, end, rotation );
			}
		}
		
		/**
		 * 始点と終点を指定して円弧を描画します.
		 * 
		 * <p>
		 * 始点と終点を指定した円弧には、通常4つの描画候補があります.描画する円弧は、<code>large_arg_flg</code>、<code>sweep_flag</code>により指定されます.
		 * <p>
		 * 
		 * @param	x0					start x
		 * @param	y0					start y
		 * @param	x					end x
		 * @param	y					end y
		 * @param	rx					radius x
		 * @param	ry					radius y
		 * @param	large_arc_flag		大きい方の円弧を描画するかを指定します
		 * @param	sweep_flag			円弧の描画方向の正負を指定します
		 * @param	x_axis_rotation		rotation of ellipse(radian)
		 */
		public function arcCurve( x0:Number, y0:Number, x:Number, y:Number, rx:Number, ry:Number, large_arc_flag:Boolean = false, sweep_flag:Boolean = true, x_axis_rotation:Number = 0 ):void
		{
			moveTo( x0, y0 );
			__arcCurve( x0, y0, x, y, rx, ry, large_arc_flag, sweep_flag, x_axis_rotation );
		}
		
		/**
		 * @private
		 */
		public function arcCurveTo( x0:Number, y0:Number, x:Number, y:Number, rx:Number, ry:Number, large_arc_flag:Boolean = false, sweep_flag:Boolean = true, x_axis_rotation:Number = 0 ):void
		{
			__arcCurve( x0, y0, x, y, rx, ry, large_arc_flag, sweep_flag, x_axis_rotation );
		}
		
		/**
		 * @private
		 */
		internal function __drawArc( x:Number, y:Number, rx:Number, ry:Number, begin:Number, end:Number, rotation:Number=0 ):void
		{
			if( rotation==0 )
			{
				moveTo( x + rx*Math.cos(begin), y + ry*Math.sin(begin) );
				__arc( x, y, rx, ry, begin, end );
			}
			else
			{
				var rc:Number = Math.cos(rotation);
				var rs:Number = Math.sin(rotation);
				var xx:Number = rx*Math.cos(begin);
				var yy:Number = ry*Math.sin(begin);
				moveTo( x + xx*rc - yy*rs, y + xx*rs + yy*rc );
				__arc( x, y, rx, ry, begin, end, rotation );
			}
		}
		
		/**
		 * @private
		 */
		internal function __arc( x:Number, y:Number, rx:Number, ry:Number, begin:Number, end:Number, rotation:Number=0 ):void
		{
			var segmentNum:int = Math.ceil( Math.abs( 4*(end-begin)/PI ) );
			var delta:Number   = (end - begin)/segmentNum;
			var ca:Number      = 1.0/Math.cos( delta*0.5 );
			var t:Number       = begin;
			var ctrl_t:Number  = begin - delta*0.5;
			var i:int;
			
			if( rotation==0 )
			{
				for( i=1 ; i<=segmentNum ; i++ )
				{
					t += delta;
					ctrl_t += delta;
					curveTo( x + rx*ca*Math.cos(ctrl_t), y + ry*ca*Math.sin(ctrl_t), x + rx*Math.cos(t), y + ry*Math.sin(t) );
				}
			}
			else
			{
				var rc:Number = Math.cos(rotation);
				var rs:Number = Math.sin(rotation);
				var xx:Number;
				var yy:Number;
				var cxx:Number;
				var cyy:Number;
				for( i=1 ; i<=segmentNum ; i++ )
				{
					t += delta;
					ctrl_t += delta;
					xx  = rx*Math.cos(t);
					yy  = ry*Math.sin(t);
					cxx = rx*ca*Math.cos(ctrl_t);
					cyy = ry*ca*Math.sin(ctrl_t);
					curveTo( x + cxx*rc - cyy*rs, y + cxx*rs + cyy*rc , x + xx*rc - yy*rs, y + xx*rs + yy*rc );
				}
			}
		}
		
		/**
		 * @private
		 */
		internal function __arcCurve( x0:Number, y0:Number, x1:Number, y1:Number, rx:Number, ry:Number, large_arc_flag:Boolean = false, sweep_flag:Boolean = true, x_axis_rotation:Number = 0 ):void
		{
			var d:Number;
			var m:Number;
			//center coordinate
			var cx:Number;
			var cy:Number;
			//begin radian
			var ba:Number;
			//draw radian
			var ra:Number;
			if ( rx != ry ) {
				//ellipse
				var c:Number = Math.cos( -x_axis_rotation );
				var s:Number = Math.sin( -x_axis_rotation );
				var k:Number = rx / ry;
				var tx0:Number = x0 * c - y0 * s;
				var ty0:Number = k * ( x0 * s + y0 * c );
				var tx1:Number = x1 * c - y1 * s;
				var ty1:Number = k * ( x1 * s + y1 * c );
				d = (tx1 - tx0) * (tx1 - tx0) + (ty1 - ty0) * (ty1 - ty0);
				m = (( large_arc_flag==sweep_flag ) ? 1 : -1 )* Math.sqrt( rx * rx/d - 0.25 );
				d = 0.5 * Math.sqrt(d) / rx;
				if ( d < 1 ) {
					cx = (tx0 + tx1)*0.5 + (ty1 - ty0) * m;
					cy = (ty0 + ty1)*0.5 - (tx1 - tx0) * m;
					ba = Math.atan2( ty0 - cy, tx0 - cx );
					ra = ( large_arc_flag ) ? 2 * (Math.PI - Math.asin( d )) : 2 * Math.asin( d );
					__arc( cx * c + cy * s / k, -cx * s + cy * c / k, rx, ry, ba, (sweep_flag) ? ba + ra : ba - ra, x_axis_rotation );
				}else {
					cx = (tx0 + tx1)*0.5;
					cy = (ty0 + ty1)*0.5;
					ba = Math.atan2( ty0 - cy, tx0 - cx );
					rx *= d;
					ry *= d;
					__arc( cx * c + cy * s / k, -cx * s + cy * c / k, rx, ry, ba, (sweep_flag) ? ba + Math.PI : ba - Math.PI, x_axis_rotation );
				}
			}else {
				//circle
				d = (x1 - x0) * (x1 - x0) + (y1 - y0) * (y1 - y0);
				m = (( large_arc_flag == sweep_flag ) ? 1 : -1 ) * Math.sqrt( rx * rx / d - 0.25 );
				d = 0.5 * Math.sqrt(d) / rx;
				if ( d < 1 ) {
					cx = (x0 + x1)*0.5 + (y1 - y0) * m;
					cy = (y0 + y1)*0.5 - (x1 - x0) * m;
					ba = Math.atan2( y0 - cy, x0 - cx );
					ra = (large_arc_flag) ? 2 * (Math.PI - Math.asin( d )) : 2 * Math.asin( d );
					__arc( cx, cy, rx, ry, ba, (sweep_flag) ? ba + ra : ba - ra, 0 );
				} else {
					rx *= d;
					cx = (x0 + x1)*0.5;
					cy = (y0 + y1)*0.5;
					ba = Math.atan2( y0 - cy, x0 - cx );
					__arc( cx, cy, rx, rx, ba, (sweep_flag) ? ba + Math.PI : ba - Math.PI, 0 );
				}
			}
			/*
			var e:Number  = rx/ry;
			var dx:Number = (x - x0)*0.5;
			var dy:Number = (y - y0)*0.5;
			var mx:Number = x0 + dx;
			var my:Number = y0 + dy;
			var rc:Number;
			var rs:Number;
			
			if( x_axis_rotation!=0 )
			{
				rc = Math.cos(-x_axis_rotation);
				rs = Math.sin( -x_axis_rotation);
				var dx_tmp:Number = dx*rc - dy*rs; 
				var dy_tmp:Number = dx*rs + dy*rc;
				dx = dx_tmp;
				dy = dy_tmp;
			}
			
			//transform to circle
			dy *= e;
			
			//
			var len:Number = Math.sqrt( dx*dx + dy*dy );
			var begin:Number;
			
			if( len<rx )
			{
				//center coordinates the arc
				var a:Number  = ( large_arc_flag!=sweep_flag ) ? Math.acos( len/rx ) : -Math.acos( len/rx );
				var ca:Number = Math.tan( a );
				var cx:Number = -dy*ca;
				var cy:Number = dx*ca;
				
				//draw angle
				var mr:Number = Math.PI - 2 * a;
				
				//start angle
				begin = Math.atan2( -dy - cy, -dx - cx );
				
				//deformation back and draw
				cy /= e;
				rc  = Math.cos(x_axis_rotation);
				rs  = Math.sin(x_axis_rotation);
				__arc( mx + cx*rc - cy*rs, my + cx*rs + cy*rc, rx, ry, begin, (sweep_flag) ? begin+mr : begin-(2*Math.PI-mr), x_axis_rotation );
			}
			else
			{
				//half arc
				rx = len;
				ry = rx/e;
				begin = Math.atan2( -dy, -dx );
				__arc( mx, my, rx, ry, begin, (sweep_flag) ? begin+Math.PI : begin-Math.PI, x_axis_rotation );
			}
			*/
		}
		
		/**
		 * @private
		 */
		f5internal function __ellipse( x:Number, y:Number, rx:Number, ry:Number ):void
		{
			var _P:Number = 0.7071067811865476;    //Math.cos( Math.PI / 4 )
			var _T:Number = 0.41421356237309503;   //Math.tan( Math.PI / 8 )
			moveTo( x + rx, y );
			curveTo( x + rx     , y + ry * _T, x + rx * _P, y + ry * _P );
			curveTo( x + rx * _T, y + ry     , x          , y + ry );
			curveTo( x - rx * _T, y + ry     , x - rx * _P, y + ry * _P );
			curveTo( x - rx     , y + ry * _T, x - rx     , y );
			curveTo( x - rx     , y - ry * _T, x - rx * _P, y - ry * _P );
			curveTo( x - rx * _T, y - ry     , x          , y - ry );
			curveTo( x + rx * _T, y - ry     , x + rx * _P, y - ry * _P );
			curveTo( x + rx     , y - ry * _T, x + rx     , y );
		}
		
		/**
		 * @private
		 */
		f5internal function __rect( x0:Number, y0:Number, x1:Number, y1:Number ):void
		{
			moveTo( x0, y0 );
			lineTo( x1, y0 );
			lineTo( x1, y1 );
			lineTo( x0, y1 );
			closePath();
		}
		
		/**
		 * @private
		 */
		f5internal function __roundrect( x0:Number, y0:Number, x1:Number, y1:Number, rx:Number, ry:Number ):void
		{
			var _P:Number = 1 - 0.7071067811865476;    //Math.cos( Math.PI / 4 )
			var _T:Number = 1 - 0.41421356237309503;   //Math.tan( Math.PI / 8 )
			moveTo( x0 + rx, y0 );
			lineTo( x1 - rx, y0 );  curveTo( x1 - rx * _T, y0          , x1 - rx * _P, y0 + ry * _P );
									curveTo( x1          , y0 + ry * _T, x1          , y0 + ry );
			lineTo( x1, y1 - ry );	curveTo( x1          , y1 - ry * _T, x1 - rx * _P, y1 - ry * _P );
									curveTo( x1 - rx * _T, y1          , x1 - rx     , y1 );
			lineTo( x0 + rx, y1 );	curveTo( x0 + rx * _T, y1          , x0 + rx * _P, y1 - ry * _P );
									curveTo( x0          , y1 - ry * _T, x0          , y1 - ry );
			lineTo( x0, y0 + ry );	curveTo( x0          , y0 + ry * _T, x0 + rx * _P, y0 + ry * _P );
									curveTo( x0 + rx * _T, y0          , x0 + rx     , y0 );
		}
		
		//------------------------------------------------------------------------------------------------------------------- 2D Primitives
		
		/**
		 * 点を描画します.点を描画する色は、線の色が適用されます.
		 */
		public function point( x:Number, y:Number, z:Number=0 ):void
		{
			gc.point( x, y );
		}
		
		/**
		 * 現在の線のスタイルを適用し、直線を描画します.
		 */
		public function line( x0:Number, y0:Number, x1:Number, y1:Number ):void
		{
			moveTo( x0, y0 );
			lineTo( x1, y1 );
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、三角形を描画します.
		 */
		public function triangle( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number ):void
		{
			gc.applyFill();
			moveTo( x0, y0 );
			lineTo( x1, y1 );
			lineTo( x2, y2 );
			closePath();
			gc.endFill();
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、四角形を描画します.
		 */
		public function quad( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void
		{
			gc.applyFill();
			moveTo( x0, y0 );
			lineTo( x1, y1 );
			lineTo( x2, y2 );
			lineTo( x3, y3 );
			closePath();
			gc.endFill();
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、円弧を描画します.
		 */
		public function arc( x:Number, y:Number, width_:Number, height_:Number, start_radian:Number, stop_radian:Number ):void
		{
			width_ *= 0.5;
			height_ *= 0.5;
			if ( gc.fillDo )
			{
				gc.applyFill();
				moveTo( x, y );
				lineTo( x + width_*Math.cos(start_radian), y + height_*Math.sin(start_radian) );
				__arc( x, y, width_, height_, start_radian, stop_radian );
				gc.endFill();
			}
			else
			{
				moveTo( x + width_*Math.cos(start_radian), y + height_*Math.sin(start_radian) );
				__arc( x, y, width_, height_, start_radian, stop_radian );
			}
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、円を描画します.
		 */
		public function circle( x:Number, y:Number, radius:Number ):void
		{
			gc.applyFill();
			__ellipse( x, y, radius, radius );
			gc.endFill();
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、楕円を描画します.
		 * 
		 * <p>
		 * ellipse()メソッドの引数は、ellipseMode() で指定したモードによりその意味が異なります. モードと引数の関係は以下のようになります.<br/>
		 * デフォルトのモードは、<code>CENTER</code>です.
		 * </p>
		 * 
		 * <ul>
		 * <li>mode CENTER  : ellipse( center x, center y, width, height )</li>
		 * <li>mode CORNERS ： ellipse( left, top, right, bottom )</li>
		 * <li>mode CORNER  : ellipse( left, top, width, height )</li>
		 * <li>mode RADIUS  : ellipse( center x, center y, radius x, radius y )</li>
		 * </ul>
		 */
		public function ellipse( x0:Number, y0:Number, x1:Number, y1:Number ):void
		{
			var w:Number;
			var h:Number;
			if ( _ellipse_mode == CENTER )
			{
				w  = x1*0.5;
				h  = y1*0.5;
			}
			else if ( _ellipse_mode == CORNER )
			{
				w  = x1*0.5;
				h  = y1*0.5;
				x0 += w;
				y0 += h;
			}
			else if ( _ellipse_mode == CORNERS )
			{
				w  = (x1 - x0)*0.5;
				h  = (y1 - y0)*0.5;
				x0 += w;
				y0 += h;
			}
			else //RADIUS
			{
				w  = x1;
				h  = y1;
			}
			gc.applyFill();
			__ellipse( x0, y0, w, h );
			gc.endFill();
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、矩形を描画します.
		 * 
		 * <p>
		 * rect()メソッドの引数は、rectMode() で指定したモードによりその意味が異なります. モードと引数の関係は以下のようになります.<br/>
		 * デフォルトのモードは、<code>CORNER</code>です.
		 * </p>
		 * 
		 * <ul>
		 * <li>mode CORNER  : rect( left, top, width, height )</li>
		 * <li>mode CORNERS ： rect( left, top, right, bottom )</li>
		 * <li>mode RADIUS  : rect( center x, center y, radius x, radius y )</li>
		 * <li>mode CENTER  : rect( center x, center y, width, height )</li>
		 * </ul>
		 */
		public function rect( x0:Number, y0:Number, x1:Number, y1:Number, rx:Number=0, ry:Number=0 ):void
		{
			var hw:Number;
			var hh:Number;
			if ( _rect_mode == CENTER )
			{
				hw = x1*0.5;
				hh = y1*0.5;
				x1 = x0 + hw;
				y1 = y0 + hh;
				x0 -= hw;
				y0 -= hh;
			}
			else if ( _rect_mode == CORNER )
			{
				x1 += x0;
				y1 += y0;
			}
			else if ( _rect_mode == CORNERS )
			{
				hw = (x1 - x0) * 0.5;
				hh = (y1 - y0) * 0.5;
			}
			else //RADIUS
			{
				hw = x1;
				hh = y1;
				x1 = x0 + hw;
				y1 = y0 + hh;
				x0 -= hw;
				y0 -= hh;
			}
			gc.applyFill();
			if ( rx > 0 && ry > 0 )
				__roundrect( x0, y0, x1, y1, ( rx > hw ) ? hw:rx, ( ry > hh ) ? hh:ry );
			else
				__rect( x0, y0, x1, y1 );
			gc.endFill();
		}
		
		//------------------------------------------------------------------------------------------------------------------- Curves
		
		/**
		 * 現在の塗りと線のスタイルを適用し、3次ベジェ曲線を描画します.
		 */
		public function bezier( x0:Number, y0:Number, cx0:Number, cy0:Number, cx1:Number, cy1:Number, x1:Number, y1:Number ):void
		{
			gc.applyFill();
			moveTo( x0, y0 );
			bezierTo( cx0, cy0, cx1, cy1, x1, y1 );
			gc.endFill();
		}
		
		/**
		 * 現在の塗りと線のスタイルを適用し、スプライン曲線を描画します.
		 */
		public function curve( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void
		{
			gc.applyFill();
			moveTo( x1, y1 );
			splineTo( x0, y0, x3, y3, x2, y2 );
			gc.endFill();
		}
		
		/**
		 * 3次ベジェ曲線を描画する際の精度を指定します.デフォルト値は 20 です.
		 * @param	detail_step	指定された数の直線で曲線を近似します
		 */
		public function bezierDetail( detail_step:uint ):void
		{
			gc.bezierDetail = detail_step;
		}
		
		/**
		 * スプライン曲線を描画する際の精度を指定します.デフォルト値は 20 です.
		 * @param	detail_step	指定された数の直線で曲線を近似します
		 */
		public function curveDetail( detail_step:uint ):void
		{
			gc.splineDetail = detail_step;
		}
		
		/**
		 * スプライン曲線の曲率を指定します.デフォルト値は 1.0 です.
		 */
		public function curveTightness( tightness:Number ):void
		{
			gc.splineTightness = tightness;
		}
		/** @private */
		f5internal function get splineTightness():Number { return gc.splineTightness; }
		
		//------------------------------------------------------------------------------------------------------------------- Vertex
		
		/**
		 * @param	mode	 POINTS, LINES, TRIANGLES, TRIANGLE_FAN, TRIANGLE_STRIP, QUADS, QUAD_STRIP
		 */
		public function beginShape( mode:int=0 ):void
		{
			_vertex_mode    = mode;
			verticesX      = [];
			verticesY      = [];
			splineVerticesX = [];
			splineVerticesY = [];
			verticesU      = [];
			verticesV      = [];
			
			vertexCount = 0;
			splineVertexCount = 0;
			
			if ( _vertex_mode_polygon = (mode == 0) )
			{
				gc.applyFill();
			}
		}
		
		/**
		 * 
		 */
		public function endShape( close_path:Boolean=false ):void
		{
			if ( _vertex_mode_polygon )
			{
				if ( close_path )
					gc.closePath();
				gc.endFill();
				_vertex_mode_polygon = false;
			}
			if ( __texture )
			{
				__texture = false;
				gc.endBitmap();
			}
			vertexCount       = 0;
			splineVertexCount = 0;
			_vertex_mode      = 0;
		}
		
		/**
		 * vertex() で 描画する テクスチャ(画像) を設定します.
		 * <p>
		 * texture が適用されるのは、 beginShape() メソッドで以下のモードを指定した場合になります.<br/>
		 * 「　TRIANGLES　TRIANGLE_FAN　TRIANGLE_STRIP　QUADS　QUAD_STRIP 」
		 * </p>
		 * <p>
		 * vertex() メソッドで、　u, v 値を指定する必要があります.
		 * </p>
		 */
		public function texture( textureData:BitmapData ):void
		{
			if ( _tint_do )
				gc.beginBitmap( tintImageCache.getTintImage( textureData, _tint_color ) );
			else
				gc.beginBitmap( textureData );
			__texture = true;
			_texture_width  = textureData.width;
			_texture_height = textureData.height;
		}
		
		/**
		 * @param	mode	NORMALIZED, IMAGE
		 */
		public function textureMode( mode:int ):void
		{
			_texture_mode = mode;
		}
		
		/**
		 * 
		 * @param	x
		 * @param	y
		 * @param	u	texture を指定している場合、u 値を画像の x 座標で指定できます
		 * @param	v	texture を指定している場合、v 値を画像の y 座標で指定できます
		 */
		public function vertex( x:Number, y:Number, u:Number=0, v:Number=0 ):void
		{
			verticesX[vertexCount] = x;
			verticesY[vertexCount] = y;
			if ( _texture_mode < 1 )
			{
				u /= _texture_width;
				v /= _texture_height;
			}
			verticesU[vertexCount] = u;
			verticesV[vertexCount] = v;
			vertexCount++;
			
			var t1:uint;
			var t2:uint;
			var t3:uint;
			
			switch( _vertex_mode )
			{
				case POINTS:
					gc.point( x, y );
					break;
				case LINES:
					if ( vertexCount % 2 == 0 )
					{
						t1 = vertexCount - 2;
						gc.moveTo( verticesX[t1], verticesY[t1] );
						gc.lineTo( x, y );
					}
					break;
				case TRIANGLES:
					if ( vertexCount % 3 == 0 )
					{
						t1 = vertexCount - 2;
						t2 = vertexCount - 3;
						if ( __texture )
						{
							gc.drawBitmapTriangle( verticesX[t2], verticesY[t2], verticesX[t1], verticesY[t1], x, y,
												   verticesU[t2], verticesV[t2], verticesU[t1], verticesV[t1], u, v );
						}
						else
						{
							__vertexTriangle( verticesX[t2], verticesY[t2], verticesX[t1], verticesY[t1], x, y );
						}
					}
					break;
				case TRIANGLE_FAN:
					if ( vertexCount >= 3 )
					{
						t1 = vertexCount - 2;
						if ( __texture )
						{
							gc.drawBitmapTriangle( verticesX[0], verticesY[0], verticesX[t1], verticesY[t1], x, y,
												   verticesU[0], verticesV[0], verticesU[t1], verticesV[t1], u, v );
						}
						else
						{
							__vertexTriangle( verticesX[0], verticesY[0], verticesX[t1], verticesY[t1], x, y );
						}
					}
					break;
				case TRIANGLE_STRIP:
					if ( vertexCount >= 3 )
					{
						t1 = vertexCount - 2;
						t2 = vertexCount - 3;
						if ( __texture )
						{
							gc.drawBitmapTriangle( x, y, verticesX[t1], verticesY[t1], verticesX[t2], verticesY[t2],
												   u, v, verticesU[t1], verticesV[t1], verticesU[t2], verticesV[t2] );
						}
						else
						{
							__vertexTriangle( x, y, verticesX[t1], verticesY[t1], verticesX[t2], verticesY[t2] );
						}
					}
					break;
				case QUADS:
					if ( vertexCount % 4 == 0 )
					{
						t1 = vertexCount - 2;
						t2 = vertexCount - 3;
						t3 = vertexCount - 4;
						if ( __texture )
						{
							__vertexBitmapQuad( verticesX[t3], verticesY[t3], verticesX[t2], verticesY[t2], verticesX[t1], verticesY[t1], x, y,
											    verticesU[t3], verticesV[t3], verticesU[t2], verticesV[t2], verticesU[t1], verticesV[t1], u, v );
						}
						else
						{
							__vertexQuad( verticesX[t3], verticesY[t3], verticesX[t2], verticesY[t2], verticesX[t1], verticesY[t1], x, y );
						}
					}
					break;
				case QUAD_STRIP:
					if ( vertexCount >= 4 && vertexCount % 2 == 0 )
					{
						t1 = vertexCount - 2;
						t2 = vertexCount - 3;
						t3 = vertexCount - 4;
						if ( __texture )
						{
							__vertexBitmapQuad( verticesX[t3], verticesY[t3], verticesX[t2], verticesY[t2], x, y, verticesX[t1], verticesY[t1],
											    verticesU[t3], verticesV[t3], verticesU[t2], verticesV[t2], u, v, verticesU[t1], verticesV[t1] );
						}
						else
						{
							__vertexQuad( verticesX[t3], verticesY[t3], verticesX[t2], verticesY[t2], x, y, verticesX[t1], verticesY[t1] );
						}
					}
					break;
				default:
					if ( vertexCount == 1 && splineVertexCount < 4 )
						gc.moveTo( x, y );
					else
						gc.lineTo( x, y );
					break;
			}
			splineVertexCount = 0;
		}
		
		private function __vertexBitmapQuad( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number,
											 u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number, u3:Number, v3:Number ):void
		{
			gc.abortStroke();
			gc.drawBitmapQuad( x0, y0, x1, y1, x2, y2, x3, y3, u0, v0, u1, v1, u2, v2, u3, v3 );
			if ( gc.resumeStroke() )
			{
				gc.moveTo( x0, y0 );
				gc.lineTo( x1, y1 );
				gc.lineTo( x2, y2 );
				gc.lineTo( x3, y3 );
				gc.closePath();
			}
		}
		private function __vertexQuad( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void
		{
			gc.applyFill();
			gc.moveTo( x0, y0 );
			gc.lineTo( x1, y1 );
			gc.lineTo( x2, y2 );
			gc.lineTo( x3, y3 );
			gc.closePath();
			gc.endFill();
		}
		private function __vertexTriangle( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number ):void
		{
			gc.applyFill();
			gc.moveTo( x0, y0 );
			gc.lineTo( x1, y1 );
			gc.lineTo( x2, y2 );
			gc.closePath();
			gc.endFill();
		}
		
		/**
		 * 　
		 */
		public function bezierVertex( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			if ( _vertex_mode_polygon )
			{
				verticesX[vertexCount] = x;
				verticesY[vertexCount] = y;
				vertexCount++;
				splineVertexCount = 0;
				gc.bezierTo( cx0, cy0, cx1, cy1, x, y );
			}
		}
		
		/**
		 *　
		 */
		public function curveVertex( x:Number, y:Number ):void
		{
			if ( _vertex_mode_polygon )
			{
				splineVerticesX[splineVertexCount] = x;
				splineVerticesY[splineVertexCount] = y;
				splineVertexCount ++;
				
				var t1:int = splineVertexCount - 2;
				var t3:int = splineVertexCount - 4;
				
				if( splineVertexCount>4 )
				{
					gc.splineTo( splineVerticesX[t3], splineVerticesY[t3],
								 x, y,
								 splineVerticesX[t1], splineVerticesY[t1] );
				}
				else if ( splineVertexCount == 4 )
				{
					var t2:int = splineVertexCount - 3;
					if ( vertexCount > 0 )
					{
						gc.splineTo( splineVerticesX[t3], splineVerticesY[t3],
									 x, y,
									 splineVerticesX[t1], splineVerticesY[t1] );
					}
					else
					{
						gc.moveTo(splineVerticesX[t2], splineVerticesY[t2]);
						gc.splineTo( splineVerticesX[t3], splineVerticesY[t3],
									 x, y,
									 splineVerticesX[t1], splineVerticesY[t1] );
					}
				}
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// SHAPE
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 * paratmeters(x,y,w,h) is applyed in F5Graphics2D or F5Graphics3D
		 */
		public function shape( s:IFShape, x:Number=0, y:Number=0, w:Number = NaN, h:Number = NaN ):void
		{
			s.draw(this);
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// IMAGE
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 画像を描画します.
		 * 
		 * <p>
		 * image()メソッドの引数は、imageMode() で指定したモードによりその意味が異なります. モードと引数の関係は以下のようになります.<br/>
		 * デフォルトのモードは、<code>CORNER</code>です.
		 * </p>
		 * 
		 * <ul>
		 * <li>mode CORNER  : image( left, top, width, height )</li>
		 * <li>mode CORNERS ： image( left, top, right, bottom )</li>
		 * <li>mode CENTER  : image( center x, center y, width, height )</li>
		 * </ul>
		 * 
		 * <p>w、h を省略した場合は、bitmapdata の width と hight が適用されます.</p>
		 */
		public function image( img:BitmapData, x:Number, y:Number, w:Number = NaN, h:Number = NaN ):void
		{
			if ( w>0 && h>0 )
			{
				if ( _image_mode == CENTER )
				{
					x -= w * 0.5;
					y -= h * 0.5;
				}
				else if ( _image_mode == CORNERS )
				{
					w  -= x;
					h  -= y;
				}
				else if ( _image_mode == RADIUS )
				{
					x -= w;
					y -= h;
					w *= 2;
					h *= 2;
				}
			}
			else
			{
				w = img.width;
				h = img.height;
				if( _image_mode==CENTER || _image_mode==RADIUS )
				{
					x -= w * 0.5;
					y -= h * 0.5;
				}
			}
			_image( img, x, y, w, h );
		}
		
		/**
		 * @private
		 */
		f5internal function _image( img:BitmapData, x:Number, y:Number, w:Number, h:Number, z:Number=0 ):void
		{
			if ( _tint_do )
				gc.beginBitmap( tintImageCache.getTintImage( img, _tint_color ) );
			else
				gc.beginBitmap( img );
			
			gc.drawBitmap( x, y, w, h );
			gc.endBitmap();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// TEXT
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 描画する font を指定します.
		 * @param	font
		 * @param	fontSize
		 * @param	detail	font image detail
		 */
		public function textFont( font:IFont, fontSize:Number = NaN ):void
		{
			__text_gc.textFont( font, fontSize );
		}
		
		/**
		 * text を描画します.
		 * 
		 * <p>引数の数により色の指定が異なります.</p>
		 * <listing>text( string, x, y )</listing>
		 * <listing>text( string, x, y, z ) when 3D</listing>
		 * <listing>text( string, x, y, width, height )</listing>
		 * <listing>text( string, x, y, width, height, z ) when 3D</listing>
		 */
		public function text( str:String, a:Number, b:Number, c:Number=0, d:Number=0, e:Number=0 ):void
		{
			__text_gc.color = uint( gc.fillAlpha * 0xff ) << 24 | gc.fillColor;
			if ( c > 0 && d > 0 )
				__text_gc.textArea( str, a, b, c, d, e );
			else
				__text_gc.text( str, a, b, c );
		}
		
		/**
		 * 
		 */
		public function textAscent():Number
		{
			return __text_gc.textAscent();
		}
		
		/**
		 * 
		 */
		public function textDescent():Number
		{
			return __text_gc.textDescent();
		}
		
		/**
		 * 文字列の幅を取得します.
		 */
		public function textWidth( str:String ):Number
		{
			return __text_gc.textWidth( str );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// STYLE
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 現在のスタイルを保持します.
		 * <p>pushStyle() で保持したスタイルは popStyle() で戻されます.</p>
		 * <p>保持されるスタイル</p>
		 * <ul>
		 * <li>colorMode</li>
		 * <li>fill</li>
		 * <li>stroke</li>
		 * <li>stroke attributes(weight,caps,joints...)</li>
		 * <li>rectMode</li>
		 * <li>ellipseMode</li>
		 * <li>imageMode</li>
		 * <li>textFont</li>
		 * <li>textAlign</li>
		 * <li>textSize</li>
		 * <li>textSize</li>
		 * <li>textLeading</li>
		 * <li>tint</li>
		 * </ul>
		 * 
		 * @see frocessing.core.F5Style
		 */
		public function pushStyle():void
		{
			var s:F5Style = new F5Style();
			
			s.colorMode 	= colorModeState;
			s.colorModeX 	= colorModeX;
			s.colorModeY 	= colorModeY;
			s.colorModeZ 	= colorModeZ;
			s.colorModeA 	= colorModeA;
			
			s.fillDo 		= gc.fillDo;
			s.fillColor 	= gc.fillColor;
			s.fillAlpha 	= gc.fillAlpha;
			
			s.strokeDo	  	= gc.__stroke;
			s.strokeColor 	= gc.strokeColor;
			s.strokeAlpha 	= gc.strokeAlpha;
			s.thickness 	= gc.thickness;
			s.pixelHinting 	= gc.pixelHinting;
			s.scaleMode 	= gc.scaleMode;
			s.caps 			= gc.caps;
			s.joints 		= gc.joints;
			s.miterLimit 	= gc.miterLimit;
			
			s.rectMode 		= _rect_mode;
			s.ellipseMode 	= _ellipse_mode;
			s.imageMode 	= _image_mode;
			s.shapeMode		= _shape_mode;
			
			s.tintDo 		= _tint_do ;
			s.tintColor 	= _tint_color;
			
			s.textFont		= __text_gc.font;
			s.textAlign 	= __text_gc.align;
			s.textAlignY 	= __text_gc.alignY;
			s.textSize 		= __text_gc.size;
			s.textLeading 	= __text_gc.leading;
			
			_style_tmp.push( s );
		}
		
		/**
		 * pushStyle()で保持されたスタイルに復帰します.
		 * @see frocessing.core.F5Style
		 */
		public function popStyle():void
		{
			var s:F5Style = F5Style( _style_tmp.pop() );
			colorModeState	= s.colorMode;
			colorModeX		= s.colorModeX;
			colorModeY		= s.colorModeY;
			colorModeZ 		= s.colorModeZ;
			colorModeA		= s.colorModeA;
			
			gc.fillDo		= s.fillDo;
			gc.fillColor	= s.fillColor;
			gc.fillAlpha	= s.fillAlpha;
			
			gc.strokeColor	= s.strokeColor;
			gc.strokeAlpha  = s.strokeAlpha;
			gc.thickness    = s.thickness;
			gc.pixelHinting = s.pixelHinting;
			gc.scaleMode    = s.scaleMode;
			gc.caps         = s.caps;
			gc.joints       = s.joints;
			gc.miterLimit   = s.miterLimit;
			
			_rect_mode		= s.rectMode;
			_ellipse_mode	= s.ellipseMode;
			_image_mode     = s.imageMode;
			_shape_mode		= s.shapeMode;
			_tint_color		= s.tintColor;
			_tint_do		= s.tintDo;
			
			__text_gc.textFont( s.textFont, s.textSize );
			__text_gc.align	  = s.textAlign;
			__text_gc.alignY  = s.textAlignY;
			__text_gc.leading = s.textLeading;
			
			if ( s.strokeDo )
				gc.applyStroke();
			else
				gc.noStroke();
		}
		
		//------------------------------------------------------------------------------------------------------------------- Shape
		
		/**
		 * @param	mode 	CORNER | CORNERS | RADIUS | CENTER
		 */
		public function rectMode( mode:int ):void
		{
			_rect_mode = mode;
		}
		
		/**
		 * @param	mode 	CORNER | CORNERS | RADIUS | CENTER
		 */
		public function ellipseMode( mode:int ):void
		{
			_ellipse_mode = mode;
		}
		
		/**
		 *  @param	mode 	CORNER | CORNERS | CENTER
		 */
		public function imageMode( mode:int ):void
		{
			_image_mode = mode;
		}
		
		/**
		 *  @param	mode 	CORNER | CORNERS | CENTER
		 */
		public function shapeMode( mode:int ):void
		{
			_shape_mode = mode;
		}
		
		/**
		 * 画像を描画する場合の Smoothing を設定します.
		 */
		public function imageSmoothing( smooth:Boolean ):void
		{
			gc.imageSmoothing = smooth;
		}
		
		/**
		 * 画像を変形して描画する際の精度を指定します.
		 */
		public function imageDetail( segmentNumber:uint ):void
		{
			gc.imageDetail = segmentNumber;
		}
		
		//------------------------------------------------------------------------------------------------------------------- Text
		
		/**
		 * text の　size を指定します.
		 * @param	fontSize
		 */
		public function textSize( fontSize:Number ):void
		{
			__text_gc.size = fontSize;
		}
		
		/**
		 * text の align を指定します.
		 * @param	align	CENTER,LEFT,RIGHT
		 * @param	alignY	BASELINE,TOP,BOTTOM
		 */
		public function textAlign( align:int, alignY:int = 0 ):void
		{
			__text_gc.align  = align;
			__text_gc.alignY = alignY;
		}
		
		/**
		 * text の　行高 を指定します.
		 */
		public function textLeading( leading:Number ):void
		{
			__text_gc.leading = leading;
		}
		
		/**
		 * not implemented
		 */
		public function textMode( mode:int ):void
		{
			;
		}
		
		//------------------------------------------------------------------------------------------------------------------- BACKGROUND
		
		/**
		 * 背景を描画します.このメソッドを実行すると、現在の描画内容がクリアされます.
		 * 
		 * <p>引数の数により色の指定が異なります.</p>
		 * 
		 * <listing>background( gray )</listing>
		 * <listing>background( gray, alpha )</listing>
		 * <listing>background( hex )</listing>
		 * <listing>background( hex, alpha )</listing>
		 * <listing>background( red, green, blue )</listing>
		 * <listing>background( red, green, blue, alpha )</listing>
		 * <listing>background( hue, saturation, brightness )</listing>
		 * <listing>background( hue, saturation, brightness, alpha )</listing>
		 */
		public function background( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void
		{
			if ( _width > 0 && _height > 0 )
			{
				__calcColor( c1, c2, c3, c4 );
				gc.__BG( _width, _height, __calc_color, __calc_alpha );
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------- FILL
		
		/**
		 * 塗りの色、透明度を指定します.
		 * 
		 * <p>引数の数により色の指定が異なります.</p>
		 * 
		 * <listing>fill( gray )</listing>
		 * <listing>fill( gray, alpha )</listing>
		 * <listing>fill( hex )</listing>
		 * <listing>fill( hex, alpha )</listing>
		 * <listing>fill( red, green, blue )</listing>
		 * <listing>fill( red, green, blue, alpha )</listing>
		 * <listing>fill( hue, saturation, brightness )</listing>
		 * <listing>fill( hue, saturation, brightness, alpha )</listing>
		 */
		public function fill( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void
		{
			__calcColor( c1, c2, c3, c4 );
			gc.fillColor = __calc_color;
			gc.fillAlpha = __calc_alpha;
			gc.fillDo = true;
		}
		
		/**
		 * 塗りが描画されないようにします.
		 */
		public function noFill():void
		{
			gc.fillDo = false;
		}
		
		//------------------------------------------------------------------------------------------------------------------- STROKE
		
		/**
		 * 線の色、透明度を指定します.
		 * このメソッドにより lineStyle　が実行され線のスタイルが適用されます.
		 * 
		 * <p>引数の数により色の指定が異なります.</p>
		 * 
		 * <listing>stroke( gray )</listing>
		 * <listing>stroke( gray, alpha )</listing>
		 * <listing>stroke( hex )</listing>
		 * <listing>stroke( hex, alpha )</listing>
		 * <listing>stroke( red, green, blue )</listing>
		 * <listing>stroke( red, green, blue, alpha )</listing>
		 * <listing>stroke( hue, saturation, brightness )</listing>
		 * <listing>stroke( hue, saturation, brightness, alpha )</listing>
		 */
		public function stroke( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void
		{
			__calcColor( c1, c2, c3, c4 );
			gc.strokeColor = __calc_color;
			gc.strokeAlpha = __calc_alpha;
			gc.applyStroke();
		}
		
		/**
		 * 線が描画されないようにします.
		 */
		public function noStroke():void
		{
			gc.noStroke();
		}
		
		/**
		 * 線の太さを指定します.有効な値は 0～255 です.
		 */
		public function strokeWeight( thickness:Number ):void
		{
			gc.thickness = thickness;
			gc.reapplyStroke();
		}
		
		/**
		 * 線の角で使用する接合点の外観の種類を指定します.
		 * @see	flash.display.JointStyle
		 */
		public function strokeJoin( jointStyle:String ):void
		{
			gc.joints = jointStyle;
			gc.reapplyStroke();
		}
		
		/**
		 * 線の終端のキャップの種類を指定します.
		 * @see	flash.display.CapsStyle
		 */
		public function strokeCap( capsStyle:String ):void
		{
			gc.caps = capsStyle;
			gc.reapplyStroke();
		}
		
		/**
		 * 線をヒンティングするかどうかを示します.
		 */
		public function strokePixelHint( pixelHinting:Boolean ):void
		{
			gc.pixelHinting = pixelHinting;
			gc.reapplyStroke();
		}
		
		/**
		 * 使用する拡大 / 縮小モードを指定する LineScaleMode クラスの値を示します.
		 * @see flash.display.LineScaleMode
		 */
		public function strokeScaleMode( scaleMode:String ):void
		{ 
			gc.scaleMode = scaleMode;
			gc.reapplyStroke();
		}
		
		/**
		 * マイターが切り取られる限度を示す数値を示します.
		 */
		public function strokeMiterLimit( miterLimit:Number ):void
		{ 
			gc.miterLimit = miterLimit;
			gc.reapplyStroke();
		}
		
		//------------------------------------------------------------------------------------------------------------------- TINT
		
		/**
		 * Tint Color を指定します.
		 * 
		 * <p>引数の数により色の指定が異なります.</p>
		 * 
		 * <listing>tint( gray )</listing>
		 * <listing>tint( gray, alpha )</listing>
		 * <listing>tint( hex )</listing>
		 * <listing>tint( hex, alpha )</listing>
		 * <listing>tint( red, green, blue )</listing>
		 * <listing>tint( red, green, blue, alpha )</listing>
		 * <listing>tint( hue, saturation, brightness )</listing>
		 * <listing>tint( hue, saturation, brightness, alpha )</listing>
		 */
		public function tint( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void
		{
			__calcColor( c1, c2, c3, c4 );
			_tint_color = FColor.toARGB( __calc_color, __calc_alpha );
			_tint_do    = ( _tint_color != 0xffffffff );
		}
		
		/**
		 * Tint を無効にします.
		 */
		public function noTint():void
		{
			_tint_color = 0xffffffff;
			_tint_do    = false;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		public function get fillColor():uint{ return gc.fillColor; }
		public function set fillColor( value:uint ):void
		{
			gc.fillColor = value;
			gc.fillDo = true;
		}
		
		public function get fillAlpha():Number{ return gc.fillAlpha; }
		public function set fillAlpha( value:Number ):void
		{
			gc.fillAlpha = value;
			gc.fillDo = true;
		}
		
		public function get strokeColor():uint{ return gc.strokeColor; }
		public function set strokeColor( value:uint ):void
		{
			gc.strokeColor = value;
			gc.applyStroke();
		}
		
		public function get strokeAlpha():Number{ return gc.strokeAlpha; }
		public function set strokeAlpha( value:Number ):void
		{
			gc.strokeAlpha = value;
			gc.applyStroke();
		}
		
		/**
		 * Tint Color を 32bit Color で示します.
		 */
		public function get tintColor():uint{ return _tint_color; }
		public function set tintColor( value:uint ):void
		{
			_tint_color = value;
			_tint_do    = ( _tint_color != 0xffffffff );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// GRAPHICS
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 指定されている線のスタイルをを適用します.
		 */
		public function applyStroke():void
		{
			gc.applyStroke();
		}
		
		/**
		 * 線のスタイルを指定します.
		 */
		public function lineStyle( thickness:Number = NaN, color:uint = 0, alpha:Number = 1,
								   pixelHinting:Boolean = false, scaleMode:String = "normal",
								   caps:String=null,joints:String=null,miterLimit:Number=3):void
		{
			gc.lineStyle( thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit );
		}
		
		/**
		 * 線スタイルのグラデーションを指定します.
		 */
		public function lineGradientStyle( type:String, colors:Array, alphas:Array, ratios:Array,
										   matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb",
										   focalPointRatio:Number=0.0 ):void
		{
			if ( update_fill_matrix() ) {
				if ( matrix!=null )
					_fill_matrix.prepend( matrix );
				else
					_fill_matrix.prependMatrix( 0.1220703125, 0, 0, 0.1220703125, 0, 0 ); //default Gradient matrix
				gc.lineGradientStyle( type, colors, alphas, ratios, _fill_matrix, spreadMethod, interpolationMethod, focalPointRatio );
			}else{
				gc.lineGradientStyle( type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio );
			}
		}
		
		/**
		 * 指定されている塗りで beginFill() を実行します.
		 */
		public function applyFill():void
		{
			gc.applyFill();
		}
		
		/**
		 * 今後の描画に使用する単色塗りを指定します.
		 */
		public function beginFill( color:uint, alpha:Number=1.0 ):void
		{
			gc.beginFill( color, alpha );
		}
		
		/**
		 * 描画領域をビットマップイメージで塗りつぶします.
		 */
		public function beginBitmapFill(bitmap:BitmapData,matrix:Matrix=null,repeat:Boolean=true,smooth:Boolean=false):void
		{
			if ( update_fill_matrix() ) {
				if ( matrix != null )
					_fill_matrix.prepend( matrix );
				gc.beginBitmapFill( bitmap, _fill_matrix, repeat, smooth );
			}else{
				gc.beginBitmapFill( bitmap, matrix, repeat, smooth );
			}
		}
		
		/**
		 * 今後の描画に使用するグラデーション塗りを指定します.
		 */
		public function beginGradientFill(type:String, color:Array, alphas:Array, ratios:Array, matrix:Matrix=null, spreadMethod:String="pad", interpolationMethod:String="rgb",focalPointRatio:Number=0.0):void
		{
			if ( update_fill_matrix() ) {
				if ( matrix!=null )
					_fill_matrix.prepend( matrix );
				else
					_fill_matrix.prependMatrix( 0.1220703125, 0, 0, 0.1220703125, 0, 0 ); //default Gradient matrix
				gc.beginGradientFill( type, color, alphas, ratios, _fill_matrix, spreadMethod, interpolationMethod, focalPointRatio );
			}else{
				gc.beginGradientFill( type, color, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio );
			}
		}
		
		/**
		 * beginFill()、beginGradientFill()、または beginBitmapFill() メソッドへの最後の呼び出し以降に追加された線と曲線に塗りを適用します.
		 */
		public function endFill():void
		{
			gc.endFill();
		}
		
		/** @private */
		protected function update_fill_matrix():Boolean 
		{
			return false;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Color Mode
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * カラーモードと、色の有効値を設定します.
		 * 
		 * <p>引数の数により有効値の設定が異なります.</p>
		 * 
		 * <listing>colorMode( RGB, value);</listing>
		 * <p>range1～range4 全てに value が適用されます.</p>
		 *  
		 * <listing>colorMode( RGB, value1, value2, value3 );</listing>
		 * <p>colorModeX に value1、colorModeY に value2、colorModeZ に value3 が適用されます.colorModeAは変更されません.</p>
		 * 
		 * <listing>colorMode( RGB, value1, value2, value3, value4 );</listing>
		 * <p>colorModeX～colorModeA　をそれぞれ個別に指定します.</p>
		 * 
		 * @param	mode	RGB,HSB,HSV
		 * @param	range1	colorModeX
		 * @param	range2	colorModeY
		 * @param	range3	colorModeZ
		 * @param	range4	colorModeA
		 */
		public function colorMode( mode:String, range1:Number=0xff, range2:Number=NaN, range3:Number=NaN, range4:Number=NaN ):void
		{
			colorModeState = mode;
			if ( range4 > 0 )
			{
				colorModeX = range1;
				colorModeY = range2;
				colorModeZ = range3;
				colorModeA = range4;
			}
			else if ( range3 > 0 )
			{
				colorModeX = range1;
				colorModeY = range2;
				colorModeZ = range3;
			}
			else
			{
				colorModeX = colorModeY = colorModeZ = colorModeA = range1;
			}
		}
		
		/**
		 * color uint を取得します.
		 * 
		 * <p>引数の数により色の指定が異なります.</p>
		 * 
		 * <listing>color( gray )</listing>
		 * <listing>color( gray, alpha )</listing>
		 * <listing>color( hex )</listing>
		 * <listing>color( hex, alpha )</listing>
		 * <listing>color( red, green, blue )</listing>
		 * <listing>color( red, green, blue, alpha )</listing>
		 * <listing>color( hue, saturation, brightness )</listing>
		 * <listing>color( hue, saturation, brightness, alpha )</listing>
		 * 
		 * @param	c1	first value
		 * @param	c2	second value
		 * @param	c3	third value
		 * @param	c4	fourth value
		 */
		public function color( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):uint
		{
			if ( c4 >= 0 )
			{
				if ( colorModeState == HSB )
					return FColor.HSVtoValue( 360*c1/colorModeX , c2/colorModeY, c3/colorModeZ, c4/colorModeA );
				else
					return FColor.RGBtoValue( uint(c1/colorModeX*0xff), uint(c2/colorModeY*0xff), uint(c3/colorModeZ*0xff), c4/colorModeA );
			}
			else if ( c3 >= 0 )
			{
				if ( colorModeState == HSB )
					return FColor.HSVtoValue( 360*c1/colorModeX , c2/colorModeY, c3/colorModeZ );
				else
					return FColor.RGBtoValue( uint(c1/colorModeX*0xff), uint(c2/colorModeY*0xff), uint(c3/colorModeZ*0xff) );
			}
			else if ( c2 >= 0 )
			{
				if( uint(c1) <= colorModeX )
					return FColor.GrayToValue( uint(c1/colorModeX*0xff), c2/colorModeA );
				else
					return FColor.toARGB( uint(c1), c2 / colorModeA );	
			}
			else
			{
				if( uint(c1) <= colorModeX )
					return FColor.GrayToValue( uint(c1/colorModeX*0xff) );
				else
					return uint(c1);
			}
		}
		
		/**
		 * @private
		 */
		internal function __calcColor( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void
		{
			if ( c4 >= 0 )
			{
				__calc_alpha = c4 / colorModeA;
				if ( colorModeState == HSB )
					__calc_color = FColor.HSVtoValue( 360*c1/colorModeX , c2/colorModeY, c3/colorModeZ );
				else
					__calc_color = FColor.RGBtoValue( uint(c1/colorModeX*0xff), uint(c2/colorModeY*0xff), uint(c3/colorModeZ*0xff) );
			}
			else if ( c3 >= 0 )
			{
				__calc_alpha = 1.0;
				if ( colorModeState == HSB )
					__calc_color = FColor.HSVtoValue( 360*c1/colorModeX , c2/colorModeY, c3/colorModeZ );
				else
					__calc_color = FColor.RGBtoValue( uint(c1/colorModeX*0xff), uint(c2/colorModeY*0xff), uint(c3/colorModeZ*0xff) );
			}
			else if ( c2 >= 0 )
			{
				__calc_alpha = c2 / colorModeA;
				if( uint(c1) <= colorModeX )
					__calc_color = FColor.GrayToValue( uint(c1 / colorModeX * 0xff) );
				else if ( c1 >>> 24 > 0 )
					__calc_color = c1 & 0xffffff;
				else
					__calc_color = uint(c1);
			}
			else
			{
				__calc_alpha = 1.0;
				if ( uint(c1) <= colorModeX )
				{
					__calc_color = FColor.GrayToValue( uint(c1 / colorModeX * 0xff) );
				}
				else if ( c1 >>> 24 > 0 )
				{
					__calc_color = c1 & 0xffffff;
					__calc_alpha = (c1 >>> 24) / 0xff;
				}
				else
				{
					__calc_color = uint(c1);
				}
			}
		}
		
		
		//-------------------------------------------------------------------------------------------------------------------
		// Transform API
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * implements in F5Graphics2D,F5Graphics3D
		 * @private
		 */
		public function pushMatrix():void { ; }
		
		/**
		 * implements in F5Graphics2D,F5Graphics3D
		 * @private
		 */
		public function popMatrix():void { ; }
		
		/**
		 * implements in F5Graphics2D,F5Graphics3D
		 * @private
		 */
		public function applyMatrix2D( mat:Matrix ):void { ; }
		
		//-------------------------------------------------------------------------------------------------------------------
		// Loader
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * フォントを読み込みます.
		 * <p>※将来的に再構成されなくなる予定です</p>
		 */
		public function loadFont( font_url:String, loader:URLLoader= null, callback:Function = null ):PFontLoader
		{
			return new PFontLoader( font_url, loader, callback );
		}
		/**
		 * 画像を読み込みます.
		 * <p>※将来的に再構成されなくなる予定です</p>
		 */
		public function loadImage( url:String, loader:Loader= null, callback:Function = null ):FImageLoader
		{
			return new FImageLoader( url, loader, callback );
		}
		/**
		 * SVGを読み込みます.
		 * <p>※将来的に再構成されなくなる予定です</p>
		 */
		public function loadShape( url:String, loader:URLLoader = null, callback:Function = null ):FShapeSVGLoader
		{
			return new FShapeSVGLoader( url, loader, callback );
		}
	}
	
}

//-------------------------------------------------------------------------------------------------------------------

import flash.display.BitmapData;
import flash.utils.Dictionary;
import flash.geom.ColorTransform;

class TintCache 
{
	private var d:Dictionary;
	private var ct:ColorTransform;
	
	public function TintCache()
	{
		d  = new Dictionary(false);
		ct = new ColorTransform();
	}
	
	/**
	 * カラー調整した BitmapData を取得.
	 * 指定の TintColor に対応した BitmapData が存在しない場合、カラー調整したデータを生成.
	 */
	public function getTintImage( src:BitmapData, color32:uint ):BitmapData
	{
		if ( color32 != 0xffffffff )
		{
			var tint_img:BitmapData;
			if ( d[src] == null )
			{
				d[src] = [];
				d[src][color32] = tint_img = tint( src, color32 );
			}
			else
			{
				tint_img = d[src][color32];
				if ( tint_img == null )
					d[src][color32] = tint_img = tint( src, color32 );
			}
			return tint_img;
		}
		else
		{
			return src;
		}
	}
	
	private function tint( src:BitmapData, color32:uint ):BitmapData
	{
		var img:BitmapData = src.clone();
		ct.alphaMultiplier = ( color32>>>24 ) / 0xff;
		ct.redMultiplier   = ( color32>>16 & 0xff ) / 0xff;
		ct.greenMultiplier = ( color32>>8 & 0xff ) / 0xff;
		ct.blueMultiplier  = ( color32 & 0xff ) / 0xff;
		img.colorTransform( img.rect, ct );
		return img;
	}
	
	/**
	 * 保持しているカラー調整済み BitmapData を dispose.
	 * nullを指定した場合、全てのデータを dispose
	 */
	public function dispose( targetSrc:BitmapData=null ):void
	{
		var d2:Array;
		var tintImg:BitmapData;
		if ( targetSrc == null )
		{
			for ( var img:* in d )
			{
				d2 = d[img];
				for each ( tintImg in d2 )
				{
					tintImg.dispose();
				}
				delete d[img];
			}
		}
		else
		{
			d2 = d[targetSrc];
			if ( d2 != null )
			{
				for each ( tintImg in d2 )
				{
					tintImg.dispose();
				}
				delete d[targetSrc];
			}
		}
	}
}
