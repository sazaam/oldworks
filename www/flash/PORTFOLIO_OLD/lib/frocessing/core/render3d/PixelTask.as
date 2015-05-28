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

package frocessing.core.render3d
{
	import frocessing.bmp.FBitmapData;
	
	/**
	* ...
	* @author nutsu
	*/
	public class PixelTask extends RenderTaskObject 
	{
		public var x:int;
		public var y:int;
		public var z:Number;
		public var color:uint;
		
		public function PixelTask( x_:Number, y_:Number, z_:Number, color_:uint ) 
		{
			super( 11, z_ );
			x = int(x_);
			y = int(y_);
			z = z_;
			color = color_;
		}
		
		public function render( bd:FBitmapData ):void
		{
			bd.drawPixel( x, y, color );
		}
	}
	
}