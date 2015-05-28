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
	* 3D Primitive Sphere
	* 
	* @author nutsu
	* @version 0.3
	* 
	*/
	public class F3DSphere extends F3DModel{
		
		private var _radius:Number;
		private var _detail:uint;
		
		/**
		 * 
		 * @param	radius_
		 * @param	detail_	segments minimum 3, default 12
		 */
		public function F3DSphere( radius:Number, detail:uint = 12 ) 
		{
			super();
			initModel( radius, detail );
		}
		
		/**
		 * @private
		 */
		private function initModel( radius:Number, detail:uint ):void
		{
			_radius = radius;
			_detail = detail;
			
			_vertices = [];
			faces     = [];
			uv		  = [];
			var u_tmp:Array = [];
			var v_tmp:Array = [];
			
			// vertex and uv temp
			var vtc:uint = 0;
			var dh:Number = 2*Math.PI/_detail;
			var dv:Number = Math.PI/_detail;
			var i:int;
			var j:int;
			var h:Number;
			var r:Number;
			var v:Number;
			for ( i = 0 ; i <=_detail; i++ )
			{
				v = i/_detail;
				h = - _radius * Math.cos(dv * i);
				r =   _radius * Math.sin(dv * i);
				for ( j = 0; j <= _detail; j ++ )
				{
					_vertices[vtc] = new FNumber3D( r * Math.sin( -dh * j ), h, -r * Math.cos( dh * j ));
					u_tmp[vtc]     = j/_detail;
					v_tmp[vtc]     = v;
					vtc++;
				}
			}
			
			//faces and uv
			var i0:int;
			var j0:int;
			var ii:int = 0;
			var n:int;
			for ( j = 0; j <_detail; j ++ )
			{
				n = j;
				faces[ii] = n; uv[ii*2] = u_tmp[n]; uv[ii*2+1] = v_tmp[n]; ii++;
				n = j + _detail + 2;
				faces[ii] = n; uv[ii*2] = u_tmp[n]; uv[ii*2+1] = v_tmp[n]; ii++;
				n = j + _detail + 1;
				faces[ii] = n; uv[ii*2] = u_tmp[n]; uv[ii*2+1] = v_tmp[n]; ii++;
			}
			for ( i = 1 ; i <_detail-1; i++ )
			{
				i0 = i * (_detail + 1);
				for ( j = 0; j <_detail; j ++ )
				{
					j0 = i0 + j;
					n = j0;
					faces[ii] = n; uv[ii*2] = u_tmp[n]; uv[ii*2+1] = v_tmp[n]; ii++;
					n = j0 + 1;
					faces[ii] = n; uv[ii*2] = u_tmp[n]; uv[ii*2+1] = v_tmp[n]; ii++;
					n = j0 + _detail + 1;
					faces[ii] = n; uv[ii*2] = u_tmp[n]; uv[ii*2+1] = v_tmp[n]; ii++;
					n = j0 + 1;	
					faces[ii] = n; uv[ii*2] = u_tmp[n]; uv[ii*2+1] = v_tmp[n]; ii++;
					n = j0 + _detail + 2;
					faces[ii] = n; uv[ii*2] = u_tmp[n]; uv[ii*2+1] = v_tmp[n]; ii++;
					n = j0 + _detail + 1;
					faces[ii] = n; uv[ii*2] = u_tmp[n]; uv[ii*2+1] = v_tmp[n]; ii++;
				}
			}
			i0 = (_detail-1) * (_detail + 1);
			for ( j = 0; j <_detail; j ++ )
			{
				j0 = i0 + j;
				n = j0;
				faces[ii] = n; uv[ii*2] = u_tmp[n]; uv[ii*2+1] = v_tmp[n]; ii++;
				n = j0 + 1;
				faces[ii] = n; uv[ii*2] = u_tmp[n]; uv[ii*2+1] = v_tmp[n]; ii++;
				n = j0 + _detail + 2;
				faces[ii] = n; uv[ii*2] = u_tmp[n]; uv[ii*2+1] = v_tmp[n]; ii++;
			}
			
			faceSet = [faces];
			uvSet   = [uv];
		}
		
	}
	
}