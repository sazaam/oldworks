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

package frocessing.f3d.materials 
{
	import frocessing.core.GraphicsEx3D;
	import frocessing.f3d.F3DModel;
	import flash.display.BitmapData;
	
	/**
	* 3D Material BitmapData
	* 
	* @author nutsu
	* @version 0.5
	*/
	public class F3DBmpMaterial extends F3DEmptyMaterial
	{
		public var texture:BitmapData;
		public var backTexture:BitmapData;
		
		/**
		 * 
		 * @param	texture
		 * @param	backTexture
		 */
		public function F3DBmpMaterial( texture:BitmapData, backTexture:BitmapData=null ) 
		{
			super();
			setTexture( texture, backTexture );
		}
		
		/**
		 * 
		 * @param	texture
		 * @param	backTexture
		 */
		public function setTexture( texture:BitmapData, backTexture:BitmapData = null ):void
		{
			this.texture = texture;
			this.backTexture = ( backTexture!=null ) ? backTexture : texture;
		}
		
		/**
		 * draw model
		 * @param	g
		 */
		override public function draw( g:GraphicsEx3D, model:F3DModel ):void
		{
			if ( _visible )
			{
				g.backFaceCulling = !_backface;
				g.beginTexture( texture, backTexture );
				g.drawMesh( model.$vertices, model.faces, model.uv );
				g.endTexture();
			}
		}
	}
	
}