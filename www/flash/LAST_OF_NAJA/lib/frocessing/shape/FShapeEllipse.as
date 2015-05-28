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
	* Ellipse Shape
	* 
	* @author nutsu
	* @version 0.5.8
	*/
	public class FShapeEllipse extends AbstractFShape implements IFShape
	{
		private var _cx:Number;
		private var _cy:Number;
		
		/**
		 * 
		 */
		public function FShapeEllipse( x:Number, y:Number, radiusX:Number, radiusY:Number, parent_group:FShapeContainer=null ) 
		{
			super( parent_group );
			_init( x, y, radiusX, radiusY );			
		}
		
		/**
		 * @private
		 */
		protected function _init( x:Number, y:Number, radiusX:Number, radiusY:Number ):void
		{
			_cx = x;
			_cy = y;
			_left   = _cx - radiusX;
			_top    = _cy - radiusY;
			_width  = radiusX*2;
			_height = radiusY*2;
			_geom_changed = false;
		}
		
		public function get cx():Number { return _cx; }
		public function set cx(value:Number):void 
		{
			_cx   = value;
			_left = _cx - rx;
		}
		
		public function get cy():Number { return _cy; }
		public function set cy(value:Number):void 
		{
			_cy  = value;
			_top = _cy - ry;
		}
		
		public function get rx():Number { return _width*0.5; }
		public function set rx(value:Number):void 
		{
			_width = value * 2;
			_left = _cx - value;
		}
		
		public function get ry():Number { return _height*0.5; }
		public function set ry(value:Number):void 
		{
			_height = value*2;
			_top = _cy - value;
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
			fg.f5internal::__ellipse( _cx, _cy, _width*0.5, _height*0.5 );
		}
		
		/**
		 * implements graphics draw code.
		 * @private
		 */
		override protected function _draw_to_graphics( gc:Graphics ):void
		{
			gc.drawEllipse( _left, _top, _width, _height );
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