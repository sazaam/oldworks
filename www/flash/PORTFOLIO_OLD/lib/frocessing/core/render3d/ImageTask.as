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
	import flash.display.BitmapData;
	import frocessing.core.GraphicsEx3D;
	
	/**
	* ...
	* @author nutsu
	*/
	public class ImageTask extends RenderTaskObject 
	{
		public var bitmapdata:BitmapData;
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var width:Number;
		public var height:Number;
		
		
		public function ImageTask( bd:BitmapData, x_:Number, y_:Number, z_:Number, w:Number, h:Number ) 
		{
			super( 20, z_ );
			bitmapdata = bd;
			x = x_;
			y = y_;
			z = z_;
			width = w;
			height = h;
		}
		
		public function render( gc:GraphicsEx3D ):void
		{
			gc.beginBitmap( bitmapdata );
			gc.drawBitmap( x, y, width, height );
		}
		
	}
	
}