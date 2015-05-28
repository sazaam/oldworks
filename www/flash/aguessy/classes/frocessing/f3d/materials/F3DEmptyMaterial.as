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
	
	/**
	* 3D Material Empty
	* 
	* @author nutsu
	* @version 0.3
	*/
	public class F3DEmptyMaterial implements IF3DMaterial
	{
		
		protected var _visible:Boolean;
		protected var _backface:Boolean;
		
		/**
		 * 
		 */
		public function F3DEmptyMaterial() 
		{
			_visible  = true;
			_backface = false;
		}
		
		/**
		 * model visible
		 */
		public function get visible():Boolean { return _visible;  }
		public function set visible( value:Boolean ):void
		{
			_visible = value;
		}
		
		/**
		 *  back face drawing
		 */
		public function set backFace( value:Boolean ):void
		{
			_backface = value;
		}
		
		/**
		 * draw model
		 * @param	g
		 */
		public function draw( g:F3DGraphics, model:F3DModel ):void
		{
			if ( _visible )
			{
				g.backFaceCulling = !_backface;
				g.drawMesh( model.vertices, model.faces, model.uv );
			}
		}
	}
	
}