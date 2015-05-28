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
	/**
	* ...
	* @author nutsu
	*/
	public class RenderGradientTask extends RenderTask
	{
		public var type:String;
		public var colors:Array;
		public var alphas:Array;
		public var ratios:Array
		public var matrix:Matrix;
		public var spreadMethod:String;
		public var interpolationMethod:String;
		public var focalPointRatio:Number;
		
		public function RenderGradientTask( kind_:int, path_start_index_:int, command_start_index_:int, za_:Number, cmd_num:int )
		{
			super( kind_, path_start_index_, command_start_index_, za_, cmd_num );
		}
		
		public function setParameters( type_:String, colors_:Array, alphas_:Array, ratios_:Array, matrix_:Matrix, spreadMethod_:String, interpolationMethod_:String, focalPointRatio_:Number ):void
		{
			type                = type_;
			colors              = colors_;
			alphas              = alphas_;
			ratios              = ratios_;
			matrix              = matrix_;
			spreadMethod        = spreadMethod_;
			interpolationMethod = interpolationMethod_;
			focalPointRatio     = focalPointRatio_;
		}
		
		override public function applyFill(g:Graphics):void 
		{
			g.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio );
		}
		
	}
	
}