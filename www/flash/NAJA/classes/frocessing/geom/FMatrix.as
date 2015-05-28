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

package frocessing.geom 
{
	import flash.geom.Matrix;
	
	/**
	 * re implements matrix.
	 * 
	 * @author nutsu
	 * @version 0.5.8
	 */
	public class FMatrix extends Matrix
	{
		/**
		 a , b , 0
		 c , d , 0
		 tx, ty, 1
		 */
		 
		
		public function FMatrix( a:Number=1.0,  b:Number=0.0,
								 c:Number=0.0,  d:Number=1.0,
								 tx:Number=0.0, ty:Number=0.0 ) 
		{
			super( a, b, c, d, tx, ty );
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
		 * append scale.
		 * @param	sx	scaleX
		 * @param	sy	scaleY
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
		 * append translate.
		 * @param	x	translate x
		 * @param	y	translate y
		 */
		override public function translate( x:Number, y:Number ):void
		{
			//1,0,0,1,x,y
			tx += x;
			ty += y;
		}
		
		/**
		 * append rotate.
		 * @param	angle	rotate radian
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
		
		/**
		 * append matrix.
		 * @param	mtx		matrix
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
		 * append matrix.
		 * @param	t11		a
		 * @param	t12		b
		 * @param	t21		c
		 * @param	t22		d
		 * @param	t31		tx
		 * @param	t32		ty
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
	}
	
}