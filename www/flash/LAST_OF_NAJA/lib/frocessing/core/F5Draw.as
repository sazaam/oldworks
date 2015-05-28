// --------------------------------------------------------------------------
// Project Frocessing
// ActionScript 3.0 drawing library like Processing.
// --------------------------------------------------------------------------
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

package frocessing.core 
{
	import frocessing.f5internal;
	use namespace f5internal;
	
	/**
	 * 描画メソッドのクラスです.
	 * 
	 * <p>※将来的に再構成されなくなる予定です</p>
	 * 
	 * @author nutsu
	 * @version 0.5.8
	 */
	public class F5Draw 
	{
		private static const PI         :Number = Math.PI;
		private static const TWO_PI     :Number = Math.PI*2;
		private static const HALF_PI    :Number = Math.PI/2;
		
		public var fg:F5Graphics;
		
		/**
		 * 
		 */
		public function F5Draw( fg:F5Graphics ) 
		{
			this.fg = fg;
		}
		
		/**
		 * 三角形を描画します.
		 */
		public function drawTriangle( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number ):void
		{
			fg.moveTo( x0, y0 );
			fg.lineTo( x1, y1 );
			fg.lineTo( x2, y2 );
			fg.closePath();
		}
		
		/**
		 * 四角形を描画します.
		 */
		public function drawQuad( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void
		{
			fg.moveTo( x0, y0 );
			fg.lineTo( x1, y1 );
			fg.lineTo( x2, y2 );
			fg.lineTo( x3, y3 );
			fg.closePath();
		}
		
		/**
		 * 多角形を描画します.
		 * @param	coordinates	[ x0, y0, x1, y1, ..., xn, yn ]
		 * @param	close_path
		 */
		public function drawPolygon( coordinates:Array, close_path:Boolean=true ):void
		{
			fg.moveTo( coordinates[0], coordinates[1] );
			var len:int = coordinates.length;
			for ( var i:int = 2; i < len; i += 2 )
				fg.lineTo( coordinates[i], coordinates[i + 1] );
			if ( close_path )
				fg.closePath();
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
			var dr:Number         = 2*PI/vertex_number;
			rotation -= PI*0.5;
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
			var dr:Number         = 2*PI/vertex_number;
			rotation -= PI*0.5;
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
			fg.__drawArc( x, y, rx, ry, begin, end, rotation );
		}
		
		/**
		 * パイを描画します.
		 * @param	x			中心座標 x
		 * @param	y			中心座標 y
		 * @param	rx			半径 x
		 * @param	ry			半径 y
		 * @param	begin		描画開始角度(radian)
		 * @param	end			描画終了角度(radian)
		 * @param	rotation	シェイプの回転
		 */
		public function drawPie( x:Number, y:Number, rx:Number, ry:Number, begin:Number, end:Number, rotation:Number = 0 ):void
		{
			fg.moveTo( x, y );
			fg.arcTo( x, y, rx, ry, begin, end, rotation );
			fg.closePath();
		}
		
		/**
		 * 2次ベジェ曲線を描画します.
		 */
		public function drawQBezier( x0:Number, y0:Number, cx0:Number, cy0:Number, x1:Number, y1:Number ):void
		{
			fg.moveTo( x0, y0 );
			fg.curveTo( cx0, cy0, x1, y1 );
		}
		
		/**
		 * 3次ベジェ曲線を描画します.
		 */
		public function drawBezier( x0:Number, y0:Number, cx0:Number, cy0:Number, cx1:Number, cy1:Number, x1:Number, y1:Number ):void
		{
			fg.moveTo( x0, y0 );
			fg.bezierTo( cx0, cy0, cx1, cy1, x1, y1 );
		}
		
		/**
		 * スプライン曲線を描画します.
		 */
		public function drawSpline( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number ):void
		{
			fg.moveTo( x1, y1 );
			fg.splineTo( x0, y0, x3, y3, x2, y2 );
		}
		
		/**
		 * 円を描画します.
		 * @param	x
		 * @param	y
		 * @param	radius
		 */
		public function drawCircle( x:Number, y:Number, radius:Number ):void
		{
			fg.f5internal::__ellipse( x, y, radius, radius );
		}
		
		/**
		 * 楕円を描画します.
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 */
		public function drawEllipse( x:Number, y:Number, width:Number, height:Number ):void
		{
			width  *= 0.5;
			height *= 0.5;
			fg.f5internal::__ellipse( x+width, y+height, width, height );
		}
		
		/**
		 * 矩形を描画します.
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 */
		public function drawRect(x:Number, y:Number, width:Number, height:Number ):void
		{
			drawQuad( x, y, x + width, y, x + width, y + height, x, y + height );
		}
		
		/**
		 * 角丸矩形を描画します.
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 * @param	ellipseWidth
		 * @param	ellipseHeight
		 */
		public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number):void
		{
			var x1:Number = x + width;
			var y1:Number = y + height;
			var rx:Number;
			var ry:Number;
			
			if( ellipseWidth>width )
				rx = width*0.5;
			else
				rx = ellipseWidth*0.5;
			
			if( ellipseHeight>height )
				ry = height*0.5;
			else
				ry = ellipseHeight*0.5;
			
			fg.f5internal::__roundrect( x, y, x1, y1, rx, ry );
		}
		
		/**
		 * 各コーナーの角丸を指定して、角丸矩形を描画します.
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 * @param	topLeftRadius
		 * @param	topRightRadius
		 * @param	bottomLeftRadius
		 * @param	bottomRightRadius
		 */
		public function drawRoundRectComplex(x:Number, y:Number, width:Number, height:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number):void
		{
			var x1:Number = x + width;
			var y1:Number = y + height;
			var k:Number;
			if ( topLeftRadius + bottomLeftRadius > height )
			{
				k = height / (topLeftRadius + bottomLeftRadius);
				topLeftRadius *= k;
				bottomLeftRadius *= k;
			}
			if ( topRightRadius + bottomRightRadius > height )
			{
				k = height / (topRightRadius + bottomRightRadius);
				topRightRadius *= k;
				bottomRightRadius *= k;
			}
			if ( topLeftRadius + topRightRadius > width )
			{
				k = width / (topLeftRadius + topRightRadius);
				topLeftRadius *= k;
				topRightRadius *= k;
			}
			if ( bottomLeftRadius + bottomRightRadius > width )
			{
				k = width / (bottomLeftRadius + bottomRightRadius);
				bottomLeftRadius *= k;
				bottomRightRadius *= k;
			}
			fg.moveTo( x + topLeftRadius, y );
			fg.lineTo( x1 - topRightRadius, y );
			if ( topRightRadius > 0 )
				fg.__arc( x1 - topRightRadius, y + topRightRadius, topRightRadius, topRightRadius, -HALF_PI, 0.0 );
			fg.lineTo( x1, y1 - bottomRightRadius );
			if ( bottomRightRadius > 0 )
				fg.__arc( x1 - bottomRightRadius, y1 - bottomRightRadius, bottomRightRadius, bottomRightRadius, 0.0, HALF_PI );
			fg.lineTo( x + bottomLeftRadius, y1 );
			if ( bottomLeftRadius > 0 )
				fg.__arc( x + bottomLeftRadius, y1 - bottomLeftRadius, bottomLeftRadius, bottomLeftRadius, HALF_PI, PI );
			fg.lineTo( x, y + topLeftRadius );
			if ( topLeftRadius > 0 )
				fg.__arc( x + topLeftRadius, y + topLeftRadius, topLeftRadius, topLeftRadius, -PI, -HALF_PI );
		}
	}
	
}