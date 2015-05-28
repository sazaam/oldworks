// --------------------------------------------------------------------------
// Project Frocessing
// ActionScript 3.0 drawing library like Processing.
// --------------------------------------------------------------------------
//
// This library is based on Processing.(http://processing.org)
// Copyright (c) 2004-08 Ben Fry and Casey Reas
// Copyright (c) 2001-04 Massachusetts Institute of Technology
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

package frocessing.display {
	
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import frocessing.core.F5C;
	import frocessing.core.F5BitmapData3D;
	
	/**
	* ...
	* @author nutsu
	* @version 0.5.8
	* 
	* @see frocessing.core.F5BitmapData3D
	*/
	public dynamic class F5MovieClip3DBmp extends F5MovieClip3D
	{
		//bmp
		public var bmpTransparent:Boolean;
		public var bmpBGColor:uint;
		public var bmpPixelSnapping:String;
		public var bmpSmoothing:Boolean;
			
		public function F5MovieClip3DBmp( transparent:Boolean=true, bgcolor:uint=0xffcccccc, pixelSnapping:String="auto", smoothing:Boolean=false ) 
		{
			bmpTransparent   = transparent;
			bmpBGColor		 = bgcolor;
			bmpPixelSnapping = pixelSnapping;
			bmpSmoothing	 = smoothing;
			super();
		}
		
		/** @private */
		override internal function __init():void
		{
			fg = new F5BitmapData3D( __stage_width, __stage_height, bmpTransparent, bmpBGColor );
			__draw_target = new Bitmap( F5BitmapData3D(fg).bitmapData, bmpPixelSnapping, bmpSmoothing );
			addChild( __draw_target );
			__fg = fg;
			//for framescript
			fg.beginDraw();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		override public function size( width_:uint, height_:uint ):void
		{
			fg.size( width_, height_ );
			removeChild( __draw_target );
			__draw_target = new Bitmap( F5BitmapData3D(fg).bitmapData, bmpPixelSnapping, bmpSmoothing );
			addChild( __draw_target );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		public function pixel( x_:Number, y_:Number, z_:Number ):void
		{
			F5BitmapData3D(fg).pixel( x_, y_, z_ );
		}
		
		public function get bitmapData():BitmapData
		{
			return F5BitmapData3D(fg).bitmapData;
		}
		
		public function get bmpfg():F5BitmapData3D
		{
			return F5BitmapData3D(fg);
		}
	}
	
}