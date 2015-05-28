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

package frocessing.text 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	/**
	* BitmapData に Text を描画するクラス.
	* 
	* <p>※将来的に再構成されなくなる予定です</p>
	* 
	* @author nutsu
	* @version 0.5.8
	*/
	public class FTextBitmapData extends FAbstractText
	{
		public var bitmapData:BitmapData;
		public var smoothing:Boolean;
		public var blendMode:String   = null;
		public var clipRect:Rectangle = null;
		
		private var _matrix:Matrix;
		private var _colortrans:ColorTransform;
		private var _shape:Shape;
		private var _gc:Graphics;
		
		/**
		 * 
		 */
		public function FTextBitmapData( target:BitmapData ) 
		{
			super();
			this.bitmapData = target;
			_matrix			= new Matrix();
			_colortrans		= new ColorTransform();
			_shape			= new Shape();
			_gc				= _shape.graphics;
			smoothing		= false;
		}
		
		/**
		 * @private
		 */
		override protected function __drawBitmapCharImp(f:IBitmapFont, charcode:uint, x:Number, y:Number):void 
		{
			var glyph:int = _font.index( charcode );
			
			//Glyphデータ無し
			if ( glyph == -1 )
				return;
			
			var sw:Number      = _size / f.size; // f.fwidth;
			var sh:Number      = _size / f.size; // f.fheight;
			var img:BitmapData = f.getFontImage(glyph);
			
			_matrix.tx = x + f.getOffsetX(glyph) * sw;
			_matrix.ty = y - f.getOffsetY(glyph) * sh;
			_matrix.a  = sw;
			_matrix.d  = sh;
			
			bitmapData.draw( img, _matrix, _colortrans, blendMode, clipRect, smoothing );
		}
		
		/**
		 * @private
		 */
		override protected function __drawPathCharImp(f:IPathFont, charcode:uint, x:Number, y:Number):void 
		{
			var glyph:int = _font.index( charcode );
			
			//Glyphデータ無し
			if ( glyph == -1 )
				return;
			
			var sc:Number = _size/f.size;
			var c:Array   = f.getCommands( glyph );
			var p:Array   = f.getPathData( glyph );
			
			var clen:int = c.length;
			var xi:int   = 0;
			var yi:int   = 1;
			var cxi:int;
			var cyi:int;
			
			_gc.clear();
			
			_gc.beginFill( 0xffffff );
			for ( var i:int = 0; i < clen ; i++ )
			{
				switch( c[i] )
				{
					case 1:
						_gc.moveTo( x + p[xi] * sc, y + p[yi] * sc );
						xi += 2;
						yi += 2;
						break;
					case 2:
						_gc.lineTo( x + p[xi] * sc, y + p[yi] * sc );
						xi += 2;
						yi += 2;
						break;
					case 3:
						cxi = xi + 2;
						cyi = yi + 2;
						_gc.curveTo( x + p[xi] * sc, y + p[yi] * sc, x + p[cxi] * sc, y + p[cyi] * sc );
						xi += 4;
						yi += 4;
						break;
					default:
						break;
				}
			}
			_gc.endFill();
			bitmapData.draw( _shape, null, _colortrans, blendMode, clipRect, smoothing );
		}
		
		/**
		 * 32 bit color
		 */
		override public function set color(value:uint):void 
		{
			_color = value;
			if ( _color != 0xffffffff )
			{
				_colortrans.alphaMultiplier = ( _color >>>24 ) / 0xff;
				_colortrans.redMultiplier   = ( _color >> 16 & 0xff) / 0xff;
				_colortrans.greenMultiplier = ( _color >>8 & 0xff) / 0xff;
				_colortrans.blueMultiplier  = ( _color & 0xff) / 0xff;
			}
			else
			{
				_colortrans.alphaMultiplier = 1;
				_colortrans.redMultiplier   = 1;
				_colortrans.greenMultiplier = 1;
				_colortrans.blueMultiplier  = 1;
			}
		}
	}
	
}