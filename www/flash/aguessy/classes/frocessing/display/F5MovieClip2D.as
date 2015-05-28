// --------------------------------------------------------------------------
// Project Frocessing
// ActionScript 3.0 drawing library like Processing.
// --------------------------------------------------------------------------
//
// This library is based on Processing. 
// Copyright (c) 2001-04 Massachusetts Institute of Technology
// Copyright (c) 2004-07 Ben Fry and Casey Reas
// http://processing.org
//
// Frocessing drawing library
// Copyright (C) 2008  TAKANAWA Tomoaki (http://nutsu.com) and
//					   Spark project (www.libspark.org)
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
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.utils.getTimer;
	
	import frocessing.FC;
	import frocessing.core.F5Graphics2D;
	import frocessing.core.F5BitmapData2D;
	
	/**
	* F5MovieClip2D
	* @author nutsu
	* @version 0.1
	*/
	public dynamic class F5MovieClip2D extends F5MovieClip{
		
		public var fg:F5Graphics2D;
		
		/**
		 * 
		 */
		public function F5MovieClip2D() {
			super();
		}
		
		/**
		 * 
		 */
		override protected function init():void
		{
			draw_shape = new Shape();
			fg  = new F5Graphics2D( draw_shape.graphics );
			_fg = fg;
			addChild( draw_shape );
		}
		
		/**
		 * 
		 * @param	width_
		 * @param	height_
		 * @param	transparent_
		 * @param	bgcolor_
		 * @param	pixelSnapping
		 * @param	smoothing
		 */
		public function setBmpMode( width_:uint, height_:uint, transparent_:Boolean=true, bgcolor_:uint=0xffcccccc, pixelSnapping:String="auto", smoothing:Boolean=false ):void
		{
			if ( !( fg is F5BitmapData2D) )
			{
				fg = new F5BitmapData2D( width_, height_, transparent_, bgcolor_ );
				removeChild( draw_shape );
				addChild( new Bitmap( F5BitmapData2D(fg).bitmapData, pixelSnapping, smoothing ) );
				_fg = fg;
				_fg.beginDraw();
			}
		}
		
		
		//--------------------------------------------------------------------------------------------------- 
		
		// TRANSFORM
		
		public function translate( x_:Number, y_:Number ):void{
			fg.translate( x_, y_ );
		}
		public function scale( x_:Number, y_:Number = NaN ):void{
			fg.scale( x_, y_ );
		}
		public function rotate( angle:Number ):void{
			fg.rotate( angle );
		}
		public function pushMatrix():void{
			fg.pushMatrix();
		}
		public function popMatrix():void{
			fg.popMatrix();
		}
		public function resetMatrix():void{
			fg.resetMatrix();
		}
		public function printMatrix():void {
			fg.printMatrix();
		}
		
		public function screenX( x:Number, y:Number ):Number{
			return fg.screenX( x, y );
		}
		public function screenY( x:Number, y:Number ):Number{
			return fg.screenY( x, y );
		}
		
		public function applyTransform( displayObj:DisplayObject, x:Number=0, y:Number=0 ):void{
			fg.applyTransform( displayObj, x, y );
		}
	}
}
