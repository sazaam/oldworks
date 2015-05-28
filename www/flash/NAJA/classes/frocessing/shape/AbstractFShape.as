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
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.LineScaleMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Graphics;
	import frocessing.core.F5Graphics;
	import frocessing.geom.FMatrix2D;
	
	import frocessing.f5internal;
	use namespace f5internal;
	
	/**
	* Abstract Shape Object
	* 
	* @author nutsu
	* @version 0.5.8
	*/
	public class AbstractFShape implements IFShape
	{
		/**
		 * 
		 */
		public var userData:Object = {};
		
		/**
		 * @private
		 */
		protected var _sysData:Object;
		
		/**
		 * @private
		 */
		protected var _name:String = "";
		
		/**
		 * @private
		 */
		protected var _parent:FShapeContainer;
		
		/**
		 * transform.
		 */
		public var matrix:FMatrix2D;
		
		//attributes -----------------------------------
		
		public var visible:Boolean = true;
		public var styleEnabled:Boolean = true;
		
		public var thickness:Number;
		public var caps:String;
		public var joints:String;
		public var pixelHinting:Boolean;
		public var scaleMode:String;
		public var miterLimit:Number;
		
		public var strokeEnabled:Boolean;
		public var strokeColor:uint;
		public var strokeAlpha:Number;
		public var strokeGradient:FShapeGradient;
		
		public var fillEnabled:Boolean;
		public var fillColor:uint;
		public var fillAlpha:Number;
		public var fillGradient:FShapeGradient;
		
		public var alpha:Number;
		
		//geometory ------------------------------------
		/**
		 * @private
		 */
		protected var _left:Number = 0;
		/**
		 * @private
		 */
		protected var _top:Number = 0;
		/**
		 * @private
		 */
		protected var _width:Number = 1;
		/**
		 * @private
		 */
		protected var _height:Number = 1;
		/**
		 * @private
		 */
		protected var _geom_changed:Boolean = false;
		
		// check
		/**
		 * @private
		 */
		protected static var __minX:Number;
		/**
		 * @private
		 */
		protected static var __maxX:Number;
		/**
		 * @private
		 */
		protected static var __minY:Number;
		/**
		 * @private
		 */
		protected static var __maxY:Number;
		
		// geometory test ------------------------------
		private static var __test:Shape = new Shape();
		
		
		/**
		 * 
		 */
		public function AbstractFShape( parent_group:FShapeContainer=null ) 
		{
			_parent = parent_group;			
			_defaultSetting();
		}
		
		/**
		 * parent group
		 */
		public function get parent():FShapeContainer { return _parent; }
		f5internal function set parent(value:FShapeContainer):void 
		{
			_parent = value;
		}
		
		/**
		 * name
		 */
		public function get name():String { return _name; }
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Style
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected function _defaultSetting():void
		{
			alpha = 1;
			if ( _parent == null )
			{
				//follow SVG initial setting
				thickness      = 0;
				caps           = CapsStyle.NONE;
				joints         = JointStyle.MITER;
				pixelHinting   = false;
				scaleMode      = LineScaleMode.NORMAL;
				miterLimit     = 4;
				
				strokeEnabled  = false;
				strokeColor    = 0x000000;
				strokeAlpha    = 1.0;
				strokeGradient = null;
				
				fillEnabled    = true;
				fillColor      = 0x000000;
				fillAlpha      = 1.0;
				fillGradient   = null;
				
				styleEnabled   = true;
			} 
			else
			{
				thickness      = _parent.thickness;
				caps           = _parent.caps;
				joints         = _parent.joints;
				pixelHinting   = _parent.pixelHinting;
				scaleMode      = _parent.scaleMode;
				miterLimit     = _parent.miterLimit;
				
				strokeEnabled  = _parent.strokeEnabled;
				strokeColor    = _parent.strokeColor;
				strokeAlpha    = _parent.strokeAlpha;
				strokeGradient = _parent.strokeGradient;
				
				fillEnabled    = _parent.fillEnabled;
				fillColor      = _parent.fillColor;
				fillAlpha      = _parent.fillAlpha;
				fillGradient   = _parent.fillGradient;
				
				styleEnabled   = _parent.styleEnabled;
			}
		}
		
		/**
		 * enable stroke, fill styles
		 */
		public function enableStyle():void
		{
			styleEnabled = true;
		}
		
		/**
		 * disable stroke, fill styles
		 */
		public function disableStyle():void
		{
			styleEnabled = false;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Transform
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function _checkmatrix():void
		{
			if ( matrix == null ) matrix = new FMatrix2D();
		}
		
		/**
		 * reset transfrom
		 */
		public function resetMatrix():void
		{
			_checkmatrix();
			matrix.identity();
		}
		
		/**
		 * translate shape
		 */
		public function translate( x:Number, y:Number ):void
		{
			_checkmatrix();
			matrix.prependTranslation( x, y );
		}
		
		/**
		 * scale shape
		 */
		public function scale( x:Number, y:Number = NaN ):void
		{
			_checkmatrix();
			if ( isNaN(y) )
				matrix.prependScale( x, x );
			else
				matrix.prependScale( x, y );
		}
		
		/**
		 * rotate shape
		 */
		public function rotate( angle:Number ):void
		{
			_checkmatrix();
			matrix.prependRotation( angle );
		}
		
		/**
		 * apply matrix
		 */
		public function applyMatrix( mat:Matrix ):void
		{
			_checkmatrix();
			matrix.prepend( mat );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// implements draw method
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * implements f5graphics draw code.
		 * @private
		 */
		protected function _draw_to_f5( fg:F5Graphics ):void
		{
			;
		}
		
		/**
		 * implements graphics draw code.
		 * @private
		 */
		protected function _draw_to_graphics( gc:Graphics ):void
		{
			;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// F5 Draw
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * draw FShape to F5Graphics.
		 * 
		 * <p>transform is applyed in F5Grraphics2D and F5Grraphics3D. </p>
		 * 
		 * @param	fg	F5Graphics,F5Graphics2D,F5Graphics3D
		 */
		public function draw( fg:F5Graphics ):void
		{
			if ( visible )
			{
				_preDraw( fg );
				_drawImp( fg );
				_postDraw( fg );
			}
		}
		
		/**
		 * @private
		 */
		private function _preDraw( fg:F5Graphics ):void
		{
			if ( matrix != null )
			{
				fg.pushMatrix();
				fg.applyMatrix2D( matrix );
			}
			
			if ( styleEnabled )
			{
				fg.pushStyle();
			}
		}
		
		/**
		 * @private
		 */
		private function _postDraw( fg:F5Graphics ):void
		{
			if ( styleEnabled )
			{
				fg.popStyle();
			}
			if ( matrix != null )
			{
				fg.popMatrix();
			}
		}
		
		/**
		 * @private
		 */
		protected function _drawImp( fg:F5Graphics ):void
		{
			if ( styleEnabled )
			{
				//stroke style
				if ( strokeEnabled )
				{
					fg.lineStyle( thickness, strokeColor, strokeAlpha*alpha, pixelHinting, scaleMode, caps, joints, miterLimit ); 
					if ( strokeGradient != null )
					{
						strokeGradient.applyStroke( fg, this );
					}
				}
				else
				{
					fg.noStroke();
				}
				
				//fill style
				if ( fillEnabled )
				{
					if ( fillGradient == null )
					{
						fg.fillColor = fillColor;
						fg.fillAlpha = fillAlpha*alpha;
						fg.applyFill();
					}
					else
					{
						fg.moveToLast();
						fillGradient.applyFill( fg, this );
					}
					_draw_to_f5( fg );//DRAW
					fg.endFill();
				}
				else
				{
					fg.noFill();
					_draw_to_f5( fg );//DRAW
				}
			}
			else
			{
				fg.applyFill();
				_draw_to_f5( fg );//DRAW
				fg.endFill();
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Draw Graphics
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * draw this shape to graphics.
		 */
		public function drawGraphics( gc:Graphics ):void
		{
			if ( styleEnabled )
			{
				if ( strokeEnabled )
				{
					gc.lineStyle( thickness, strokeColor, strokeAlpha, pixelHinting, scaleMode, caps, joints, miterLimit ); 
					if ( strokeGradient != null )
						strokeGradient.applyStrokeToGraphics( gc, this );
				}
				else
				{
					gc.lineStyle();
				}
				
				if ( fillEnabled )
				{
					gc.moveTo(0, 0);
					if ( fillGradient == null )
						gc.beginFill( fillColor, fillAlpha );
					else
						fillGradient.applyFillToGraphics( gc, this );
						
					_draw_to_graphics( gc );
					
					gc.endFill();
				}
				else
				{
					_draw_to_graphics( gc );
				}
			}
			else
			{
				_draw_to_graphics( gc );
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Sprite
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function toSprite():Sprite
		{
			if ( visible == false )
				return new Sprite();
			
			var target:Sprite = new Sprite();
			
			if ( matrix != null )
				target.transform.matrix = matrix;
			
			drawGraphics( target.graphics );
			
			target.alpha = alpha;
			
			return target;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Geometory
		//-------------------------------------------------------------------------------------------------------------------
		
		public function get left():Number
		{
			_check_geom();
			return _left;
		}
		
		public function get top():Number 
		{
			_check_geom();
			return _top;
		}
		
		public function get width():Number 
		{
			_check_geom();
			return _width;
		}
		
		public function get height():Number 
		{
			_check_geom();
			return _height;
		}
		
		//---------------------------------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		internal function _check_sprite_geom( parentObj:Sprite=null, targetSpace:DisplayObject=null ):void
		{
			if ( visible == false )
				return;
			
			if ( matrix != null )
				__test.transform.matrix = matrix;
			
			parentObj.addChild( __test );
			var r:Rectangle = _testdraw( targetSpace );
			if ( r.width > 0 && r.height > 0 )
			{
				__minX = Math.min( __minX, r.x );
				__minY = Math.min( __minY, r.y );
				__maxX = Math.max( __maxX, r.x + r.width );
				__maxY = Math.max( __maxY, r.y + r.height );
			}
		}
		
		/**
		 * @private
		 */
		protected function _check_geom():void 
		{
			if ( _geom_changed )
			{
				var r:Rectangle = _testdraw(null);
				_left   = r.x;
				_top    = r.y;
				_width  = r.width;
				_height = r.height;
				_geom_changed = false;
			}
		}
		
		private function _testdraw( targetSpace:DisplayObject=null ):Rectangle
		{
			__test.graphics.clear();
			__test.graphics.beginFill( 0, 1 );
			_draw_to_graphics( __test.graphics );
			__test.graphics.endFill();
			var r:Rectangle = __test.getRect(targetSpace);
			__test.graphics.clear();
			return r;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// reg point
		//-------------------------------------------------------------------------------------------------------------------
		/**
		 * @private
		 * change reg point
		 */
		public function zeroPoint( x:Number=0, y:Number=0, normal:Boolean=true ):void
		{
			_checkmatrix();
			_check_geom();
			if ( normal )
			{
				matrix.prependTranslation( -_left - _width * x,  -_top - _height * y );
				_left = - _width * x;
				_top  = - _height * y;
			}
			else
			{
				matrix.prependTranslation( -x, -y );
				_left -= x;
				_top  -= y;
			}
		}
		
	}
	
}