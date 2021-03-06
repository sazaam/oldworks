﻿// --------------------------------------------------------------------------
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

package frocessing.geom {

	/**
	* FVector.
	* 
	* <p>※将来的に再構成されなくなる予定です</p>
	* 
	* @author nutsu
	* @version 0.5
	*/
	public class FVector extends FNumber3D
	{
		/**
		 * Cunstoractor
		 */
		public function FVector( x_:Number , y_:Number , z_:Number )
		{
			super( x_, y_, z_ );
		}
		
		/**
		* length of vector
		*/
		public function get length():Number
		{
			return Math.sqrt( x*x + y*y + z*z );
		}
		
		/**
		* normalized vector copy;
		*/
		public function get normal():FVector
		{
			var v:FVector = clone();
			v.normalize(1.0);
			return v;
		}
		
		/**
		* clone
		*/
		public function clone():FVector
		{
			return new FVector(x,y,z);
		}
		
		/**
		* 加算
		*/
		public function add( v:FVector ):FVector
		{
			return new FVector( x+v.x , y+v.y , z+v.z );
		}
		
		/**
		* 減算
		*/
		public function subtract( v:FVector ):FVector
		{
			return new FVector( x-v.x , y-v.y , z-v.z );
		}
		
		/**
		* 乗算
		*/
		public function multi( v:FVector ):FVector
		{
			return new FVector( x*v.x , y*v.y , z*v.z );
		}
		
		/**
		* 除算
		*/
		public function divid( v:FVector ):FVector
		{
			return new FVector( x/v.x , y/v.y , z/v.z );
		}
		
		/**
		* Offset
		*/
		public function offset( x_:Number, y_:Number, z_:Number ):void
		{
			x += x_;
			y += y_;
			z += z_;
		}
		
		/**
		* Scale
		*/
		public function scale( x_:Number, y_:Number, z_:Number ):void
		{
			x *= x_;
			y *= y_;
			z *= z_;
		}
		
		/**
		* Reverse
		*/
		public function reverse():void
		{
			x = -x;
			y = -y;
			z = -z;
		}
		
		/**
		* Normalize
		* @param	target length
		*/
		public function normalize(len:Number = 1.0):void
		{
			var s:Number = len / length;
			x *= s;
			y *= s;
			z *= s;
		}
		
		/**
		* Equals
		*/
		public function equals( v:FVector ):Boolean
		{
			return ( x==v.x && y==v.y && z==v.z );
		}
		
		/**
		 * toString
		 */
		public function toString():String
		{
			return "[FVector x=" + x + " y=" + y + " z=" + z + "]";
		}

		//--------------------------------------------------------------------------------------------------- STATIC
		
		/**
		* 距離 
		* @param	Vector 0
		* @param	Vector 1
		* @return	Distance
		*/
		public static function distance( v0:FVector , v1:FVector ):Number
		{
			return (v1.subtract( v0 )).length;
		}
		
		/**
		* 距離ノルムL1 
		* @param	Vector 0
		* @param	Vector 1
		* @return	Norm L1
		*/
		public static function normL1( v0:FVector , v1:FVector ):Number
		{
			return ( Math.abs( v1.x-v0.x ) + Math.abs( v1.y-v0.y ) + Math.abs( v1.z-v0.z )  );
		}
		
		/**
		* 内積
		* @param	Vector 0
		* @param	Vector 1
		* @return	dot product
		*/
		public static function dot( v0:FVector , v1:FVector ):Number
		{
			return ( v0.x*v1.x + v0.y*v1.y + v0.z*v1.z );
		}
		
		/**
		* 外積
		* @param	Vector 0
		* @param	Vector 1
		* @return	cross product
		*/
		public static function cross( v0:FVector , v1:FVector ):FVector
		{
			return new FVector( v0.y*v1.z - v0.z*v1.y , v0.z*v1.x - v0.x*v1.z , v0.x*v1.y - v0.y*v1.x);
		}
		
		/**
		* Cos
		*/
		public static function cos( v0:FVector , v1:FVector ):Number
		{
			return ( FVector.dot( v0 , v1 )/(v0.length * v1.length) );
		}
		/**
		* Sin
		*/
		public static function sin( v0:FVector , v1:FVector ):Number
		{
			return ( (FVector.cross( v0 , v1 )).length/(v0.length * v1.length) );
		}
		/**
		* Angle
		*/
		public static function angle( v0:FVector , v1:FVector ):Number
		{
			return Math.acos( FVector.cos( v0 , v1 ) );
		}
		
		/**
		* Interpolate
		* @param	Vector0
		* @param	Vector1
		* @param	f
		* @return	Vector
		*/
		public static function interpolate( v0:FVector , v1:FVector , f:Number):FVector
		{
			var v:FVector = v1.subtract( v0 );
			v.normalize( v.length * f );
			return v.add( v0 );
		}
		
		/**
		* Random Vector
		* @param	length
		* @return	Vector
		*/
		public static function randomVector(len:Number = 1.0):FVector
		{
			var v:FVector = new FVector( Math.random()-0.5 , Math.random()-0.5 , Math.random()-0.5 );
			v.normalize(len);
			return v;
		}
	}
	
}
