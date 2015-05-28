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

package frocessing.geom {

	/**
	* FVec3D
	* 
	* @author nutsu
	* @version 0.2.1
	*/
	public class FVec3D extends FNumber3D
	{
		/**
		 * Cunstoractor
		 */
		public function FVec3D( x_:Number , y_:Number , z_:Number )
		{
			super( x_, y_, z_ );
		}
		
		/**
		* length of vector
		*/
		public function get length():Number{
			return Math.sqrt( x*x + y*y + z*z );
		}
		
		/**
		* normalized vector copy;
		*/
		public function get normal():FVec3D{
			var v:FVec3D = clone();
			v.normalize(1.0);
			return v;
		}
		
		/**
		* clone
		*/
		public function clone():FVec3D{
			return new FVec3D(x,y,z);
		}
		
		/**
		* 加算
		*/
		public function add( v:FVec3D ):FVec3D{
			return new FVec3D( x+v.x , y+v.y , z+v.z );
		}
		
		/**
		* 減算
		*/
		public function subtract( v:FVec3D ):FVec3D{
			return new FVec3D( x-v.x , y-v.y , z-v.z );
		}
		
		/**
		* 乗算
		*/
		public function multi( v:FVec3D ):FVec3D{
			return new FVec3D( x*v.x , y*v.y , z*v.z );
		}
		
		/**
		* 除算
		*/
		public function divid( v:FVec3D ):FVec3D{
			return new FVec3D( x/v.x , y/v.y , z/v.z );
		}
		
		/**
		* Offset
		*/
		public function offset( x_:Number, y_:Number, z_:Number ):void{
			x += x_;
			y += y_;
			z += z_;
		}
		
		/**
		* Scale
		*/
		public function scale( x_:Number, y_:Number, z_:Number ):void{
			x *= x_;
			y *= y_;
			z *= z_;
		}
		
		/**
		* Reverse
		*/
		public function reverse():void{
			x = -x;
			y = -y;
			z = -z;
		}
		
		/**
		* Normalize
		* @param	target length
		*/
		public function normalize(len:Number=1.0):void{
			var s:Number = len / length;
			x *= s;
			y *= s;
			z *= s;
		}
		
		/**
		* Equals
		*/
		public function equals( v:FVec3D ):Boolean{
			return ( x==v.x && y==v.y && z==v.z );
		}
		
		/**
		 * toString
		 */
		public function toString():String{
			return "[FVec3D x=" + x + " y=" + y + " z=" + z + "]";
		}

		//--------------------------------------------------------------------------------------------------- STATIC
		
		/**
		* 距離 
		* @param	Vector 0
		* @param	Vector 1
		* @return	Distance
		*/
		public static function distance( v0:FVec3D , v1:FVec3D ):Number{
			return (v1.subtract( v0 )).length;
			
		}
		
		/**
		* 距離ノルムL1 
		* @param	Vector 0
		* @param	Vector 1
		* @return	Norm L1
		*/
		public static function normL1( v0:FVec3D , v1:FVec3D ):Number{
				return ( Math.abs( v1.x-v0.x ) + Math.abs( v1.y-v0.y ) + Math.abs( v1.z-v0.z )  );
		}
		
		/**
		* 内積
		* @param	Vector 0
		* @param	Vector 1
		* @return	dot product
		*/
		public static function dot( v0:FVec3D , v1:FVec3D ):Number{
			return ( v0.x*v1.x + v0.y*v1.y + v0.z*v1.z );
		}
		
		/**
		* 外積
		* @param	Vector 0
		* @param	Vector 1
		* @return	cross product
		*/
		public static function cross( v0:FVec3D , v1:FVec3D ):FVec3D{
			return new FVec3D( v0.y*v1.z - v0.z*v1.y , v0.z*v1.x - v0.x*v1.z , v0.x*v1.y - v0.y*v1.x);
		}
		
		/**
		* Cos
		*/
		public static function cos( v0:FVec3D , v1:FVec3D ):Number{
			return ( FVec3D.dot( v0 , v1 )/(v0.length * v1.length) );
		}
		/**
		* Sin
		*/
		public static function sin( v0:FVec3D , v1:FVec3D ):Number{
			return ( (FVec3D.cross( v0 , v1 )).length/(v0.length * v1.length) );
		}
		/**
		* Angle
		*/
		public static function angle( v0:FVec3D , v1:FVec3D ):Number{
			return Math.acos( FVec3D.cos( v0 , v1 ) );
		}
		
		/**
		* Interpolate
		* @param	Vector0
		* @param	Vector1
		* @param	f
		* @return	Vector
		*/
		public static function interpolate( v0:FVec3D , v1:FVec3D , f:Number):FVec3D{
			var v:FVec3D = v1.subtract( v0 );
			v.normalize( v.length * f );
			return v.add( v0 );
		}
		
		/**
		* Random Vector
		* @param	length
		* @return	Vector
		*/
		public static function randomVector(len:Number=1.0):FVec3D{
			var v:FVec3D = new FVec3D( Math.random()-0.5 , Math.random()-0.5 , Math.random()-0.5 );
			v.normalize(len);
			return v;
		}
	}
	
}
