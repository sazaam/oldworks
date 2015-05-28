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

package frocessing.core {
	
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import frocessing.bmp.FBitmapGraphics;
	
	/**
	* GraphicsEx クラスは、Graphics に シェイプ・曲線の描画メソッドを拡張したクラスです.
	* 
	* @author nutsu
	* @version 0.2
	*/
	public class GraphicsEx extends GraphicsBase{
		
		// curve parameters
		protected var bezier_draw_step   :uint = 20;
		protected var spline_draw_step   :uint = 20;
		protected var spline_tightness :Number = 1.0;
		
		protected var _splineX0        :Number = 0.0;
		protected var _splineY0        :Number = 0.0;
		protected var _splineX1        :Number = 0.0;
		protected var _splineY1        :Number = 0.0;
		protected var _splineX2        :Number = 0.0;
		protected var _splineY2        :Number = 0.0;
		
		// bitmap graphics
		protected var _bmpGC:FBitmapGraphics;
		
		
		/**
		 * 新しい GraphicsEx クラスのインスタンスを生成します.
		 * 
		 * @param	gc	描画対象となる Graphics を指定します
		 */
		public function GraphicsEx( gc:Graphics )
		{
			super(gc);
			_bmpGC = new FBitmapGraphics( gc, true );
		}
		
		//--------------------------------------------------------------------------------------------------- CURVE METHODS
		
		/**
		 * 3次ベジェ曲線を描画する際の精度を指定します.
		 * @param	detail_step	指定された数の直線で曲線を近似します
		 */
		public function bezierDetail( detail_step:uint ):void
		{
			bezier_draw_step = detail_step;
		}
		
		/**
		 * スプライン曲線を描画する際の精度を指定します.
		 * @param	detail_step	指定された数の直線で曲線を近似します
		 */
		public function curveDetail( detail_step:uint ):void
		{
			spline_draw_step = detail_step;
		}
		
		/**
		 * スプライン曲線の曲率を指定します.デフォルト値は 1.0 です.
		 */
		public function curveTightness( spline_tightness_:Number ):void
		{
			spline_tightness = spline_tightness_;
		}
		
		//------------------------------------------
		
		/**
		 * quadratic bezier function
		 * @param	a	first point on the curve
		 * @param	b	control point
		 * @param	c	second point on the curve
		 * @param	t	value [0,1]
		 */
		public function qbezierPoint( a:Number, b:Number, c:Number, t:Number ):Number
		{
			var tp:Number = 1.0 - t;
			return a*tp*tp + 2*b*t*tp + c*t*t;
		}
		
		/**
		 * cubic bezier function
		 * @param	a	first point on the curve
		 * @param	b	first control point
		 * @param	c	second control point
		 * @param	d	second point on the curve
		 * @param	t	value [0,1]
		 */
		public function bezierPoint( a:Number, b:Number, c:Number, d:Number, t:Number ):Number
		{
			var tp:Number = 1.0 - t;
			return a*tp*tp*tp + 3*b*t*tp*tp + 3*c*t*t*tp + d*t*t*t;
		}
		
		/**
		 * spline function
		 * @param	a	first point on the curve
		 * @param	b	second point on the curve
		 * @param	c	third point on the curve
		 * @param	d	fourth point on the curve
		 * @param	t	value [0,1]
		 */
		public function curvePoint( a:Number, b:Number, c:Number, d:Number, t:Number ):Number
		{
			var v0:Number = spline_tightness*( c - a )*0.5;
			var v1:Number = spline_tightness*( d - b )*0.5;
			return t*t*t*( 2*b - 2*c + v0 + v1 ) + t*t*( -3*b + 3*c - 2*v0 - v1 ) + v0*t + b;
		}
		
		//------------------------------------------
		
		/**
		 * diff of quadratic bezier function
		 * @param	a	first point on the curve
		 * @param	b	control point
		 * @param	c	second point on the curve
		 * @param	t	value [0,1]
		 */
		public function qbezierTangent( a:Number, b:Number, c:Number, t:Number ):Number
		{
			return 2*( t*( a + c - 2*b ) - a + b );
		}
		
		/**
		 * diff of cubic bezier function
		 * @param	a	first point on the curve
		 * @param	b	first control point
		 * @param	c	second control point
		 * @param	d	second point on the curve
		 * @param	t	value [0,1]
		 */
		public function bezierTangent( a:Number, b:Number, c:Number, d:Number, t:Number ):Number
		{
			return 3*(d-a-3*c+3*b)*t*t + 6*(a+c-2*b)*t - 3*a+3*b;
		}
		
		/**
		 * diff of spline function
		 * @param	a	first control point
		 * @param	b	first point on the curve
		 * @param	c	second point on the curve
		 * @param	d	second control point
		 * @param	t	value [0,1]
		 */
		public function curveTangent( a:Number, b:Number, c:Number, d:Number, t:Number ):Number
		{
			var v0:Number = spline_tightness*( c - a )*0.5;
			var v1:Number = spline_tightness*( d - b )*0.5;
			return 3*t*t*( 2*b -2*c + v0 + v1) + 2*t*( 3*c - 3*b - v1 - 2*v0 ) + v0;
		}
		
		//--------------------------------------------------------------------------------------------------- DRAW_*
		
		/**
		* 点を描画します.
		*/
		public function drawPoint( x:Number, y:Number, col:uint=0, alpha_:Number=1.0 ):void
		{
			moveTo( x, y );
			$point( _startX, _startY, col, alpha_ );
		}
		
		/**
		 * 直線を描画します.
		 */
		public function drawLine( x0:Number, y0:Number, x1:Number, y1:Number ):void
		{
			moveTo( x0, y0 );
			lineTo( x1, y1 );
		}
		
		/**
		 * 三角形を描画します.
		 */
		public function drawTriangle( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number ):void
		{
			moveTo( x0, y0 );
			lineTo( x1, y1 );
			lineTo( x2, y2 );
			closePath();
		}
		
		/**
		 * 四角形を描画します.
		 */
		public function drawQuad( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void
		{
			moveTo( x0, y0 );
			lineTo( x1, y1 );
			lineTo( x2, y2 );
			lineTo( x3, y3 );
			closePath();
		}
		
		/**
		 * Polylineを描画します.
		 * @param	coordinates	x0, y0, x1, y1, ..., xn, yn
		 */
		public function drawPolyline( ...coordinates ):void
		{
			moveTo( coordinates[0], coordinates[1] );
			var len:int = coordinates.length;
			for ( var i:int = 2; i < len; i += 2 )
				lineTo( coordinates[i], coordinates[i + 1] );
		}
		
		/**
		 * 多角形を描画します.
		 * @param	coordinates	[ x0, y0, x1, y1, ..., xn, yn ]
		 * @param	close_path
		 */
		public function drawPolygon( coordinates:Array, close_path:Boolean=true ):void
		{
			moveTo( coordinates[0], coordinates[1] );
			var len:int = coordinates.length;
			for ( var i:int = 2; i < len; i += 2 )
				lineTo( coordinates[i], coordinates[i + 1] );
			if ( close_path )
				closePath();
		}
		
		/**
		 * 正多角形を描画します.
		 * @param	x				中心座標 x
		 * @param	y				中心座標 y
		 * @param	vertex_number	多角形の頂点の数
		 * @param	radius			頂点と中心の距離
		 * @param	rotation		シェイプの回転
		 */
		public function drawRegPolygon( x:Number, y:Number, vertex_number:uint, radius:Number, rotation:Number = 0.0 ):void
		{
			var coordinates:Array = new Array();
			var dr:Number         = 2*Math.PI/vertex_number;
			rotation -= Math.PI*0.5;
			for ( var i:int = 0 ; i < vertex_number ; i++ ) {
				coordinates.push( x + Math.cos( rotation )*radius );
				coordinates.push( y + Math.sin( rotation )*radius );
				rotation += dr;
			}
			drawPolygon( coordinates );
		}
		
		/**
		 * スターを描画します.
		 * @param	x				中心座標 x
		 * @param	y				中心座標 y
		 * @param	vertex_number	頂点の数
		 * @param	radius_out		外径
		 * @param	radius_in		内径
		 * @param	rotation		シェイプの回転
		 */
		public function drawStarPolygon( x:Number, y:Number, vertex_number:uint, radius_out:Number , radius_in:Number, rotation:Number = 0.0 ):void
		{
			var coordinates:Array = new Array();
			var dr:Number         = 2*Math.PI/vertex_number;
			rotation -= Math.PI*0.5;
			for ( var i:int = 0 ; i < vertex_number ; i++ ) {
				coordinates.push( x + Math.cos( rotation )*radius_out );
				coordinates.push( y + Math.sin( rotation )*radius_out );
				rotation += dr/2;
				coordinates.push( x + Math.cos( rotation )*radius_in );
				coordinates.push( y + Math.sin( rotation )*radius_in );
				rotation += dr/2;
			}
			drawPolygon( coordinates );
		}
		
		/**
		 * 円弧を描画します.
		 * @param	x			中心座標 x
		 * @param	y			中心座標 y
		 * @param	rx			半径 x
		 * @param	ry			半径 y
		 * @param	begin		描画開始角度(radian)
		 * @param	end			描画終了角度(radian)
		 * @param	rotation	シェイプの回転
		 */
		public function drawArc( x:Number, y:Number, rx:Number, ry:Number, begin:Number, end:Number, rotation:Number=0 ):void
		{
			if( rotation==0 )
			{
				moveTo( x + rx*Math.cos(begin), y + ry*Math.sin(begin) );
				arc_curve( x, y, rx, ry, begin, end, rotation );
			}
			else
			{
				var rc:Number = Math.cos(rotation);
				var rs:Number = Math.sin(rotation);
				var xx:Number = rx*Math.cos(begin);
				var yy:Number = ry*Math.sin(begin);
				moveTo( x + xx*rc - yy*rs, y + xx*rs + yy*rc );
				arc_curve( x, y, rx, ry, begin, end, rotation );
			}
		}
		
		
		/**
		 * 2次ベジェ曲線を描画します.
		 */
		public function drawQBezier( x0:Number, y0:Number, cx0:Number, cy0:Number, x1:Number, y1:Number ):void
		{
			moveTo( x0, y0 );
			curveTo( cx0, cy0, x1, y1 );
		}
		
		/**
		 * 3次ベジェ曲線を描画します.
		 */
		public function drawBezier( x0:Number, y0:Number, cx0:Number, cy0:Number, cx1:Number, cy1:Number, x1:Number, y1:Number ):void
		{
			moveTo( x0, y0 );
			bezierTo( cx0, cy0, cx1, cy1, x1, y1 );
		}
		
		/**
		 * スプライン曲線を描画します.
		 */
		public function drawSpline( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void
		{
			splineInit( x0, y0, x1, y1, x2, y2 );
			splineTo( x3, y3 );
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
		public function arcline( x0:Number, y0:Number, x:Number, y:Number, rx:Number, ry:Number, large_arc_flag:Boolean = false, sweep_flag:Boolean = true, x_axis_rotation:Number = 0 ):void
		{			
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
				arc_curve( mx + cx*rc - cy*rs, my + cx*rs + cy*rc, rx, ry, begin, (sweep_flag) ? begin+mr : begin-(2*Math.PI-mr), x_axis_rotation );
			}
			else
			{
				//half arc
				rx = len;
				ry = rx/e;
				
				begin = Math.atan2( -dy, -dx );
				arc_curve( mx, my, rx, ry, begin, (sweep_flag) ? begin+Math.PI : begin-Math.PI, x_axis_rotation );
			}
		}
		
		/**
		 * 現在の位置から指定の円弧を描きます
		 */
		public function arcTo( x:Number, y:Number, rx:Number, ry:Number, begin:Number, end:Number, rotation:Number=0 ):void
		{
			if( rotation==0 )
			{
				lineTo( x + rx*Math.cos(begin), y + ry*Math.sin(begin) );
				arc_curve( x, y, rx, ry, begin, end, rotation );
			}
			else
			{
				var rc:Number = Math.cos(rotation);
				var rs:Number = Math.sin(rotation);
				var xx:Number = rx*Math.cos(begin);
				var yy:Number = ry*Math.sin(begin);
				lineTo( x + xx*rc - yy*rs, y + xx*rs + yy*rc );
				arc_curve( x, y, rx, ry, begin, end, rotation );
			}
		}
		
		//--------------------------------------------------------------------------------------------------- DRAW_*_TO
		
		/**
		 * lines to
		 * @param	coordinates [ x0, y0, x1, y1, ..., xn, yn ]
		 */
		public function linesTo( coordinates:Array ):void
		{
			var len:int = coordinates.length;
			for ( var i:int = 0; i < len; i += 2 )
				lineTo( coordinates[i], coordinates[i + 1] );
		}
		
		//------------------------------------------------ CORE
		
		/**
		 * relative lineTo
		 * @param	x
		 * @param	y
		 */
		public function rlineTo( x:Number, y:Number ):void
		{
			_lastX += x;
			_lastY += y;
			$lineTo( _lastX, _lastY );
		}
		
		/**
		 * short hand curveTo
		 * @param	x	anchor x
		 * @param	y	anchor y
		 */
		public function scurveTo( x:Number, y:Number ):void
		{
			_lastCtrlX = 2*_lastX - _lastCtrlX;
			_lastCtrlY = 2*_lastY - _lastCtrlY;
			_lastX     = x;
			_lastY     = y;
			$curveTo( _lastCtrlX, _lastCtrlY, _lastX, _lastY );
		}
		
		/**
		 * short hand bezierTo
		 * @param	cx1	control x
		 * @param	cy1	control y
		 * @param	x1	anchor x
		 * @param	y1	anchor y
		 */
		public function sbezierTo( cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			var x0:Number  = _lastX;
			var y0:Number  = _lastY;
			var cx0:Number = 2*_lastX - _lastCtrlX;
			var cy0:Number = 2*_lastY - _lastCtrlY;
			_lastCtrlX     = cx1;
			_lastCtrlY     = cy1;
			_lastX         = x;
			_lastY         = y;
			$bezier( x0, y0, cx0, cy0, _lastCtrlX, _lastCtrlY, _lastX, _lastY, bezier_draw_step );
		}
		
		/**
		* init first spline
		*/
		protected function splineInit( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number ):void
		{
			_lastCtrlX = _lastX = _startX = x1;
			_lastCtrlY = _lastY = _startY = y1;
			$moveTo( _startX, _startY );
			_splineX0  = x0;
			_splineY0  = y0;
			_splineX1  = x1;
			_splineY1  = y1;
			_splineX2  = x2;
			_splineY2  = y2;
		}
		
		/**
		 * spline to : after spline curve
		 * @param	x	next control x
		 * @param	y	next control y
		 */
		public function splineTo( x:Number, y:Number ):void
		{
			var x0:Number  = _lastX;
			var y0:Number  = _lastY;
			var cx0:Number = _splineX1 + spline_tightness*( _splineX2 - _splineX0 )/6;
			var cy0:Number = _splineY1 + spline_tightness*( _splineY2 - _splineY0 )/6;
			var cx1:Number = _splineX2 + spline_tightness*( _splineX1 - x )/6;
			var cy1:Number = _splineY2 + spline_tightness*( _splineY1 - y )/6;
			_splineX0      = _splineX1;
			_splineY0      = _splineY1;
			_splineX1      = _splineX2;
			_splineY1      = _splineY2;
			_splineX2      = x;
			_splineY2      = y;
			_lastCtrlX     = cx1;
			_lastCtrlY     = cy1;
			_lastX         = _splineX1;
			_lastY         = _splineY1;
			$bezier( x0, y0, cx0, cy0, _lastCtrlX, _lastCtrlY, _lastX, _lastY, spline_draw_step );
		}
		
		/**
		 * cubic bezier to
		 */
		public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			var x0:Number = _lastX;
			var y0:Number = _lastY;
			_lastCtrlX    = cx1;
			_lastCtrlY    = cy1;
			_lastX        = x;
			_lastY        = y;
			$bezier( x0, y0, cx0, cy0, _lastCtrlX, _lastCtrlY, _lastX, _lastY, bezier_draw_step );
		}
		
		//--------------------------------------------------------------------------------------------------- 
		
		/**
		 * 円弧の描画メソッドです.
		 * @param	x
		 * @param	y
		 * @param	rx
		 * @param	ry
		 * @param	begin
		 * @param	end
		 * @param	rotation
		 * @internal local coordinates
		 */
		protected function arc_curve( x:Number, y:Number, rx:Number, ry:Number, begin:Number, end:Number, rotation:Number=0 ):void
		{
			var segmentNum:int = Math.ceil( Math.abs( 4*(end-begin)/Math.PI ) );
			var delta:Number   = (end - begin)/segmentNum;
			var ca:Number      = 1.0/Math.cos(delta/2);
			var t:Number       = begin;
			var ctrl_t:Number  = begin - delta/2;
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
		 * 3次ベジェ曲線の描画メソッドです.
		 * @internal global coordinates
		 */
		protected function $bezier( x0:Number, y0:Number, cx0:Number, cy0:Number, cx1:Number, cy1:Number, x1:Number, y1:Number, drawstep:uint ):void
		{
			var k:Number = 1.0/drawstep;
			var t:Number;
			var tp:Number;
			for ( var i:int = 1; i <= drawstep; i++ )
			{
				t = i*k;
				tp = 1.0-t;
				$lineTo( x0*tp*tp*tp + 3*cx0*t*tp*tp + 3*cx1*t*t*tp + x1*t*t*t, 
				         y0*tp*tp*tp + 3*cy0*t*tp*tp + 3*cy1*t*t*tp + y1*t*t*t );
			}
		}
		
		/**
		 * スプライン曲線の描画メソッドです.
		 * @internal global coordinates
		 */
		protected function $spline( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, drawstep:uint  ):void
		{
			// Catmull-Rom Spline Curve
			var k:Number = 1.0/spline_draw_step;
			var t:Number;
			var v0x:Number = spline_tightness*( x2 - x0 )*0.5;
			var v0y:Number = spline_tightness*( y2 - y0 )*0.5;
			var v1x:Number = spline_tightness*( x3 - x1 )*0.5;
			var v1y:Number = spline_tightness*( y3 - y1 )*0.5;
			for ( var i:int = 1; i <= spline_draw_step;  i++ )
			{
				t = i*k;
				$lineTo( t*t*t*( 2*x1 - 2*x2 + v0x + v1x ) + t*t*( -3*x1 + 3*x2 - 2*v0x - v1x ) + v0x*t + x1,
						 t*t*t*( 2*y1 - 2*y2 + v0y + v1y ) + t*t*( -3*y1 + 3*y2 - 2*v0y - v1y ) + v0y*t + y1 );
			}
		}
		
		//--------------------------------------------------------------------------------------------------- DRAW_BITMAP
		
		/**
		 * 画像を描画する場合の Smoothing を設定します.
		 */
		public function get imageSmoothing():Boolean { return _bmpGC.smooth; }
		public function set imageSmoothing( value_:Boolean ):void
		{
			_bmpGC.smooth = value_;
		}
		
		/**
		 * 画像を変形して描画する際の精度を指定します.
		 * @see frocessing.core.GraphicsEx#drawBitmapQuad
		 */
		public function get imageDetail():uint { return _bmpGC.detail; }
		public function set imageDetail( value_:uint ):void
		{
			_bmpGC.detail = value_;
		}
		
		/**
		 * 
		 * @param	bitmapdata
		 * @param	x
		 * @param	y
		 * @param	w
		 * @param	h
		 * @see		frocessing.bmp.FBitmapGraphics
		 */
		public function drawBitmapRect( bitmapdata:BitmapData, x:Number, y:Number, w:Number, h:Number ):void
		{
			super.moveTo( x, y );
			_bmpGC.beginBitmap( bitmapdata );
			_bmpGC.drawRect( x, y, w, h );
			_bmpGC.endBitmap();
		}
		
		/**
		 * @see		frocessing.bmp.FBitmapGraphics
		 */
		public function drawBitmapTriangle( bitmapdata:BitmapData,
											x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number,
											u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number ):void
		{
			super.moveTo( x0, y0 );
			_bmpGC.beginBitmap( bitmapdata );
			_bmpGC.drawTriangle( x0, y0, x1, y1, x2, y2, u0, v0, u1, v1, u2, v2 );
			_bmpGC.endBitmap();
		}
		
		/**
		 * @see		frocessing.bmp.FBitmapGraphics
		 */
		public function drawBitmapQuad( bitmapdata:BitmapData,
										x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number,
										u0:Number=0, v0:Number=0, u1:Number=1, v1:Number=0, u2:Number=1, v2:Number=1, u3:Number=0, v3:Number=1 ):void
		{
			super.moveTo( x0, y0 );
			_bmpGC.beginBitmap( bitmapdata );
			_bmpGC.drawQuad( x0, y0, x1, y1, x2, y2, x3, y3, u0, v0, u1, v1, u2, v2, u3, v3 );
			_bmpGC.endBitmap();
		}
	}
	
}