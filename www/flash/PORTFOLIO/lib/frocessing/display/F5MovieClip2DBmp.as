﻿// --------------------------------------------------------------------------
// Project Frocessing
// ActionScript 3.0 drawing library like Processing.
// --------------------------------------------------------------------------
//
// This library is based on Processing.(http://processing.org)
// Copyright (c) 2004-08 Ben Fry and Casey Reas
// Copyright (c) 2001-04 Massachusetts Institute of Technology
// 
// Frocessing drawing library
// Copyright (C) 2008-10  TAKANAWA Tomoaki (http://nutsu.com) and
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
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import frocessing.core.F5BitmapData2D;
	
	/**
	* F5MovieClip2DBmp.
	* 
	* @author nutsu
	* @version 0.6
	* 
	* @see frocessing.core.F5BitmapData2D
	*/
	public dynamic class F5MovieClip2DBmp extends F5CanvasMovieClip2D
	{
		private var _bmpfg:F5BitmapData2D;
		private var _target_bmp:Bitmap;
		
		//bmp
		//public var bmpTransparent:Boolean;
		//public var bmpBGColor:uint;
			
		public function F5MovieClip2DBmp( transparent:Boolean=true, bgcolor:uint=0xffcccccc, pixelSnapping:String="auto", smoothing:Boolean=false, useStageEvent:Boolean=true ) 
		{
			super( _bmpfg = new F5BitmapData2D( __stage_width, __stage_height, transparent, bgcolor ),
			       _target_bmp = new Bitmap( _bmpfg.bitmapData, pixelSnapping, smoothing ),
				   useStageEvent );
			
			//bmpTransparent   = transparent;
			//bmpBGColor		 = bgcolor;
			
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function size( width_:uint, height_:uint ):void
		{
			fg.size( width_, height_ );
			_target_bmp.bitmapData = _bmpfg.bitmapData;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		/*
		public function pixel( x:Number, y:Number ):void
		{
			F5BitmapData2D(fg).pixel( x, y );
		}
		*/
		/**
		 * target BitmapData.
		 */
		public function get bitmapData():BitmapData { 	return _bmpfg.bitmapData; }
		/**
		 * target F5BitmapData2D.
		 */
		public function get bmpfg():F5BitmapData2D{		return _bmpfg; } 
	}
	
}