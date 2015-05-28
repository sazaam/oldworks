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
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import frocessing.geom.FViewBox;
	
	import frocessing.core.F5Graphics;
	import frocessing.f5internal;
	use namespace f5internal;
	
	/**
	* Shape Group
	* 
	* @author nutsu
	* @version 0.5.8
	*/
	public class FShapeContainer extends AbstractFShape implements IFShape
	{
		/**
		 * AbstractFShape[]
		 * @private
		 */
		protected var _children:Array;
		/**
		 * @private
		 */
		protected var _childCount:int;
		
		//
		public var viewbox:FViewBox;
		
		/**
		 * 
		 */
		public function FShapeContainer( parent_group:FShapeContainer=null ) 
		{
			super( parent_group );
			
			//
			_children   = [];
			_childCount = 0;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Contaniner
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * enable stroke, fill styles
		 */
		override public function enableStyle():void
		{
			styleEnabled = true;
			for ( var i:int = 0; i < _childCount ; i++ )
			{
				AbstractFShape(_children[i]).enableStyle();
			}
		}
		
		/**
		 * disable stroke, fill styles
		 */
		override public function disableStyle():void
		{
			styleEnabled = false;
			for ( var i:int = 0; i < _childCount ; i++ )
			{
				AbstractFShape(_children[i]).disableStyle();
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Contaniner
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * get children number.
		 */
		public function getChildCount():uint
		{
			return _childCount;
		}
		
		/**
		 * get child by index
		 */
		public function getChildAt( index:int ):AbstractFShape
		{
			if( index < _childCount )
				return AbstractFShape(_children[index]);
			else
				return null;
		}
		
		/**
		 * get child by name
		 */
		public function getChild( target:String ):AbstractFShape 
		{
			if ( _name == target ) 
				return this;
				
			for ( var i:int = 0; i < _childCount; i++ )
			{
				var c:AbstractFShape = AbstractFShape(_children[i]);
				if ( c.name == target )
				{
					return c;
				}
				else if ( c is FShapeContainer )
				{
					var d:AbstractFShape = FShapeContainer(c).getChild( target );
					if ( d != null )
						return d;
				}
			}
			return null;
		}
		
		/**
		 * find child by name. findChild() seek in parent too.
		 */
		public function findChild( target:String ):AbstractFShape 
		{
			if ( _parent == null )
				return getChild(target);
			else
				return _parent.findChild(target);
		}
		
		/**
		 * add FShape Object
		 */
		public function addChild( shape:AbstractFShape ):AbstractFShape
		{
			if ( shape !== this )
			{
				_children[_childCount] = shape;
				_childCount++;
				_geom_changed = true;
				/*
				if ( shape._parent != null &&  shape._parent!==this )
				{
					shape._parent.removeChild( shape );
				}
				*/
				//shape.f5internal::parent = this;
				return shape;
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * remove FShape Object
		 */
		public function removeChild( shape:AbstractFShape ):AbstractFShape
		{
			var index:int = _children.indexOf( shape );
			if ( index > -1 )
			{
				_children.splice( index, 1 );
				_childCount--;
				_geom_changed = true;
				return shape;
			}
			else
			{
				return null;
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// implements draw method
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override protected function _draw_to_f5( fg:F5Graphics ):void
		{
			for ( var i:int = 0; i < _childCount ; i++ )
			{
				AbstractFShape(_children[i]).draw( fg );
			}
		}
		
		/**
		 * @private
		 */
		override protected function _drawImp(fg:F5Graphics):void 
		{
			_draw_to_f5( fg );
		}
		
		override public function drawGraphics(gc:Graphics):void 
		{
			_draw_to_graphics( gc );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Sprite
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * make Sprite Instance.
		 */
		override public function toSprite():Sprite
		{
			if ( visible == false )
				return null;
			
			var target:Sprite = new Sprite();
			
			if ( matrix != null )
				target.transform.matrix = matrix;
			
			for ( var i:int = 0; i < _childCount; i++ )
			{
				var s:Sprite = AbstractFShape( _children[i]).toSprite();
				if ( s != null )
					target.addChild(s);
			}
			
			target.alpha = alpha;
			
			return target;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Geometory
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override internal function _check_sprite_geom( parentObj:Sprite=null, targetSpace:DisplayObject = null ):void 
		{
			if ( visible == false )
				return;
				
			var _test:Sprite = new Sprite();
			if ( matrix != null )
				_test.transform.matrix = matrix;
			
			if ( targetSpace == null )
				targetSpace = _test;
			
			if ( parentObj != null )
				parentObj.addChild( _test );
			
			for ( var i:int = 0; i < _childCount; i++ )
			{
				AbstractFShape(_children[i])._check_sprite_geom( _test, targetSpace );
			}
			_test = null;
		}
		
		/**
		 * @private
		 */
		override protected function _check_geom():void 
		{
			if ( _geom_changed )
			{
				__minX = __minY = Number.MAX_VALUE;
				__maxX = __maxY = Number.MIN_VALUE;
				_check_sprite_geom(null,null);
				_left   = __minX;
				_top    = __minY;
				_width  = __maxX - __minX;
				_height = __maxY - __minY;
				_geom_changed = false;
			}
		}
	}
	
}