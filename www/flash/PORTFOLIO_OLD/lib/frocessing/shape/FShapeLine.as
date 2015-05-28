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
	
	/**
	* Line Shape
	* 
	* @author nutsu
	* @version 0.5.3
	*/
	public class FShapeLine extends AbstractFShape implements IFShape
	{
		private var _x1:Number;
		private var _y1:Number;
		private var _x2:Number;
		private var _y2:Number;
		
		/**
		 * 
		 */
		public function FShapeLine( x1:Number, y1:Number, x2:Number, y2:Number, parent_group:FShapeContainer=null ) 
		{
			super( parent_group );
			_init( x1, y1, x2, y2 );			
		}
		
		/**
		 * @private
		 */
		protected function _init( x1:Number, y1:Number, x2:Number, y2:Number ):void
		{
			_x1 = x1;
			_y1 = y1;
			_x2 = x2;
			_y2 = y2;
			_geom_changed = true;
			_check_geom();
		}
		
		public function get x1():Number { return _x1; }
		public function set x1(value:Number):void 
		{
			_geom_changed = true;
			_x1 = value;
		}
		
		public function get y1():Number { return _y1; }
		public function set y1(value:Number):void 
		{
			_geom_changed = true;
			_y1 = value;
		}
		
		public function get x2():Number { return _x2; }
		public function set x2(value:Number):void 
		{
			_geom_changed = true;
			_x2 = value;
		}
		
		public function get y2():Number { return _y2; }
		public function set y2(value:Number):void 
		{
			_geom_changed = true;
			_y2 = value;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// implements draw method.
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * implements f5graphics draw code.
		 * @private
		 */
		override protected function _draw_to_f5( fg:F5Graphics ):void 
		{
			fg.moveTo( _x1, _y1 );
			fg.lineTo( _x2, _y2 );
		}
		
		/**
		 * implements graphics draw code.
		 * @private
		 */
		override protected function _draw_to_graphics( gc:Graphics ):void
		{
			gc.moveTo( _x1, _y1 );
			gc.lineTo( _x2, _y2 );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Geometory
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override protected function _check_geom():void 
		{
			if ( _geom_changed )
			{
				_width  = Math.abs( _x2 - _x1 );
				_height = Math.abs( _y2 - _y1 );
				_left   = Math.min( _x1, _x2 );
				_top    = Math.min( _y1, _y2 );
				_geom_changed = false;
			}
		}
	}
	
}