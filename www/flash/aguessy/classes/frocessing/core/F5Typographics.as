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

package frocessing.core 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import frocessing.core.F5Graphics;
	import frocessing.core.DrawMode;
	import frocessing.text.IFont;
	import frocessing.text.PFont;
	import frocessing.text.FFont;
	import frocessing.f5internal;
	
	use namespace f5internal;
	
	/**
	* Processing の vlw形式、またはベクターでテキストを描画するクラス
	* @author nutsu 
	* @version 0.2
	*/
	public class F5Typographics 
	{
		public static const CENTER  :String = "center";
		public static const LEFT    :String = "left";
		public static const RIGHT   :String = "right";
		public static const BASELINE:String = "baseline";
		public static const TOP     :String = "top";
		public static const BOTTOM  :String = "bottom";
		
		private var _fg:F5Graphics;
		private var _font:IFont;
		private var _draw_type:int;
		
		private var _size:Number;
		private var _leading:Number;
		private var _letterspacing:Number;
		private var _align:String;
		private var _valign:String;
		
		private var buffer:String;
		private var buffer_length:int;
		
		private var char_sp:uint = String(" ").charCodeAt(0);
		
		private var _z:Number = 0;
		
		private var target_bd:BitmapData;
		private var draw_mtx:Matrix;
		private var draw_ct:ColorTransform;
		private var draw_smoothing:Boolean;
		private var gc_draw_bitmap:Shape;
		
		internal var bitmap_mode:Boolean;
		
		/**
		 * 新しく F5TypoGraphics クラスのインスタンスを生成します.
		 */
		public function F5Typographics( fg_:F5Graphics ) 
		{
			_fg            = fg_;
			_size          = 12;
			_leading       = 14;
			_letterspacing = 0;
			_align         = LEFT;
			_valign        = BASELINE;
			draw_mtx       = new Matrix();
			draw_ct        = new ColorTransform();
			gc_draw_bitmap = new Shape();
			bitmap_mode    = false;
		}
		
		//--------------------------------------------------------------------------------------------------- Attributes
		
		/**
		 * フォントと文字のサイズを指定します.
		 * @param	font
		 * @param	fontSize
		 */
		public function setFont( font:IFont, fontSize:Number ):void
		{
			_font = font;
			size  = fontSize;
			if ( _font is PFont )
			{
				_draw_type = 1;
				bitmap_mode = true;
			}
			else if ( _font is FFont )
			{
				_draw_type = 2;
				bitmap_mode = false;
			}
			else
			{
				_draw_type = 0;
			}
		}
		
		/**
		 * 文字のサイズを示します.
		 */
		public function get size():Number { return _size; }
		public function set size(value:Number):void 
		{
			if( _font == null )
				throw new Error( "font is not selected." );
			_size    = value;
			_leading = value * (_font.ascent + _font.descent) * 1.275;
		}
		
		/**
		 * 行間を示します.
		 */
		public function get leading():Number { return _leading; }
		public function set leading(value:Number):void 
		{
			_leading = value;
		}
		
		/**
		 * 文字間をしてします.
		 */
		public function get letterSpacing():Number { return _letterspacing; }
		public function set letterSpacing(value:Number):void 
		{
			_letterspacing = value;
		}
		
		/**
		 * 文字の align を指定します.
		 */
		public function get align():String { return _align; }
		public function set align(value:String):void 
		{
			_align = value;
		}
		
		/**
		 * 
		 */
		public function textAscent():Number
		{
			if( _font == null )
				throw new Error( "font is not selected." );
			return _font.ascent * _size;
		}
		
		/**
		 * 
		 */
		public function textDescent():Number
		{
			if( _font == null )
				throw new Error( "font is not selected." );
			return _font.descent * _size;
		}
		
		//--------------------------------------------------------------------------------------------------- Draw
		
		/**
		 * @private
		 */
		private function charPFont( f:PFont, charcode:uint, x:Number, y:Number ):void
		{
			var glyph:int = _font.index( charcode );
			
			//Glyphデータ無し
			if ( glyph == -1 )
				return;
			
			var fw:Number      = f.fwidth;
			var fh:Number      = f.fheight;
			var w:Number       = f.width[glyph];
			var h:Number       = f.height[glyph];
			var bwidth:Number  = w / fw;
			var high:Number    = h / fh;
			var lextent:Number = f.leftExtent[glyph] / fw;
			var textent:Number = f.topExtent[glyph]  / fh;
			
			var img:BitmapData = f.getFontImage(glyph);
			
			var x1:Number = x  + lextent * _size;
			var y1:Number = y  - textent * _size;
			var x2:Number = x1 + bwidth * _size;
			var y2:Number = y1 + high * _size;
			
			_fg.f5DrawBitmapFont( img, x1, y1, x2, y2, _z );
		}
		
		/**
		 * @private
		 */
		private function charPFontToBitmapData( f:PFont, charcode:uint, x:Number, y:Number ):void
		{
			var glyph:int = _font.index( charcode );
			
			//Glyphデータ無し
			if ( glyph == -1 )
				return;
			
			var sw:Number      = _size / f.fwidth;
			var sh:Number      = _size / f.fheight;
			var img:BitmapData = f.getFontImage(glyph);
			
			draw_mtx.tx = x + f.leftExtent[glyph] * sw;
			draw_mtx.ty = y - f.topExtent[glyph] * sh;
			draw_mtx.a  = sw;
			draw_mtx.d  = sh;
			
			target_bd.draw( img, draw_mtx, draw_ct, null, null, draw_smoothing );
		}
		
		/**
		 * @private
		 */
		private function charFFont( f:FFont, charcode:uint, x:Number, y:Number ):void
		{
			var glyph:int = _font.index( charcode );
			
			//Glyphデータ無し
			if ( glyph == -1 )
				return;
			
			var sc:Number = _size/f.size;
			var c:Array   = f.commands[glyph];
			var p:Array   = f.paths[glyph];
			
			var clen:int = c.length;
			var xi:int   = 0;
			var yi:int   = 1;
			var cxi:int;
			var cyi:int;
			_fg.applyFill();
			for ( var i:int = 0; i < clen ; i++ )
			{
				switch( c[i] )
				{
					case 1:
						_fg.f5internal::f5moveTo( x + p[xi] * sc, y + p[yi] * sc, _z );
						xi += 2;
						yi += 2;
						break;
					case 2:
						_fg.f5internal::f5lineTo( x + p[xi] * sc, y + p[yi] * sc, _z );
						xi += 2;
						yi += 2;
						break;
					case 3:
						cxi = xi + 2;
						cyi = yi + 2;
						_fg.f5internal::f5curveTo( x + p[xi] * sc, y + p[yi] * sc, _z,
												   x + p[cxi] * sc, y + p[cyi] * sc, _z );
						xi += 4;
						yi += 4;
						break;
					default:
						break;
				}
			}
			_fg.endFill();
		}
		
		/**
		 * @private
		 */
		private function charFFontToBitmap( f:FFont, charcode:uint, x:Number, y:Number ):void
		{
			var glyph:int = _font.index( charcode );
			
			//Glyphデータ無し
			if ( glyph == -1 )
				return;
			
			var sc:Number = _size/f.size;
			var c:Array   = f.commands[glyph];
			var p:Array   = f.paths[glyph];
			
			var clen:int = c.length;
			var xi:int   = 0;
			var yi:int   = 1;
			var cxi:int;
			var cyi:int;
			
			var g:Graphics = gc_draw_bitmap.graphics;
			g.clear();
			
			g.beginFill( 0xffffff );
			for ( var i:int = 0; i < clen ; i++ )
			{
				switch( c[i] )
				{
					case 1:
						g.moveTo( x + p[xi] * sc, y + p[yi] * sc );
						xi += 2;
						yi += 2;
						break;
					case 2:
						g.lineTo( x + p[xi] * sc, y + p[yi] * sc );
						xi += 2;
						yi += 2;
						break;
					case 3:
						cxi = xi + 2;
						cyi = yi + 2;
						g.curveTo( x + p[xi] * sc, y + p[yi] * sc, x + p[cxi] * sc, y + p[cyi] * sc );
						xi += 4;
						yi += 4;
						break;
					default:
						break;
				}
			}
			g.endFill();
			target_bd.draw( gc_draw_bitmap, null, draw_ct, null, null, draw_smoothing );
			g.clear();
		}
		
		/**
		 * @private
		 */
		private function textLine( start:int, stop:int, x:Number, y:Number ):void
		{
			if ( _align == CENTER )
				x -= text_width( buffer, start, stop) * 0.5;
			else if ( _align == RIGHT )
				x -= text_width( buffer, start, stop);
			
			var index:int;
			if ( _draw_type == 1 )
			{
				// use PFont : bitmap font
				var pf:PFont = PFont( _font );
				for ( index = start; index < stop; index++ )
				{
					charPFont( pf, buffer.charCodeAt(index), x, y );
					/**
					 * TODO:kerning
					 */
					x += _font.charWidth( buffer.charCodeAt(index) ) * _size + _letterspacing;
				}
			}
			else if ( _draw_type == 2 )
			{
				var ff:FFont = FFont( _font );
				for ( index = start; index < stop; index++ )
				{
					charFFont( ff, buffer.charCodeAt(index), x, y );
					x += _font.charWidth( buffer.charCodeAt(index) ) * _size + _letterspacing;
				}
			}
			else if ( _draw_type == 11 )
			{
				var pf2:PFont = PFont( _font );
				for ( index = start; index < stop; index++ )
				{
					charPFontToBitmapData( pf2, buffer.charCodeAt(index), x, y );
					x += _font.charWidth( buffer.charCodeAt(index) ) * _size + _letterspacing;
				}
			}
			else if ( _draw_type == 12 )
			{
				var ff2:FFont = FFont( _font );
				for ( index = start; index < stop; index++ )
				{
					charFFontToBitmap( ff2, buffer.charCodeAt(index), x, y );
					x += _font.charWidth( buffer.charCodeAt(index) ) * _size + _letterspacing;
				}
			}
		}
		
		/**
		 * テキストを描画します.
		 * 
		 * @param	string
		 * @param	x
		 * @param	y
		 * @param	z
		 */
		public function drawText( str:String, x:Number, y:Number, z:Number = 0.0 ):void
		{
			if( _font == null )
				throw new Error( "font is not selected." );
			
			_z = z;
			
			buffer = str;
			buffer_length = buffer.length;
			
			var i:int;
			var high:Number = 0;
			for ( i = 0; i < buffer_length; i++ )
			{
				if ( buffer.charAt(index) == "\r" || buffer.charAt(index) == "\n" )
					high += _leading;
			}
			
			//Vartical Align
			if ( _valign == CENTER)
				y += ( _font.ascent * _size - high )*0.5;
			else if ( _valign == TOP)
				y += _font.ascent * _size;
			else if ( _valign == BOTTOM)
				y -= high;
			
			//Align
			var start:int;
			var index:int;
			while ( index < buffer_length )
			{
				if ( buffer.charAt(index) == "\r" || buffer.charAt(index) == "\n" )
				{
					textLine( start, index, x, y );
					start = index + 1;
					y += _leading;
				}
				index++;
			}
			if ( start < buffer_length )
				textLine( start, index, x, y );
			
		}
		
		/**
		 * 指定の Rect 内にテキストを描画します.
		 * 
		 * @param	string
		 * @param	x
		 * @param	y
		 * @param	w
		 * @param	h
		 * @param	z
		 */
		public function drawTextRect( str:String, x:Number, y:Number, w:Number, h:Number, z:Number = 0.0 ):void
		{
			buffer = str;
			buffer_length = buffer.length;
			
			_z = z;
			
			var spaceWidth:Number = _font.charWidth( char_sp ) * _size;
			var runningX :Number  = x;
			var currentY:Number   = y;
			var x2:Number         = x + w;
			var y2:Number         = y + h;
			
			//行開始位置
			var lineX:Number      = x;
			if ( _align == CENTER )
				lineX = lineX + w*0.5;
			else if ( _align == RIGHT )
				lineX = x2;
			
			currentY += _font.ascent;
			//エリアに一行も入らない場合は終了
			if ( currentY > y2 )
				return;

			var wordStart:int = 0;
			var wordStop:int  = 0;
			var lineStart:int = 0;
			var index:int     = 0;
			
			while ( index < buffer_length ) 
			{
				if ( ( buffer.charAt(index) == " " ) || ( index == buffer_length - 1) ) 
				{	
					// 単語の区切り
					var wordWidth:Number = text_width( buffer, wordStart, index );
					if ( runningX + wordWidth > x2 ) 
					{
						// out of box
						if ( runningX == x ) 
						{
							do
							{
								index--;
								if (index == wordStart)
								{
									//一文字も入らない
									return;
								}
								wordWidth = text_width( buffer, wordStart, index );
							} while ( wordWidth > w );
							
							textLine( lineStart, index, lineX, currentY );
						}
						else
						{
							textLine( lineStart, wordStop, lineX, currentY );
							index = wordStop;
							while ( ( index < buffer_length ) && ( buffer.charAt(index) == " " )) 
							{
								index++;
							}
						}
						lineStart = index;
						wordStart = index;
						wordStop  = index;
						runningX  = x;
						currentY += _leading;
						
						//これ以上表示アリアに入らない
						if (currentY > y2)
							return;
					} 
					else
					{
						runningX += wordWidth + spaceWidth;
						wordStop  = index;
						wordStart = index + 1;
					}
				} 
				else if ( buffer.charAt(index) == "\r" || buffer.charAt(index) == "\n" ) 
				{	
					//改行
					if (lineStart != index) 
					{
						//空行ではない場合
						textLine( lineStart, index, lineX, currentY );
					}
					lineStart = index + 1;
					wordStart = lineStart;
					runningX  = x;
					currentY += _leading;
					
					//これ以上表示アリアに入らない
					if (currentY > y2)
						return;
				}
				index++;
			}
			
			if ( (lineStart < buffer_length ) && ( lineStart != index ))
			{
				//空行ではない場合
				textLine( lineStart, index, lineX, currentY );
			}
		}
		
		//--------------------------------------------------------------------------------------------------- make bitmap
		
		/**
		 * BitmapData にテキストを描画します.
		 * 
		 * @param	target	target bitmapData
		 * @param	str		text
		 * @param	color	32bit color
		 * @param	x
		 * @param	y
		 * @param	w
		 * @param	h
		 * @param	smoothing
		 */
		public function draw( target:BitmapData, str:String, color:uint, x:Number, y:Number, w:Number=0, h:Number=0, smoothing:Boolean=false ):void
		{
			target_bd = target;
			draw_smoothing = smoothing;
			_draw_type += 10;
			
			if ( color != 0xffffffff )
			{
				draw_ct.alphaMultiplier = ( (color & 0xff000000) >>> 24 ) / 0xff;
				draw_ct.redMultiplier   = ( (color & 0x00ff0000) >>> 16 ) / 0xff;
				draw_ct.greenMultiplier = ( (color & 0x0000ff00) >>> 8  ) / 0xff;
				draw_ct.blueMultiplier  = (color & 0x000000ff) / 0xff;
			}
			else
			{
				draw_ct.alphaMultiplier = 1;
				draw_ct.redMultiplier   = 1;
				draw_ct.greenMultiplier = 1;
				draw_ct.blueMultiplier  = 1;
			}
			
			if ( w * h == 0 )
				drawText( str, x, y );
			else
				drawTextRect( str, x, y, w, h );
			
			_draw_type -= 10;
		}
		
		//--------------------------------------------------------------------------------------------------- Size
		
		/**
		 * テキストの表示幅を返します.
		 * @param	str
		 * @return
		 */
		public function textWidth( str:String ):Number
		{
			if( !_font )
				throw new Error( "font is not selected." );
			
			var length  :int = str.length;
			var wide :Number = 0;
			var index   :int = 0;
			var start   :int = 0;
			
			while (index < length)
			{
				if ( str.charAt(index) == "\r" || str.charAt(index) == "\n"  )
				{
					wide = Math.max( wide, text_width( str, start, index ) );
					start = index+1;
				}
				index++;
			}
			if (start < length)
			{
				wide = Math.max( wide, text_width(str, start, index));
			}
			return wide;
		}
		
		/**
		 * @private
		 */
		private function text_width( str:String, start:int, stop:int ):Number
		{
			var wide:Number = 0;
			for ( var i:int = start; i < stop; i++) {
				wide += _font.charWidth( str.charCodeAt(i) ) * _size;
			}
			return wide;
		}		
	}
	
}