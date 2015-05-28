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

package frocessing.f3d 
{
	import frocessing.geom.FTransform3D;
	import frocessing.geom.FMatrix3D;
	
	/**
	* Abstract 3D Object
	* 
	* @author nutsu
	* @version 0.3
	* 
	*/
	public class F3DObject extends FTransform3D
	{
		private var _name:String;
		
		protected var m11:Number;
		protected var m12:Number;
		protected var m13:Number;
		protected var m21:Number;
		protected var m22:Number;
		protected var m23:Number;
		protected var m31:Number;
		protected var m32:Number;
		protected var m33:Number;
		protected var m41:Number;
		protected var m42:Number;
		protected var m43:Number;
		
		public var userData:Object;
		
		/**
		 * 
		 */
		public function F3DObject( defaultMatrix:FMatrix3D = null ) 
		{
			super(defaultMatrix);
			userData = { };
		}
		
		/**
		 * 
		 */
		public function get name():String{ return _name;  }
		public function set name( value:String ):void
		{
			_name = value;
		}
		
		/**
		 * 
		 * @param	mtx
		 */
		public function updateTransform( m11_:Number, m12_:Number, m13_:Number,
								         m21_:Number, m22_:Number, m23_:Number,
								         m31_:Number, m32_:Number, m33_:Number,
								         m41_:Number, m42_:Number, m43_:Number ):void
		{
			var mt0:FMatrix3D = matrix;
			m11 = mt0.m11 * m11_ + mt0.m12 * m21_ + mt0.m13 * m31_;
			m12 = mt0.m11 * m12_ + mt0.m12 * m22_ + mt0.m13 * m32_; 
			m13 = mt0.m11 * m13_ + mt0.m12 * m23_ + mt0.m13 * m33_;
			m21 = mt0.m21 * m11_ + mt0.m22 * m21_ + mt0.m23 * m31_; 
			m22 = mt0.m21 * m12_ + mt0.m22 * m22_ + mt0.m23 * m32_; 
			m23 = mt0.m21 * m13_ + mt0.m22 * m23_ + mt0.m23 * m33_;
			m31 = mt0.m31 * m11_ + mt0.m32 * m21_ + mt0.m33 * m31_;
			m32 = mt0.m31 * m12_ + mt0.m32 * m22_ + mt0.m33 * m32_;
			m33 = mt0.m31 * m13_ + mt0.m32 * m23_ + mt0.m33 * m33_;
			m41 = mt0.m41 * m11_ + mt0.m42 * m21_ + mt0.m43 * m31_ + m41_;
			m42 = mt0.m41 * m12_ + mt0.m42 * m22_ + mt0.m43 * m32_ + m42_;
			m43 = mt0.m41 * m13_ + mt0.m42 * m23_ + mt0.m43 * m33_ + m43_;
		}
		
		/**
		 * 
		 * @param	g
		 * @param	fillcolor
		 * @param	fillalpha
		 */
		public function draw( g:F3DGraphics ):void
		{
			;
		}
	}
	
}