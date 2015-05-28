// --------------------------------------------------------------------------
// Project Frocessing
// ActionScript 3.0 drawing library like Processing.
// --------------------------------------------------------------------------
//
// Licensed under the MIT License
//
// Frocessing drawing library
// Copyright (C) 2008  TAKANAWA Tomoaki (http://nutsu.com) and
//					   Spark project (www.libspark.org)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

package frocessing.geom
{

	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	* FMatrix2D クラスは flash.geom.Matrix の拡張クラスです.
	* 
	* @author nutsu
	* @version 0.2
	*/
	public class FMatrix2D extends Matrix{
		
		/**
		 a , b , 0
		 c , d , 0
		 tx, ty, 1
		 */
	
		/**
		 * 新しく FMatrix2D インスタンスを生成します.
		 */
		public function FMatrix2D(a_:Number=1.0,  b_:Number=0.0,
								  c_:Number=0.0,  d_:Number=1.0,
								  tx_:Number=0.0, ty_:Number=0.0 )
		{
			super( a_, b_, c_, d_, tx_, ty_ );		
		}
		
		/**
		 * 行列値を設定します.
		 */
		public function setMatrix( a_:Number, b_:Number, c_:Number, d_:Number, tx_:Number, ty_:Number ):void
		{
			a = a_; b = b_;
			c = c_; d = d_;
			tx = tx_; ty = ty_;
		}
		
		/**
		* クローンを生成します.
		*/
		override public function clone():Matrix
		{
			return new FMatrix2D( a, b, c, d, tx, ty );
		}
		
		/**
		 * 同じ行列かチェックします.
		 */
		public function equals(m:Matrix):Boolean
		{
			return ( a==m.a   && b==m.b && 
					 c==m.c   && d==m.d && 
					 tx==m.tx && ty==m.ty );
		}
		
		//---------------------------------------------------------------------------------------------------
		
		
		/**
		 * 
		 * @param	mtx
		 */
		public function prepend( mtx:Matrix ):void
		{
			var n11:Number = mtx.a * a + mtx.b * c;
			var n12:Number = mtx.a * b + mtx.b * d;
			var n21:Number = mtx.c * a + mtx.d * c; 
			var n22:Number = mtx.c * b + mtx.d * d;
			var n31:Number = mtx.tx * a + mtx.ty * c + tx; 
			var n32:Number = mtx.tx * b + mtx.ty * d + ty;
			a  = n11; b  = n12;
			c  = n21; d  = n22;
			tx = n31; ty = n32;
		}
		
		/**
		 * 現在の行列の前に、指定の行列値を concat します.
		 * @param	t11	a
		 * @param	t12	b
		 * @param	t21	c
		 * @param	t22	d
		 * @param	t31	tx
		 * @param	t32	ty
		 */
		public function prependMatrix( t11:Number, t12:Number,
									   t21:Number, t22:Number,
									   t31:Number, t32:Number ):void
		{
			var n11:Number = t11 * a + t12 * c;
			var n12:Number = t11 * b + t12 * d;
			var n21:Number = t21 * a + t22 * c; 
			var n22:Number = t21 * b + t22 * d;
			var n31:Number = t31 * a + t32 * c + tx; 
			var n32:Number = t31 * b + t32 * d + ty;
			a  = n11; b  = n12;
			c  = n21; d  = n22;
			tx = n31; ty = n32;
		}
		
		/**
		 * 
		 * @param	scaleX
		 * @param	scaleY
		 */
		public function prependScale( sx:Number, sy:Number ):void
		{
			//sx,0,0,sx,0,0
			a *= sx;
			b *= sx;
			c *= sy;
			d *= sy;
		}
		
		/**
		 * 
		 * @param	x
		 * @param	y
		 */
		public function prependTranslation( x:Number, y:Number ):void
		{
			//1,0,0,1,x,y
			tx += x * a + y * c;
			ty += x * b + y * d;
		}
		
		/**
		 * 
		 * @param	angle
		 */
		public function prependRotation( angle:Number ):void
		{
			//c, s, -s, c, 0, 0
			var sin:Number = Math.sin(angle);
			var cos:Number = Math.cos(angle);
			var n11:Number = cos * a + sin * c;
			var n12:Number = cos * b + sin * d;
			var n21:Number = -sin * a + cos * c;
			var n22:Number = -sin * b + cos * d;
			a  = n11; b  = n12;
			c  = n21; d  = n22;
		}
		
		/**
		 * 
		 * @param	mtx
		 */
		override public function concat( mtx:Matrix ):void
		{
			var n11:Number = a * mtx.a + b * mtx.c;
			var n12:Number = a * mtx.b + b * mtx.d;
			var n21:Number = c * mtx.a + d * mtx.c; 
			var n22:Number = c * mtx.b + d * mtx.d;
			var n31:Number = tx * mtx.a + ty * mtx.c + mtx.tx; 
			var n32:Number = tx * mtx.b + ty * mtx.d + mtx.ty;
			a  = n11; b  = n12;
			c  = n21; d  = n22;
			tx = n31; ty = n32;
		}
		
		/**
		 * 現在の行列に、指定の行列値を concat します.
		 * @param	t11	a
		 * @param	t12	b
		 * @param	t21	c
		 * @param	t22	d
		 * @param	t31	tx
		 * @param	t32	ty
		 */
		public function appendMatrix( t11:Number, t12:Number,
									  t21:Number, t22:Number,
									  t31:Number, t32:Number ):void
		{
			var n11:Number = a * t11 + b * t21;
			var n12:Number = a * t12 + b * t22;
			var n21:Number = c * t11 + d * t21; 
			var n22:Number = c * t12 + d * t22;
			var n31:Number = tx * t11 + ty * t21 + t31; 
			var n32:Number = tx * t12 + ty * t22 + t32;
			a  = n11; b  = n12;
			c  = n21; d  = n22;
			tx = n31; ty = n32;
		}
		
		/**
		 * append scale
		 * @param	scaleX
		 * @param	scaleY
		 */
		override public function scale( sx:Number, sy:Number ):void
		{
			//sx,0,0,sx,0,0
			a  *= sx;
			b  *= sy;
			c  *= sx;
			d  *= sy;
			tx *= sx;
			ty *= sy;
		}
		
		/**
		 * append translation
		 * @param	x
		 * @param	y
		 */
		override public function translate( x:Number, y:Number ):void
		{
			//1,0,0,1,x,y
			tx += x;
			ty += y;
		}
		
		/**
		 * append rotation
		 * @param	angle
		 */
		override public function rotate( angle:Number ):void
		{
			//c, s, -s, c, 0, 0
			var sin:Number = Math.sin(angle);
			var cos:Number = Math.cos(angle);
			var n11:Number = a * cos - b * sin;
			var n12:Number = a * sin + b * cos;
			var n21:Number = c * cos - d * sin; 
			var n22:Number = c * sin + d * cos;
			var n31:Number = tx * cos - ty * sin; 
			var n32:Number = tx * sin + ty * cos;
			a  = n11; b  = n12;
			c  = n21; d  = n22;
			tx = n31; ty = n32;
		}
		
		
		//---------------------------------------------------------------------------------------------------
		
		/**
		* 積の結果を、新しい FMatrix2D インスタンスで返します.
		*/
		public function product( mtx:Matrix ):FMatrix2D
		{
			return new FMatrix2D(
				a*mtx.a + b*mtx.c,
				a*mtx.b + b*mtx.d,
				c*mtx.a + d*mtx.c, 
				c*mtx.b + d*mtx.d,
				tx*mtx.a + ty*mtx.c + mtx.tx, 
				tx*mtx.b + ty*mtx.d + mtx.ty );
		}
		
		/**
		 * 積の結果を、新しい FMatrix2D インスタンスで返します.
		 */
		public function preProduct( mtx:Matrix ):FMatrix2D
		{			
			return new FMatrix2D(
				mtx.a * a + mtx.b * c,
				mtx.a * b + mtx.b * d,
				mtx.c * a + mtx.d * c, 
				mtx.c * b + mtx.d * d,
				mtx.tx * a + mtx.ty * c + tx, 
				mtx.tx * b + mtx.ty * d + ty );
		}
		
		/**
		* 加算の結果を、新しい FMatrix2D インスタンスで返します.
		*/
		public function add( mtx:Matrix ):FMatrix2D
		{
			return new FMatrix2D(
				a+mtx.a, b+mtx.b,
				c+mtx.c, d+mtx.d,
				tx+mtx.tx, ty+mtx.ty );
		} 
		
		/**
		* 減算の結果を、新しい FMatrix2D インスタンスで返します.
		*/
		public function subtract(mtx:Matrix):FMatrix2D 
		{
			return new FMatrix2D(
				a-mtx.a, b-mtx.b,
				c-mtx.c, d-mtx.d,
				tx-mtx.tx, ty-mtx.ty );
		}
		
		/**
		 * 乗算の結果を、新しい FMatrix2D インスタンスで返します.
		 */
		public function multi(m:Number):FMatrix2D
		{
			return new FMatrix2D(
				a*m, b*m,  
				c*m, d*m,  
				tx*m, ty*m );
		}
		
		/**
		* 行列値をオフセットします.
		*/
		public function offset(mtx:Matrix):void
		{
			a += mtx.a; b += mtx.b;
			c += mtx.c; d += mtx.d;
			tx += mtx.tx; ty += mtx.ty;
		}
		
		//--------------------------------------------------------------------------------------------------- UV
		
		/**
		 * UV値から任意の三角形に座標を移す変換を設定します. 
		 * 
		 * この変換により、画像内の任意の区画(Triangle)を、任意の座標で描画する Matrix を設定できます.
		 * 
		 * <listing>
		 * var gc        :GraphicsEx = new GraphicsEx( graphics );
		 * var bitmapdata:BitmapData = new AnyBitmapData();
		 * var matrix    :FMatrix2D  = new FMatrix2D();
		 * 
		 * //UVと座標を設定します
		 * matrix.createUVBox( 100, 100, 150, 80, 120, 200, 0.5, 0.5, 1.0, 0.5, 1.0, 0.5, bitmapdata.width, bitmapdata.height );
		 * 
		 * gc.beingBitmapFill( bitmapdata, matrix );
		 * gc.drawTriangle( 100, 100, 150, 80, 120, 200 );
		 * gc.endFill();
		 * </listing>
		 * 
		 * UV値を正規化された値ではなく実際の座標値で指定する場合、sx, sy の指定は必要ありません.
		 */
		public function createUVBox( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number,
									 u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number,
									 sx:Number=1, sy:Number=1 ):void
		{
			//uv transform
			u0 *= sx;
			v0 *= sy;
			var a0:Number = sx*u1 - u0;
			var b0:Number = sy*v1 - v0;
			var c0:Number = sx*u2 - u0;
			var d0:Number = sy*v2 - v0;
			var det0:Number = a0 * d0 - b0 * c0;
			if ( det0 == 0 )
			{
				if ( a0 == 0 && b0 == 0 )
					a0 = 1;
				else if ( c0 == 0 && d0 == 0 )
					d0 = 1;
				else if( a0 ==0 && c0==0 )
					c0 += 1;
				else
					d0 += 1;
				det0 = 	a0 * d0 - b0 * c0;
			}
			//invert matrix
			a  =  d0 / det0;
			b  = -b0 / det0;
			c  = -c0 / det0;
			d  =  a0 / det0;
			tx = ( c0 * v0 - d0 * u0 ) / det0;
			ty = ( b0 * u0 - a0 * v0 ) / det0;
			//apply view transform
			appendMatrix( x1 - x0, y1 - y0, x2 - x0, y2 - y0, x0, y0 );
		}
		
		//---------------------------------------------------------------------------------------------------
		
		/**
		* Scale変換行列
		* @param	scaleX
		* @param	scaleY
		* @return	
		*/
		public static function scaleMatrix( sx:Number = 1.0, sy:Number = 1.0 ):FMatrix2D
		{
			return new FMatrix2D( sx, 0, 0, sy, 0, 0 );
		}
		
		/**
		* 移動変換行列
		* @param	translateX
		* @param	translateY
		* @return
		*/
		public static function translateMatrix( tx:Number, ty:Number ):FMatrix2D
		{
			return new FMatrix2D( 1, 0, 0, 1, tx, ty );
		}
		
		/**
		* 回転行列
		* @param	radian
		* @return	FMatrix2D
		*/
		public static function rotateMatrix( a:Number ):FMatrix2D
		{
			var s:Number = Math.sin(a);
			var c:Number = Math.cos(a);
			return new FMatrix2D( c, s, -s, c, 0, 0 );
		}
		
		//---------------------------------------------------------------------------------------------------
		
		/**
		* toString
		* @return	String
		*/
		override public function toString():String
		{
			return "[FMatrix2D ("+a+","+b+")("+c+","+d+")("+tx+","+ty+")]";
		}
	}
	
}