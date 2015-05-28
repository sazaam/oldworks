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

package frocessing.f3d.models 
{
	
	import frocessing.geom.FNumber3D;
	import frocessing.f3d.F3DModel;
	import frocessing.f3d.materials.F3DColorSetMaterial;
	import frocessing.f3d.materials.F3DBmpSetMaterial;
	import flash.display.BitmapData;
	
	/**
	* 3D Primitive Cube
	* 
	* @author nutsu
	* @version 0.2.6
	* 
	*/
	public class F3DCube extends F3DModel
	{
		public static const FRONT :int = 0;
		public static const RIGHT :int = 1;
		public static const BACK  :int = 2;
		public static const LEFT  :int = 3;
		public static const TOP   :int = 4;
		public static const BOTTOM:int = 5;
		
		/**
		 * 
		 * @param	width
		 * @param	height
		 * @param	depth
		 * @param	segment
		 * @param	segmentH
		 * @param	segmentD
		 */
		public function F3DCube( width:Number, height:Number=NaN, depth:Number=NaN, segment:uint=1, segmentH:uint=1, segmentD:uint=1  ) 
		{
			super();
			if ( isNaN(height) )
				height = width;
			
			if ( isNaN(depth) )
				depth = width;
			
			if ( segment < 1 )
				segment = 1;
			
			var alen:int = arguments.length;
			if ( alen < 5 )
				segmentH = segmentD = segment;
			else if ( alen < 6 )
				segmentD = segment;
			
			initModel( width, height, depth, segment, segmentH, segmentD );
		}
		
		//--------------------------------------------------------------------------------------------------- MATERIAL
		
		/**
		 * 
		 * @param	front
		 * @param	right
		 * @param	back
		 * @param	left
		 * @param	top
		 * @param	bottom
		 */
		public function setColors( front:uint, right:uint, back:uint, left:uint, top:uint, bottom:uint ):void
		{
			_material = new F3DColorSetMaterial( front, right, back, left, top, bottom );
		}
		
		/**
		 * 
		 * @param	front
		 * @param	right
		 * @param	back
		 * @param	left
		 * @param	top
		 * @param	bottom
		 */
		public function setTextures( front:BitmapData, right:BitmapData, back:BitmapData, left:BitmapData, top:BitmapData, bottom:BitmapData ):void
		{
			_material = new F3DBmpSetMaterial( front, right, back, left, top, bottom );
		}
		
		//--------------------------------------------------------------------------------------------------- INIT
		/**
		 * @private
		 */
		public function initModel( w:Number, h:Number, d:Number, sW:uint, sH:uint, sD:uint ):void
		{			
			_vertices = [];
			faces     = [];
			uv		  = [];
			faceSet   = [];
			uvSet     = [];
			
			//
			var x0:Number = - w * 0.5;
			var y0:Number = - h * 0.5;
			var z0:Number =   d * 0.5;
			var dw:Number = w / sW;
			var dh:Number = h / sH;
			var dd:Number = d / sD;
			
			//
			var i:int;
			var j:int;
			var s0:Number;
			
			//
			var vtc:uint = 0;
			//vertices Front -Right - Back - Left
			for ( i = 0 ; i <=sH; i++ )
			{
				s0 = y0 + i * dh;
				//F
				for ( j = 0; j <=sW; j ++ )
				{
					_vertices[vtc] = new FNumber3D( x0 + j * dw, s0, z0 );   vtc++;
				}
				//R
				for ( j = 1; j <=sD; j ++ )
				{
					_vertices[vtc] = new FNumber3D( -x0, s0, z0 - j * dd );  vtc++;
				}
				//B
				for ( j = 1; j <=sW; j ++ )
				{
					_vertices[vtc] = new FNumber3D( -x0 - j * dw, s0, -z0 ); vtc++;
				}
				//L
				for ( j = 1; j <sD; j ++ )
				{
					_vertices[vtc] = new FNumber3D( x0, s0, -z0 + j * dd );  vtc++;
				}
			}
			//vertices Top
			for ( i = 1 ; i < sD; i++ )
			{
				s0 = z0 - i * dd;
				for ( j = 1; j < sW; j++ )
				{
					_vertices[vtc] = new FNumber3D( x0 + j * dw, y0, s0 );   vtc++;
				}
			}
			//vertices bottom
			for ( i = 1 ; i < sD; i++ )
			{
				s0 = z0 - i * dd;
				for ( j = 1; j < sW; j++ )
				{
					_vertices[vtc] = new FNumber3D( x0 + j * dw, -y0, s0 );   vtc++;
				}
			}
			
			//faces and uv F
			var index:int = 0;
			
			var sWD:uint = (sW + sD) * 2;
			//front
			index = initFace(       0, index, sWD, sW, sH, 0 );
			//right
			index = initFace(       1, index, sWD, sD, sH, sW );
			//back
			index = initFace(       2, index, sWD, sW, sH, sW + sD );
			//left
			index = initFaceLeft(   3, index, sWD, sD, sH, sW * 2 + sD );
			//top
			index = initFaceTopBtm( 4, index, sWD, sW, sD, 0, sWD * (sH + 1), true ); 
			//bottom
			index = initFaceTopBtm( 5, index, sWD, sW, sD, sWD * sH, sWD * (sH+1) + (sW+1)*(sD+1) - sWD, false );
		}
		
		private function initFace( setIndex:uint, index:uint, wn:int, xn:uint, yn:uint, xnoffset:uint ):uint
		{
			var si:int = 0;
			var face_set:Array = [];
			var uv_set:Array = [];
			for ( var i:int=0 ; i <yn; i++ )
			{
				var i0:int    = i * wn;
				var v0:Number = i / yn;
				var v1:Number = (i + 1) / yn;
				for ( var j:int = 0; j <xn; j ++ )
				{
					var j0:int    = i0 + j + xnoffset;
					var u0:Number = j / xn;
					var u1:Number = (j + 1) / xn;
					faces[index]  = face_set[si]   = j0;
					uv[index*2]   = uv_set[si*2]   = u0;
					uv[index*2+1] = uv_set[si*2+1] = v0; 
					index++; si++;
					faces[index]  = face_set[si]   = j0 + 1;
					uv[index*2]   = uv_set[si*2]   = u1;
					uv[index*2+1] = uv_set[si*2+1] = v0; 
					index++; si++;
					faces[index]  = face_set[si]   = j0 + wn;
					uv[index*2]   = uv_set[si*2]   = u0;
					uv[index*2+1] = uv_set[si*2+1] = v1; 
					index++; si++;
					faces[index]  = face_set[si]   = j0 + 1;
					uv[index*2]   = uv_set[si*2]   = u1;
					uv[index*2+1] = uv_set[si*2+1] = v0; 
					index++; si++;
					faces[index]  = face_set[si]   = j0 + wn + 1;
					uv[index*2]   = uv_set[si*2]   = u1;
					uv[index*2+1] = uv_set[si*2+1] = v1; 
					index++; si++;
					faces[index]  = face_set[si]   = j0 + wn;
					uv[index*2]   = uv_set[si*2]   = u0;
					uv[index*2+1] = uv_set[si*2+1] = v1; 
					index++; si++;
				}
			}
			faceSet[setIndex] = face_set;
			uvSet[setIndex]   = uv_set;
			
			return index;
		}
		
		private function initFaceLeft( setIndex:uint, index:uint, wn:int, xn:uint, yn:uint, xnoffset:uint ):uint
		{
			var si:int = 0;
			var face_set:Array = [];
			var uv_set:Array = [];
			for ( var i:int=0 ; i <yn; i++ )
			{
				var i0:int    = i * wn;
				var v0:Number = i / yn;
				var v1:Number = (i + 1) / yn;
				var j0:int;
				var u0:Number = 0.0;
				var u1:Number = 0.0;
				for ( var j:int = 0; j <xn-1; j ++ )
				{
					j0 = i0 + j + xnoffset;
					u0 = j / xn;
					u1 = (j + 1) / xn;
					faces[index]  = face_set[si]   = j0;
					uv[index*2]   = uv_set[si*2]   = u0;
					uv[index*2+1] = uv_set[si*2+1] = v0; 
					index++; si++;
					faces[index]  = face_set[si]   = j0 + 1;
					uv[index*2]   = uv_set[si*2]   = u1;
					uv[index*2+1] = uv_set[si*2+1] = v0; 
					index++; si++;
					faces[index]  = face_set[si]   = j0 + wn;
					uv[index*2]   = uv_set[si*2]   = u0;
					uv[index*2+1] = uv_set[si*2+1] = v1; 
					index++; si++;
					faces[index]  = face_set[si]   = j0 + 1;
					uv[index*2]   = uv_set[si*2]   = u1;
					uv[index*2+1] = uv_set[si*2+1] = v0; 
					index++; si++;
					faces[index]  = face_set[si]   = j0 + wn + 1;
					uv[index*2]   = uv_set[si*2]   = u1;
					uv[index*2+1] = uv_set[si*2+1] = v1; 
					index++; si++;
					faces[index]  = face_set[si]   = j0 + wn;
					uv[index*2]   = uv_set[si*2]   = u0;
					uv[index*2+1] = uv_set[si*2+1] = v1; 
					index++; si++;
				}
				j0 = i0 + xn - 1 + xnoffset;
				var j01:uint = j0 + 1 - wn;
				faces[index]  = face_set[si]   = j0;
				uv[index*2]   = uv_set[si*2]   = u1;
				uv[index*2+1] = uv_set[si*2+1] = v0; 
				index++; si++;
				faces[index]  = face_set[si]   = j01;
				uv[index*2]   = uv_set[si*2]   = 1;
				uv[index*2+1] = uv_set[si*2+1] = v0; 
				index++; si++;
				faces[index]  = face_set[si]   = j0 + wn;
				uv[index*2]   = uv_set[si*2]   = u1;
				uv[index*2+1] = uv_set[si*2+1] = v1; 
				index++; si++;
				faces[index]  = face_set[si]   = j01;
				uv[index*2]   = uv_set[si*2]   = 1;
				uv[index*2+1] = uv_set[si*2+1] = v0; 
				index++; si++;
				faces[index]  = face_set[si]   = j01 + wn;
				uv[index*2]   = uv_set[si*2]   = 1;
				uv[index*2+1] = uv_set[si*2+1] = v1; 
				index++; si++;
				faces[index]  = face_set[si]   = j0 + wn;
				uv[index*2]   = uv_set[si*2]   = u1;
				uv[index*2+1] = uv_set[si*2+1] = v1; 
				index++; si++;
			}
			
			faceSet[setIndex] = face_set;
			uvSet[setIndex]   = uv_set;
			return index;
		}
		
		private function initFaceTopBtm( setIndex:uint, index:uint, wn:int, xn:uint, yn:uint, sindex:uint, vi:uint, top:Boolean ):uint
		{
			var si:int = 0;
			var face_set:Array = [];
			var uv_set:Array = [];
			
			var v0:Number;
			var v1:Number;
			var j0:int;
			var u0:Number;
			var u1:Number;
			var i:int;
			var j:int;
			
			var indexes:Array = [];
			var ii:int = 0;
			for ( i=0 ; i<=yn; i++ )
			{
				for ( j=0; j<=xn; j++ )
				{
					if ( i == 0 )
					{
						indexes[ii] = sindex + j; ii++;
					}
					else if ( i == yn )
					{
						indexes[ii] = sindex + wn - yn - j; ii++;
					}
					else if ( j == 0 )
					{
						indexes[ii] = sindex + wn - i; ii++;
					}
					else if ( j == xn )
					{
						indexes[ii] = sindex + xn + i; ii++;
					}
					else
					{
						indexes[ii] = vi;  ii++; vi++;
					}
				}
			}
			
			var n0:int;
			var n1:int;
			var n2:int;
			var n3:int;
			if ( top )
			{
				for ( i=0; i <yn; i++ )
				{
					v0 = i / yn;
					v1 = (i + 1) / yn;
					for ( j= 0; j<xn; j++ )
					{
						n0 = i * (xn+1) + j;
						n1 = n0 + 1;
						n2 = (i+1) * (xn+1) + j; ;
						n3 = n2 + 1;
						u0 = 1 - j / xn;
						u1 = 1 - (j + 1) / xn;
						faces[index]  = face_set[si]   = indexes[n2];
						uv[index*2]   = uv_set[si*2]   = u0;
						uv[index*2+1] = uv_set[si*2+1] = v1; 
						index++; si++;
						faces[index]  = face_set[si]   = indexes[n3];
						uv[index*2]   = uv_set[si*2]   = u1;
						uv[index*2+1] = uv_set[si*2+1] = v1; 
						index++; si++;
						faces[index]  = face_set[si]   = indexes[n0];
						uv[index*2]   = uv_set[si*2]   = u0;
						uv[index*2+1] = uv_set[si*2+1] = v0; 
						index++; si++;
						faces[index]  = face_set[si]   = indexes[n3];
						uv[index*2]   = uv_set[si*2]   = u1;
						uv[index*2+1] = uv_set[si*2+1] = v1; 
						index++; si++;
						faces[index]  = face_set[si]   = indexes[n1];
						uv[index*2]   = uv_set[si*2]   = u1;
						uv[index*2+1] = uv_set[si*2+1] = v0; 
						index++; si++;
						faces[index]  = face_set[si]   = indexes[n0];
						uv[index*2]   = uv_set[si*2]   = u0;
						uv[index*2+1] = uv_set[si*2+1] = v0; 
						index++; si++;
					}
				}
			}
			else
			{
				for ( i=0; i <yn; i++ )
				{
					v0 = i / yn;
					v1 = (i + 1) / yn;
					for ( j= 0; j<xn; j++ )
					{
						n0 = i * (xn+1) + j;
						n1 = n0 + 1;
						n2 = (i+1) * (xn+1) + j; ;
						n3 = n2 + 1;
						u0 = j / xn;
						u1 = (j + 1) / xn;
						faces[index]  = face_set[si]   = indexes[n0];
						uv[index*2]   = uv_set[si*2]   = u0;
						uv[index*2+1] = uv_set[si*2+1] = v0; 
						index++; si++;
						faces[index]  = face_set[si]   = indexes[n1];
						uv[index*2]   = uv_set[si*2]   = u1;
						uv[index*2+1] = uv_set[si*2+1] = v0; 
						index++; si++;
						faces[index]  = face_set[si]   = indexes[n2];
						uv[index*2]   = uv_set[si*2]   = u0;
						uv[index*2+1] = uv_set[si*2+1] = v1; 
						index++; si++;
						faces[index]  = face_set[si]   = indexes[n1];
						uv[index*2]   = uv_set[si*2]   = u1;
						uv[index*2+1] = uv_set[si*2+1] = v0; 
						index++; si++;
						faces[index]  = face_set[si]   = indexes[n3];
						uv[index*2]   = uv_set[si*2]   = u1;
						uv[index*2+1] = uv_set[si*2+1] = v1; 
						index++; si++;
						faces[index]  = face_set[si]   = indexes[n2];
						uv[index*2]   = uv_set[si*2]   = u0;
						uv[index*2+1] = uv_set[si*2+1] = v1; 
						index++; si++;
					}
				}
			}
			
			faceSet[setIndex] = face_set;
			uvSet[setIndex]   = uv_set;
			
			return index;
		}
	}
	
}