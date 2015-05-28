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
	* 3D Primitive Plane
	* 
	* @author nutsu
	* @version 0.5
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
					vertices[vtc] = new FNumber3D( x0 + j * dw, h0, 0 );
					u_tmp[vtc]    = j/sW;
					v_tmp[vtc]    = v;
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