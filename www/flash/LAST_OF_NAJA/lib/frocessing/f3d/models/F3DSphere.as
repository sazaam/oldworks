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

package frocessing.f3d.models
{
	import frocessing.geom.FNumber3D;
	import frocessing.f3d.F3DModel;
	
	/**
	* 3D Primitive Sphere
	* 
	* @author nutsu
	* @version 0.5
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
					vertices[vtc] = new FNumber3D( r * Math.sin( -dh * j ), h, -r * Math.cos( dh * j ));
					u_tmp[vtc]    = j/_detail;
					v_tmp[vtc]    = v;
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