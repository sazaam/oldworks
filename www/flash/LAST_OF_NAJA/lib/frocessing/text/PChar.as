﻿// --------------------------------------------------------------------------
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

package frocessing.text 
{
	import flash.display.BitmapData;
	
	/**
	* @author nutsu
	* @version 0.5
	*/
	public class PChar
	{
		public var data:BitmapData;
		public var offsetX:Number;
		public var offsetY:Number;
		public var width:Number;
		public var height:Number;
		
		/**
		 * 
		 */
		public function PChar( charImage:BitmapData, offsetX:Number, offsetY:Number, width:Number, height:Number ):void
		{
			this.data    = charImage;
			this.offsetX = offsetX;
			this.offsetY = offsetY;
			this.width   = width;
			this.height  = height;
		}
	}
	
}