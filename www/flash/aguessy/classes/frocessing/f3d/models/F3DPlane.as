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
	
	/**
	* 3D Primitive Plane
	* 
	* @author nutsu
	* @version 0.3
	* 
	*/
	public class F3DPlane extends F3DModel{
		
		/**
		 * 
		 */
		public function F3DPlane( width:Number, height:Number=NaN, segment:uint=2, segmentH:uint=2 ) 
		{
			super();
			if ( isNaN(height) )
				height = width;
			
			if ( segment < 1 )
				segment = 1;
			
			if ( arguments.length<4 )
				segmentH = segment;
			
			initModel( width, height, segment, segmentH );
		}
		
		/**
		 * @private
		 */
		private function initModel( w:Number, h:Number, sW:uint, sH:uint ):void
		{
			//_vertices = [];
			//faces     = [];
			//uv		= [];
			var u_tmp:Array = [];
			var v_tmp:Array = [];
			
			// vertex and uv temp
			var vtc:uint = 0;
			var x0:Number = - w * 0.5;
			var y0:Number = - h * 0.5;
			var dw:Number = w / sW;
			var dh:Number = h / sH;
			var i:int;
			var j:int;
			var h0:Number;
			var v:Number;
			for ( i = 0 ; i <=sH; i++ )
			{
				v  = i / sH;
				h0 = y0 + i * dh;
				for ( j = 0; j <=sW; j ++ )
				{
					_vertices[vtc] = new FNumber3D( x0 + j * dw, h0, 0 );
					u_tmp[vtc]     = j/sW;
					v_tmp[vtc]     = v;
					vtc++;
				}
			}
			
			//faces and uv
			var i0:int;
			var j0:int;
			var ii:int = 0;
			var n:int;
			for ( i=0 ; i <sH; i++ )
			{
				i0 = i * (sW + 1);
				for ( j = 0; j<sW; j ++ )
				{
					j0 = i0 + j;
					n = j0;
					faces[ii] = n; uv[ii*2] = u_tmp[n]; uv[ii*2+1] = v_tmp[n]; ii++;
					n = j0 + 1;
					faces[ii] = n; uv[ii*2] = u_tmp[n]; uv[ii*2+1] = v_tmp[n]; ii++;
					n = j0 + sW + 1;
					faces[ii] = n; uv[ii*2] = u_tmp[n]; uv[ii*2+1] = v_tmp[n]; ii++;
					n = j0 + 1;
					faces[ii] = n; uv[ii*2] = u_tmp[n]; uv[ii*2+1] = v_tmp[n]; ii++;
					n = j0 + sW + 2;
					faces[ii] = n; uv[ii*2] = u_tmp[n]; uv[ii*2+1] = v_tmp[n]; ii++;
					n = j0 + sW + 1;
					faces[ii] = n; uv[ii*2] = u_tmp[n]; uv[ii*2+1] = v_tmp[n]; ii++;
				}
			}
			
			faceSet = [faces];
			uvSet   = [uv];
		}
		
	}
	
}