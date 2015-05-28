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
	
	/**
	* 3D Material Interface
	* 
	* @author nutsu
	* @version 0.5
	*/
	public interface IF3DMaterial 
	{
		/**
		 * draw model
		 * @param	g
		 */
		function draw( g:GraphicsEx3D, model:F3DModel ):void;
		
		/**
		 * model visible
		 */
		function set visible( value:Boolean ):void;
		
		/**
		 * back face drawing
		 */
		function set backFace( value:Boolean ):void;
	}
	
}