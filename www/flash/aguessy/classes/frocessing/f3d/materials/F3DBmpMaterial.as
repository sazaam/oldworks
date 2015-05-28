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

package frocessing.f3d.materials 
{
	import frocessing.f3d.F3DGraphics;
	import frocessing.f3d.F3DModel;
	import flash.display.BitmapData;
	
	/**
	* 3D Material BitmapData
	* 
	* @author nutsu
	* @version 0.3
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
			this.backTexture = ( backTexture ) ? backTexture : texture;
		}
		
		/**
		 * draw model
		 * @param	g
		 */
		override public function draw( g:F3DGraphics, model:F3DModel ):void
		{
			if ( _visible )
			{
				g.backFaceCulling = !_backface;
				g.beginTexture( texture, backTexture );
				g.drawMesh( model.vertices, model.faces, model.uv );
				g.endTexture();
			}
		}
	}
	
}