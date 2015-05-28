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
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	/**
	* ...
	* @author nutsu
	*/
	public class PolygonBitmapTask extends PolygonTask
	{		
		public var bitmap:BitmapData;
		public var matrix:Matrix;
		public var repeat:Boolean;
		public var smooth:Boolean;
		
		public function PolygonBitmapTask( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number ) 
		{
			super( x0, y0, z0, x1, y1, z1, x2, y2, z2 );
		}
		
		public function setParameters( bitmap_:BitmapData, matrix_:Matrix, repeat_:Boolean, smooth_:Boolean ):void
		{
			bitmap = bitmap_;
			matrix = matrix_;
			repeat = repeat_;
			smooth = smooth_;
		}
		
		override public function render( gc:Graphics ):void
		{
			gc.beginBitmapFill( bitmap, matrix, repeat, smooth );
			gc.moveTo( x0, y0 );
			gc.lineTo( x1, y1 );
			gc.lineTo( x2, y2 );
			gc.endFill();
		}	
	}
	
}