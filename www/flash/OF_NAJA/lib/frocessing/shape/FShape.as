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
	* Path Shape
	* 
	* @author nutsu
	* @version 0.5.8
	*/
	public class FShape extends AbstractFShape implements IFShape
	{
		// path command --------------------------------
		/**
		 * @private
		 */
		protected static const MOVE_TO    :int = 1;
		/**
		 * @private
		 */
		protected static const LINE_TO    :int = 2;
		/**
		 * @private
		 */
		protected static const CURVE_TO   :int = 3;
		/**
		 * @private
		 */
		protected static const BEZIER_TO  :int = 10;
		/**
		 * @private
		 */
		protected static const CLOSE_PATH :int = 100;
		
		// path values ---------------------------------
		/**
		 * @private
		 */
		protected var _commands:Array;
		/**
		 * @private
		 */
		protected var _vertices:Array;
		
		
		/**
		 * 
		 */
		public function FShape( commands:Array=null, vertices:Array=null, parent_group:FShapeContainer=null ) 
		{
			super( parent_group );
			
			//path
			_commands = ( commands != null ) ? commands : [];
			_vertices = ( vertices != null ) ? vertices : [];
			
			//_geom_changed = true;
		}
		
		/**
		 * 
		 */
		public function get commands():Array { return _commands; }
		
		/**
		 * 
		 */
		public function get vertices():Array { return _vertices; }
		
		//-------------------------------------------------------------------------------------------------------------------
		// implements draw method
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * implements f5graphics draw code.
		 * @private
		 */
		override protected function _draw_to_f5( fg:F5Graphics ):void
		{
			var len:int = _commands.length;
			if ( len == 0 )
				return;
			
			var xi:int   = 0;
			var yi:int   = 1;
			//path
			for ( var i:int = 0; i < len ; i++ )
			{
				var cmd:int = _commands[i];
				if ( cmd == LINE_TO )
				{
					fg.lineTo( _vertices[xi], _vertices[yi] );
					xi += 2;
					yi += 2;
				}
				else if ( cmd == BEZIER_TO )
				{
					fg.bezierTo( _vertices[xi], _vertices[yi], _vertices[uint(xi + 2)], _vertices[uint(yi + 2)], _vertices[uint(xi + 4)], _vertices[uint(yi + 4)] );
					xi += 6;
					yi += 6;
				}
				else if ( cmd == CURVE_TO )
				{
					fg.curveTo( _vertices[xi], _vertices[yi], _vertices[uint(xi + 2)], _vertices[uint(yi + 2)] );
					xi += 4;
					yi += 4;
				}
				else if ( cmd == MOVE_TO )
				{
					fg.moveTo( _vertices[xi], _vertices[yi] );
					xi += 2;
					yi += 2;
				}
				else if ( cmd == CLOSE_PATH )
				{
					fg.closePath();
				}
			}
		}
		
		/**
		 * implements graphics draw code.
		 * @private
		 */
		override protected function _draw_to_graphics( gc:Graphics ):void
		{
			var len:int = _commands.length;
			if ( len == 0 )
				return;
				
			var sx:Number = 0;
			var sy:Number = 0;
			var px:Number = 0;
			var py:Number = 0;
			var xi:int    = 0;
			var yi:int    = 1;
			for ( var i:int = 0; i < len ; i++ )
			{
				var cmd:int = _commands[i];
				if ( cmd == LINE_TO )
				{
					px = _vertices[xi];
					py = _vertices[yi];
					gc.lineTo( px, py );
					xi += 2;
					yi += 2;
				}
				else if ( cmd == BEZIER_TO )
				{
					var bx:Number = _vertices[uint(xi + 4)];
					var by:Number = _vertices[uint(yi + 4)];
					_draw_bezier( gc, px, py, _vertices[xi], _vertices[yi], _vertices[uint(xi + 2)], _vertices[uint(yi + 2)], bx, by );
					px = bx;
					py = by;
					xi += 6;
					yi += 6;
				}
				else if ( cmd == CURVE_TO )
				{
					px = _vertices[uint(xi + 2)];
					py = _vertices[uint(yi + 2)];
					gc.curveTo( _vertices[xi], _vertices[yi], px, py );
					xi += 4;
					yi += 4;
				}
				else if ( cmd == MOVE_TO )
				{
					sx = px = _vertices[xi];
					sy = py = _vertices[yi];
					gc.moveTo( sx, sy );
					xi += 2;
					yi += 2;
				}
				else if ( cmd == CLOSE_PATH )
				{
					gc.lineTo( sx, sy );
					px = sx;
					py = sy;
				}
			}
		}
		
		public var bezierDetail:uint = 20;
		
		private function _draw_bezier( gc:Graphics, x0:Number, y0:Number, cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			var k:Number = 1.0/bezierDetail;
			var t:Number = 0;
			var tp:Number;
			for ( var i:int = 1; i <= bezierDetail; i++ )
			{
				t += k;
				tp = 1.0-t;
				gc.lineTo( x0*tp*tp*tp + 3*cx0*t*tp*tp + 3*cx1*t*t*tp + x*t*t*t, 
						   y0*tp*tp*tp + 3*cy0*t*tp*tp + 3*cy1*t*t*tp + y*t*t*t );
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// path commands
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function moveTo( x:Number, y:Number ):void
		{
			_commands.push( MOVE_TO );
			_vertices.push( x, y );
		}
		
		/**
		 * 
		 */
		public function lineTo( x:Number, y:Number ):void
		{
			_commands.push( LINE_TO );
			_vertices.push( x, y );
			_geom_changed = true;
		}
		
		/**
		 * 
		 */
		public function curveTo( cx:Number, cy:Number, x:Number, y:Number ):void
		{
			_commands.push( CURVE_TO );
			_vertices.push( cx, cy, x, y );
			_geom_changed = true;
		}
		
		/**
		 * 
		 */
		public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			_commands.push( BEZIER_TO );
			_vertices.push( cx0, cy0, cx1, cy1, x, y );
			_geom_changed = true;
		}
		
		/**
		 * 
		 */
		public function closePath():void
		{
			_commands.push( CLOSE_PATH );
		}
		
		
	}
	
}