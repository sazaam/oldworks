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
	import flash.display.Graphics;
	
	import frocessing.core.F5Graphics;
	import frocessing.f5internal;
	use namespace f5internal;
	
	/**
	* Rect Shape
	* 
	* @author nutsu
	* @version 0.5.8
	*/
	public class FShapeRect extends AbstractFShape implements IFShape
	{
		private var _rx:Number;
		private var _ry:Number;
		
		/**
		 * 
		 */
		public function FShapeRect( x:Number, y:Number, width:Number, height:Number, rx:Number=0, ry:Number=0, parent_group:FShapeContainer=null ) 
		{
			super( parent_group );
			_init( x, y, width, height, rx, ry );
		}
		
		/**
		 * @private
		 */
		protected function _init( x:Number, y:Number, width:Number, height:Number, rx:Number, ry:Number ):void
		{
			_left   = x;
			_top    = y;
			_width  = width;
			_height = height;
			_rx = ( rx > _width * 0.5 ) ? _width * 0.5 : rx;
			_ry = ( ry > _height * 0.5 ) ? _height * 0.5 : ry;
			_geom_changed = false;
		}
		
		
		public function get x():Number { return _left; }
		public function set x(value:Number):void 
		{
			_left = value;
		}
		
		public function get y():Number { return _top; }
		public function set y(value:Number):void 
		{
			_top = value;
		}
		
		public function set width(value:Number):void 
		{
			_width = value;
		}
		public function set height(value:Number):void 
		{
			_height = value;
		}
		
		public function get rx():Number { return _rx; }
		public function set rx(value:Number):void 
		{
			_rx = value;
		}
		
		public function get ry():Number { return _ry; }
		public function set ry(value:Number):void 
		{
			_ry = value;
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
			if ( _rx <= 0 || _ry <= 0 )
			{
				fg.moveTo( _left, _top );
				fg.lineTo( _left + _width, _top );
				fg.lineTo( _left + _width, _top + _height );
				fg.lineTo( _left, _top+_height );
				fg.closePath();	
			}
			else
			{
				fg.f5internal::__roundrect( _left, _top, _left + _width, _top + _height, rx, ry );
			}
		}
		
		/**
		 * implements graphics draw code.
		 * @private
		 */
		override protected function _draw_to_graphics( gc:Graphics ):void
		{
			if ( _rx <=0 || _ry <=0  )
				gc.drawRect( _left, _top, _width, _height );
			else
				gc.drawRoundRect( _left, _top, _width, _height, _rx * 2, _ry * 2 );
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