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
	*/
	public class StrokeTask implements IStrokeTask
	{
		public var strokeColor:uint;
		public var strokeAlpha:Number;
		public var thickness:Number;
		public var pixelHinting:Boolean;
		public var scaleMode:String;
		public var caps:String;
		public var joints:String;
		public var miterLimit:Number;
		
		public function StrokeTask( thickness_:Number, color_:uint, alpha_:Number, pixelHinting_:Boolean, scaleMode_:String, caps_:String, joints_:String, miterLimit_:Number )
		{
			thickness    = thickness_;
			strokeColor  = color_;
			strokeAlpha  = alpha_;
			pixelHinting = pixelHinting_;
			scaleMode    = scaleMode_;
			caps         = caps_;
			joints       = joints_;
			miterLimit   = miterLimit_;
		}
		
		public function setLineStyle( g:Graphics ):void
		{
			g.lineStyle( thickness, strokeColor, strokeAlpha, pixelHinting, scaleMode, caps, joints, miterLimit );
		}
	}
	
}