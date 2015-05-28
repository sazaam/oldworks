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
	//import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import frocessing.geom.FMatrix2D;
	import frocessing.shape.IFShape;
	
	import frocessing.f5internal;
	use namespace f5internal;
	
	/**
	* F5Graphics2D は、F5Graphics に Processing の Transform API を実装したクラスです.
	* 
	* @author nutsu
	* @version 0.5.8
	*/
	public class F5Graphics2D extends F5Graphics {
		
		// Transfrom
		private var __matrix:FMatrix2D;
		private var __matrix_tmp:Array;
		private var a:Number;
		private var b:Number;
		private var c:Number;
		private var d:Number;
		private var tx:Number;
		private var ty:Number;
		
		// Fill Matrix
		public var transformFillMatrix:Boolean = true;
		
		/**
		 * 新しい F5Graphics2D クラスのインスタンスを生成します.
		 * 
		 * @param	gc	描画対象となる Graphics を指定します
		 */
		public function F5Graphics2D( graphics:Graphics )
		{
			super(graphics);
			__matrix        = new FMatrix2D();
			__matrix_tmp    = [];
			resetMatrix();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 描画を開始するときに実行します.
		 */
		override public function beginDraw():void
		{
			super.beginDraw();
			resetMatrix();
		}
		
		/**
		 * 描画を終了するときに実行します.
		 */
		override public function endDraw():void
		{
			;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// TRANSFORM
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 現在の 変換 Matrix を一時的に保持します.
		 */
		override public function pushMatrix():void
		{
			__matrix_tmp.push( new MatrixParam( a, b, c, d, tx, ty ) );
		}
		
		/**
		 * 前回、pushMatrix() で保持した 変換 Matrix を復元します.
		 */
		override public function popMatrix():void
		{
			__applyMatrixParam( __matrix_tmp.pop() );
		}
		
		/**
		 * 変換 Matrix をリセットします.
		 */
		public function resetMatrix():void
		{
			__matrix.a  = a  = 1.0;
			__matrix.b  = b  = 0.0;
			__matrix.c  = c  = 0.0;
			__matrix.d  = d  = 1.0;
			__matrix.tx = tx = 0.0;
			__matrix.ty = ty = 0.0;
		}
		
		/**
		 * @private
		 */
		private function __applyMatrixParam( mt:MatrixParam ):void
		{
			__matrix.a  = a  = mt.m11;
			__matrix.b  = b  = mt.m12;
			__matrix.c  = c  = mt.m21;
			__matrix.d  = d  = mt.m22;
			__matrix.tx = tx = mt.m31;
			__matrix.ty = ty = mt.m32;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 現在の Transform を行う FMatrix2D を示します.
		 */
		public function get matrix():FMatrix2D { return __matrix;  }
		public function set matrix( value:FMatrix2D ):void
		{
			__matrix = value;
			update_transform();
		}
		
		/**
		 * 描画する Graphics を移動します.
		 */
		public function translate( x:Number, y:Number ):void
		{
			__matrix.prependTranslation( x, y );
			update_transform();
		}
		
		/**
		 * 描画する Graphics を拡大/縮小します.
		 * 
		 * @param	x	x のスケールを指定します. xのみが指定された場合、全体のスケールになります.
		 * @param	y	y のスケールを指定します.
		 */
		public function scale( x:Number, y:Number = NaN ):void
		{
			if ( isNaN(y) )
				__matrix.prependScale( x, x );
			else
				__matrix.prependScale( x, y );
			update_transform();
		}
		
		/**
		 * 描画する Graphics を回転します.
		 */
		public function rotate( angle:Number ):void
		{
			__matrix.prependRotation( angle );
			update_transform();
		}
		
		
		/**
		 * 変換 Matrix の行列値を指定します.
		 */
		public function applyMatrix( a_:Number, b_:Number, c_:Number, d_:Number, tx_:Number, ty_:Number ):void
		{
			__matrix.prependMatrix( a_, b_, c_, d_, tx_, ty_ );
			update_transform();
		}
		
		/**
		 * FMatrix2Dの変換を適用します
		 * @private
		 */
		override public function applyMatrix2D( mat:Matrix ):void
		{
			__matrix.prepend( mat );
			update_transform();
		}
		
		/**
		 * 変換 Matrix の行列値を <code>trace</code> します.
		 */
		public function printMatrix():void
		{
			trace( __matrix );
		}
		
		/**
		 * @private
		 */
		private function update_transform():void
		{
			a  = __matrix.a;
			b  = __matrix.b;
			c  = __matrix.c;
			d  = __matrix.d;
			tx = __matrix.tx;
			ty = __matrix.ty;
		}
		
		/**
		 * @private
		 */
		private function get untransformed():Boolean
		{
			return a==1 && b==0 && c==0 && d==1 && tx==0 && ty==0;
		}
		
		//------------------------------------------------------------------------------------------------------------------- 
		
		/**
		 * 現在の Transform で座標を変換し、その X 座標を返します.
		 * @param	x
		 * @param	y
		 */
		public function screenX( x:Number, y:Number ):Number
		{
			return x * a + y * c + tx;
		}
		
		/**
		 * 現在の Transform で座標を変換し、その Y 座標を返します.
		 * @param	x
		 * @param	y
		 */
		public function screenY( x:Number, y:Number ):Number
		{
			return x * b + y * d + ty;
		}
		
		//------------------------------------------------------------------------------------------------------------------- 
		
		/**
		 * 現在の Transform を DisplayObject に適用します.
		 * @param	displayObj
		 * @param	x
		 * @param	y
		 */
		/*
		public function applyTransform( displayObj:DisplayObject, x:Number=0, y:Number=0 ):void
		{
			var mt:Matrix = new Matrix();
			mt.translate( x, y );
			mt.concat( __matrix );
			displayObj.transform.matrix = mt;
		}
		*/
		
		//-------------------------------------------------------------------------------------------------------------------
		// Path
		//-------------------------------------------------------------------------------------------------------------------
		
		//------------------------------------------------------------------------------------------------------------------- Path
		
		/**
		 * @inheritDoc
		 */
		override public function moveTo(x:Number, y:Number, z:Number=0 ):void
		{
			gc.moveTo( x * a + y * c + tx,
					   x * b + y * d + ty );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function lineTo( x:Number, y:Number, z:Number=0 ):void
		{
			gc.lineTo( x * a + y * c + tx,
					   x * b + y * d + ty );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function curveTo( cx:Number, cy:Number, x:Number, y:Number ):void
		{
			gc.curveTo( cx * a + cy * c + tx,
						cx * b + cy * d + ty,
						x * a + y * c + tx,
						x * b + y * d + ty );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			gc.bezierTo( cx0 * a + cy0 * c + tx,
						 cx0 * b + cy0 * d + ty,
						 cx1 * a + cy1 * c + tx,
						 cx1 * b + cy1 * d + ty,
						 x * a + y * c + tx,
						 x * b + y * d + ty );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function splineTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void 
		{
			gc.splineTo( cx0 * a + cy0 * c + tx,
						 cx0 * b + cy0 * d + ty,
						 cx1 * a + cy1 * c + tx,
						 cx1 * b + cy1 * d + ty,
						 x * a + y * c + tx,
						 x * b + y * d + ty );
		}
		
		/**
		 * @inheritDoc
		 */
		/*
		override public function arcCurve( x0:Number, y0:Number, x:Number, y:Number, rx:Number, ry:Number, large_arc_flag:Boolean = false, sweep_flag:Boolean = true, x_axis_rotation:Number = 0):void 
		{
			//invert matrix
			var det:Number = a * d - b * c;
			var ia:Number = d / det;
			var ib:Number = -b / det;
			var ic:Number = -c / det;
			var id:Number =  a / det;
			var __x:Number = gc.__x * ia + gc.__y * ic - tx;
			var __y:Number = gc.__x * ib + gc.__y * id - tx;
			__arcCurve( __x, __y, x, y, rx, ry, large_arc_flag, sweep_flag, x_axis_rotation );
		}
		*/

		override public function point(x:Number, y:Number, z:Number = 0):void 
		{
			gc.point( x * a + y * c + tx,
					  x * b + y * d + ty );
		}
		
		//------------------------------------------------------------------------------------------------------------------- Vertex
		
		/**
		 * @inheritDoc
		 */
		override public function vertex( x:Number, y:Number, u:Number=0, v:Number=0 ):void
		{
			super.vertex( x * a + y * c + tx,
						  x * b + y * d + ty,
						  u, v );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function bezierVertex( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			super.bezierVertex( cx0 * a + cy0 * c + tx,
								cx0 * b + cy0 * d + ty,
								cx1 * a + cy1 * c + tx,
								cx1 * b + cy1 * d + ty,
								x * a + y * c + tx,
								x * b + y * d + ty );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function curveVertex( x:Number, y:Number ):void
		{
			super.curveVertex( x * a + y * c + tx,
							   x * b + y * d + ty );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Shape
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		override public function shape( s:IFShape, x:Number=NaN, y:Number=NaN, w:Number = NaN, h:Number = NaN ):void
		{
			if ( !isNaN(x * y) )
			{
				pushMatrix();
				if ( w>0 && h>0 )
				{
					if( _shape_mode==CENTER )
					{
						x -= w * 0.5;
						y -= h * 0.5;
					}
					else if ( _shape_mode == CORNERS )
					{
						w -= x;
						h -= y;
					}
					translate( x, y );
					scale( w / s.width, h / s.height );
				}
				else if( _shape_mode==CENTER )
				{
					x -= s.width * 0.5;
					y -= s.height * 0.5;
					translate( x, y );
				}
				else
				{
					translate( x, y );
				}
				translate( -s.left, -s.top );
				s.draw(this);
				popMatrix();
			}
			else
			{
				s.draw(this);
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// IMAGE
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override f5internal function _image( img:BitmapData, x:Number, y:Number, w:Number, h:Number, z:Number=0 ):void
		{
			if ( _tint_do )
				gc.beginBitmap( tintImageCache.getTintImage( img, _tint_color ) );
			else
				gc.beginBitmap( img );
			
			gc.drawBitmap( x, y, w, h, __matrix );
			gc.endBitmap();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// GRAPHICS
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override protected function update_fill_matrix():Boolean 
		{
			if ( transformFillMatrix ) {
				_fill_matrix.setMatrix( a, b, c, d, tx, ty );
				return true;
			}else {
				return false;
			}
		}
	}
}

class MatrixParam 
{
	internal var m11:Number;
	internal var m12:Number;
	internal var m21:Number;
	internal var m22:Number;
	internal var m31:Number;
	internal var m32:Number;
	
	public function MatrixParam( a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number ) 
	{
		m11 = a;
		m12 = b;
		m21 = c;
		m22 = d;
		m31 = tx;
		m32 = ty;
	}
}