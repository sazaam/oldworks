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
	/**
	* ...
	* @author nutsu
	* @version 0.5
	*/
	public class QuadTask extends RenderTaskObject implements IGraphicsTask
	{
		public var x0:Number;
		public var y0:Number;
		public var z0:Number;
		public var x1:Number;
		public var y1:Number;
		public var z1:Number;
		public var x2:Number;
		public var y2:Number;
		public var z2:Number;
		public var x3:Number;
		public var y3:Number;
		public var z3:Number;
		
		public function QuadTask( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number, x3:Number, y3:Number, z3:Number ) 
		{
			super( 31, (z0 + z1 + z2 + z3) / 4 );
			this.x0 = x0; this.y0 = y0; this.z0 = z0;
			this.x1 = x1; this.y1 = y1; this.z1 = z1;
			this.x2 = x2; this.y2 = y2; this.z2 = z2;
			this.x3 = x3; this.y3 = y3; this.z3 = z3;
		}
		
		public function render( gc:Graphics ):void
		{
			gc.moveTo( x0, y0 );
			gc.lineTo( x1, y1 );
			gc.lineTo( x2, y2 );
			gc.lineTo( x3, y3 );
			gc.lineTo( x0, y0 );
		}
		
	}
	
}