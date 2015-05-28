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
	import flash.display.BitmapData;
	/**
	* ...
	* @author nutsu
	*/
	public class RenderTask extends RenderTaskObject
	{
		public var path_start:int;
		public var command_start:int;
		public var command_num:int;
		
		public var fillDo:Boolean;
		public var fillColor:uint;
		public var fillAlpha:Number;
		
		public var bitmapdata:BitmapData;
		public var u0:Number;
		public var v0:Number;
		public var u1:Number;
		public var v1:Number;
		public var u2:Number;
		public var v2:Number;
		
		public function RenderTask( kind_:int, path_start_index_:int, command_start_index_:int, za_:Number, cmd_num:int )
		{
			super( kind_, za_ );
			path_start    = path_start_index_;
			command_start = command_start_index_;
			command_num   = cmd_num;
			fillDo        = false;
		}
		
		public function setUV( u0_:Number, v0_:Number, u1_:Number, v1_:Number, u2_:Number, v2_:Number ):void
		{
			u0 = u0_;  v0 = v0_;
			u1 = u1_;  v1 = v1_;
			u2 = u2_;  v2 = v2_;
		}
		
		public function applyFill( g:Graphics ):void
		{
			g.beginFill( fillColor, fillAlpha );
		}
	}
	
}