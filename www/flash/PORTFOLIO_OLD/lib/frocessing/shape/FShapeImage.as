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

package frocessing.shape 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import frocessing.core.F5Graphics;	
	import frocessing.f5internal;
	use namespace f5internal;
	
	/**
	* Image Shape
	* 
	* @author nutsu
	* @version 0.5.8
	*/
	public class FShapeImage extends AbstractFShape implements IFShape
	{
		/**
		 * @private
		 */
		protected var _bitmapData:BitmapData;
		
		/**
		 * @private
		 */
		protected var bd_matrix:Matrix;
		
		/**
		 * 
		 */
		public function FShapeImage( bitmapdata:BitmapData, x:Number=0, y:Number=0, width:Number=NaN, height:Number=NaN, parent_group:FShapeContainer=null ) 
		{
			
			super( parent_group );
			_init( bitmapdata, x, y, width, height );
		}
		
		/**
		 * @private
		 */
		protected function _init( bd:BitmapData, x:Number, y:Number, width:Number, height:Number ):void
		{
			_bitmapData = bd;
			_left = x;
			_top  = y;
			if ( isNaN( width * height ) )
			{
				_width  = _bitmapData.rect.width;
				_height = _bitmapData.rect.height;
			}
			else
			{
				_width  = width;
				_height = height;
			}
			_geom_changed = false;
			
			//
			strokeEnabled = false;
			fillEnabled   = false;
			
			//
			bd_matrix = new Matrix( _width/_bitmapData.rect.width, 0, 0, _height/_bitmapData.rect.height, _left, _top );
		}
		
		
		public function get x():Number { return _left; }
		public function set x(value:Number):void 
		{
			_left = value;
			bd_matrix.tx = value;
		}
		
		public function get y():Number { return _top; }
		public function set y(value:Number):void 
		{
			_top = value;
			bd_matrix.ty = value;
		}
		
		public function set width(value:Number):void 
		{
			_width = value;
			bd_matrix.a = _width/_bitmapData.rect.width;
		}
		public function set height(value:Number):void 
		{
			_height = value;
			bd_matrix.d = _height/_bitmapData.rect.height;
		}
		
		public function get bitmapData():BitmapData { return _bitmapData; }
		public function set bitmapData(value:BitmapData):void 
		{
			_bitmapData = value;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// implements draw method.
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * implements f5graphics draw code.
		 * @private
		 */
		override protected function _draw_to_f5(fg:F5Graphics):void 
		{
			fg.f5internal::_image( _bitmapData, _left, _top, _width, _height );
		}
		
		/**
		 * implements graphics draw code.
		 * @private
		 */
		override protected function _draw_to_graphics( gc:Graphics ):void
		{
			gc.beginBitmapFill( _bitmapData, bd_matrix, false );
			gc.drawRect( _left, _top, _width, _height );
			gc.endFill();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Geometory
		//-------------------------------------------------------------------------------------------------------------------
		
		override public function get left():Number { return _left; }
		override public function get top():Number { return _top; }
		override public function get width():Number { return _width; }
		override public function get height():Number { return _height; }
		
		/**
		 * @private
		 */
		override protected function _check_geom():void 
		{
			_geom_changed = false;
		}
	}
	
}