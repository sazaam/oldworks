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

package frocessing.core
{
	
	import flash.display.Graphics;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import frocessing.geom.FMatrix2D;
	
	/**
	* F5Graphics2D は、F5Graphics に Processing の Transform メソッドを実装したクラスです.
	* 
	* @author nutsu
	* @version 0.2
	*/
	public class F5Graphics2D extends F5Graphics {
		
		// Transfrom
		private var _matrix:FMatrix2D;
		private var _matrix_tmp:Array;
		private var a:Number;
		private var b:Number;
		private var c:Number;
		private var d:Number;
		private var tx:Number;
		private var ty:Number;
		
		//
		public var transformFillMatrix:Boolean = true;
		
		/**
		 * 新しい F5Graphics2D クラスのインスタンスを生成します.
		 * 
		 * @param	gc	描画対象となる Graphics を指定します
		 */
		public function F5Graphics2D( gc:Graphics )
		{
			super(gc);
			_matrix        = new FMatrix2D();
			_matrix_tmp    = [];
			resetMatrix();
		}
		
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
		
		//--------------------------------------------------------------------------------------------------- TRANSFORM
		
		/**
		 * 現在の Transform を行う FMatrix2D を示します.
		 */
		public function get matrix():FMatrix2D { return _matrix;  }
		public function set matrix( value:FMatrix2D ):void
		{
			_matrix = value;
			update_transform();
		}
		
		/**
		 * 描画する Graphics を移動します.
		 */
		public function translate( x:Number, y:Number ):void
		{
			_matrix.prependTranslation( x, y );
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
				_matrix.prependScale( x, x );
			else
				_matrix.prependScale( x, y );
			update_transform();
		}
		
		/**
		 * 描画する Graphics を回転します.
		 */
		public function rotate( angle:Number ):void
		{
			_matrix.prependRotation( angle );
			update_transform();
		}
		
		/**
		 * 現在の 変換 Matrix を一時的に保持します.
		 */
		public function pushMatrix():void
		{
			_matrix_tmp.push( new MatrixParam( a, b, c, d, tx, ty ) );
		}
		
		/**
		 * 前回、pushMatrix() で保持した 変換 Matrix を復元します.
		 */
		public function popMatrix():void
		{
			applyMatrixParam( _matrix_tmp.pop() );
		}
		
		/**
		 * 変換 Matrix をリセットします.
		 */
		public function resetMatrix():void
		{
			_matrix.a  = a  = 1.0;
			_matrix.b  = b  = 0.0;
			_matrix.c  = c  = 0.0;
			_matrix.d  = d  = 1.0;
			_matrix.tx = tx = 0.0;
			_matrix.ty = ty = 0.0;
		}
		
		/**
		 * 変換 Matrix の行列値を指定します.
		 */
		public function applyMatrix( a_:Number, b_:Number, c_:Number, d_:Number, tx_:Number, ty_:Number ):void
		{
			_matrix.a  = a  = a_;
			_matrix.b  = b  = b_;
			_matrix.c  = c  = c_;
			_matrix.d  = d  = d_;
			_matrix.tx = tx = tx_;
			_matrix.ty = ty = ty_;
		}
		
		/**
		 * @private
		 */
		private function applyMatrixParam( mt:MatrixParam ):void
		{
			_matrix.a  = a  = mt.m11;
			_matrix.b  = b  = mt.m12;
			_matrix.c  = c  = mt.m21;
			_matrix.d  = d  = mt.m22;
			_matrix.tx = tx = mt.m31;
			_matrix.ty = ty = mt.m32;
		}
		
		/**
		 * 変換 Matrix の行列値を <code>trace</code> します.
		 */
		public function printMatrix():void
		{
			trace( _matrix );
		}
		
		/**
		 * @private
		 */
		private function update_transform():void
		{
			a  = _matrix.a;
			b  = _matrix.b;
			c  = _matrix.c;
			d  = _matrix.d;
			tx = _matrix.tx;
			ty = _matrix.ty;
		}
		
		/**
		 * @private
		 */
		private function get untransformed():Boolean
		{
			return a==1 && b==0 && c==0 && d==1 && tx==0 && ty==0;
		}
		
		//--------------------------------------------------------------------------------------------------- 
		
		/**
		 * 現在の Transform を DisplayObject に適用します.
		 * @param	displayObj
		 * @param	x
		 * @param	y
		 */
		public function applyTransform( displayObj:DisplayObject, x:Number=0, y:Number=0 ):void
		{
			var mt:Matrix = new Matrix();
			mt.translate( x, y );
			mt.concat( _matrix );
			displayObj.transform.matrix = mt;
		}
		
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
		
		//--------------------------------------------------------------------------------------------------- VERTEX
		
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
		override public function bezierVertex( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x1:Number, y1:Number ):void
		{
			super.bezierVertex( cx0 * a + cy0 * c + tx,
								cx0 * b + cy0 * d + ty,
								cx1 * a + cy1 * c + tx,
								cx1 * b + cy1 * d + ty,
								x1 * a + y1 * c + tx,
								x1 * b + y1 * d + ty );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function curveVertex( x:Number, y:Number ):void
		{
			super.curveVertex( x * a + y * c + tx,
							   x * b + y * d + ty );
		}
		
		//--------------------------------------------------------------------------------------------------- CORE
		
		/**
		 * @inheritDoc
		 */
		override public function rlineTo( x:Number, y:Number ):void
		{
			super.rlineTo( x * a + y * c,
						   x * b + y * d );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function scurveTo( x:Number, y:Number ):void
		{
			super.scurveTo( x * a + y * c + tx,
							x * b + y * d + ty );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function sbezierTo( cx1:Number, cy1:Number, x1:Number, y1:Number ):void
		{
			super.sbezierTo( cx1 * a + cy1 * c + tx,
							 cx1 * b + cy1 * d + ty,
							 x1 * a + y1 * c + tx,
							 x1 * b + y1 * d + ty );
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function splineInit( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number ):void
		{
			super.splineInit( x0 * a + y0 * c + tx,
							  x0 * b + y0 * d + ty,
							  x1 * a + y1 * c + tx,
							  x1 * b + y1 * d + ty,
							  x2 * a + y2 * c + tx,
							  x2 * b + y2 * d + ty );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function splineTo( x:Number, y:Number ):void
		{
			super.splineTo( x * a + y * c + tx,
							x * b + y * d + ty );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x1:Number, y1:Number ):void
		{
			super.bezierTo( cx0 * a + cy0 * c + tx,
							cx0 * b + cy0 * d + ty,
							cx1 * a + cy1 * c + tx,
							cx1 * b + cy1 * d + ty,
							x1 * a + y1 * c + tx,
							x1 * b + y1 * d + ty );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function moveTo(x:Number, y:Number):void
		{
			super.moveTo( x * a + y * c + tx,
						  x * b + y * d + ty );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function lineTo( x:Number, y:Number ):void
		{
			super.lineTo( x * a + y * c + tx,
						  x * b + y * d + ty );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function curveTo( cx:Number, cy:Number, x:Number, y:Number ):void
		{
			super.curveTo( cx * a + cy * c + tx,
						   cx * b + cy * d + ty,
						   x * a + y * c + tx,
						   x * b + y * d + ty );
		}
		
		//--------------------------------------------------------------------------------------------------- BITMAP
		
		/**
		 * @inheritDoc
		 */
		override public function drawBitmapRect( bitmapdata:BitmapData, x:Number, y:Number, w:Number, h:Number ):void
		{
			moveTo( x, y );
			_bmpGC.beginBitmap( bitmapdata );
			_bmpGC.drawRect( x, y, w, h, _matrix );
			_bmpGC.endBitmap();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function drawBitmapTriangle( bitmapdata:BitmapData,
											x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number,
											u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number ):void
		{
			super.drawBitmapTriangle( bitmapdata,
									  screenX( x0, y0 ), screenY( x0, y0 ),
									  screenX( x1, y1 ), screenY( x1, y1 ),
									  screenX( x2, y2 ), screenY( x2, y2 ),
									  u0, v0, u1, v1, u2, v2 );
		}
		
		/**
		 * @@inheritDoc
		 */
		override public function drawBitmapQuad( bitmapdata:BitmapData,
										x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number,
										u0:Number=0, v0:Number=0, u1:Number=1, v1:Number=0, u2:Number=1, v2:Number=1, u3:Number=0, v3:Number=1 ):void
		{
			super.drawBitmapQuad( bitmapdata,
								  screenX( x0, y0 ), screenY( x0, y0 ),
								  screenX( x1, y1 ), screenY( x1, y1 ),
								  screenX( x2, y2 ), screenY( x2, y2 ),
								  screenX( x3, y3 ), screenY( x3, y3 ),
								  u0, v0, u1, v1, u2, v2, u3, v3 );
		}
		
		//--------------------------------------------------------------------------------------------------- ATTRIBUTES
		
		/**
		 * @inheritDoc
		 */
		override public function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix_:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0.0):void 
		{
			if ( matrix_ )
			{
				matrix_.concat( _matrix );
				_gc.lineGradientStyle(type, colors, alphas, ratios, matrix_, spreadMethod, interpolationMethod, focalPointRatio);
			}
			else
			{
				_gc.lineGradientStyle(type, colors, alphas, ratios, _matrix, spreadMethod, interpolationMethod, focalPointRatio);
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function beginBitmapFill(bitmap:BitmapData,matrix_:Matrix=null,repeat:Boolean=true,smooth:Boolean=false):void
		{
			if ( transformFillMatrix )
			{
				if ( matrix_ )
					_gc.beginBitmapFill( bitmap, _matrix.preProduct( matrix_ ), repeat, smooth );
				else
					_gc.beginBitmapFill( bitmap, _matrix, repeat, smooth );
			}
			else
			{
				_gc.beginBitmapFill( bitmap, matrix_, repeat, smooth );
			}
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function beginGradientFill(type:String, color:Array, alphas:Array, ratios:Array, matrix_:Matrix=null, spreadMethod:String="pad", interpolationMethod:String="rgb",focalPointRation:Number=0.0):void
		{
			if ( transformFillMatrix )
			{
				if ( matrix_ )
					_gc.beginGradientFill( type, color, alphas, ratios, _matrix.preProduct( matrix_ ), spreadMethod, interpolationMethod, focalPointRation );
				else
					_gc.beginGradientFill( type, color, alphas, ratios, _matrix.preProduct(default_gradient_matrix), spreadMethod, interpolationMethod, focalPointRation );
			}
			else
			{
				_gc.beginGradientFill( type, color, alphas, ratios, matrix_, spreadMethod, interpolationMethod, focalPointRation );
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
	
	function MatrixParam( a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number ) {
		m11 = a;
		m12 = b;
		m21 = c;
		m22 = d;
		m31 = tx;
		m32 = ty;
	}
}