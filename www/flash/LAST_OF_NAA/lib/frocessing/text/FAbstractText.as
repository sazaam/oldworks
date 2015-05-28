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

package frocessing.text {
	
	import frocessing.core.F5C;
	import frocessing.utils.IObjectLoader;
	
	/**
	* Abstract Text Render.
	* 
	* <p>※将来的に再構成されなくなる予定です</p>
	* 
	* @author nutsu
	* @version 0.5.8
	* 
	* @see frocessing.core.F5Typographics
	* @see frocessing.text.FTextBitmapData
	*/
	public class FAbstractText 
	{
		// text align
		public static const CENTER  :int = F5C.CENTER;
		public static const LEFT    :int = F5C.LEFT;
		public static const RIGHT   :int = F5C.RIGHT;
		
		// text y align
		public static const BASELINE:int = F5C.BASELINE;
		public static const TOP     :int = F5C.TOP;
		public static const BOTTOM  :int = F5C.BOTTOM;
		
		// 
		private var __loadcheck:Boolean = false;
		
		// format
		/** @private */
		protected var _font:IFont;
		/** @private */
		protected var _size:Number;
		/** @private */
		protected var _leading:Number;
		/** @private */
		protected var _letterspacing:Number;
		/** @private */
		protected var _align:int;
		/** @private */
		protected var _valign:int;
		/** @private */
		protected var _color:uint;
		
		// string buffer
		private var buffer:String;
		private var buffer_length:int;
		
		// space
		private var char_sp:uint = String(" ").charCodeAt(0);
		
		/**
		 * 
		 */
		public function FAbstractText() 
		{
			_size          = 12;
			_leading       = 14;
			_letterspacing = 0;
			_align         = LEFT;
			_valign        = BASELINE;
		}
		
		//------------------------------------------------------------------------------------------------------------------- Draw
		
		/**
		 * フォントと文字のサイズを指定します.
		 * @param	font
		 * @param	fontSize
		 */
		public function textFont( font:IFont, fontSize:Number=NaN ):void
		{
			_font = font;
			if ( fontSize > 0 )
				size = fontSize;
			else
				size = _font.size;
			
			if ( font is IObjectLoader )
				__loadcheck = true;
		}
		
		/**
		 * 指定されているフォント.
		 */
		public function get font():IFont
		{
			return _font;
		}
		
		//------------------------------------------------------------------------------------------------------------------- Format
		
		/**
		 * 文字のサイズを示します.
		 */
		public function get size():Number { return _size; }
		public function set size(value:Number):void 
		{
			if ( !(_font == null) )
			{
				_size    = value;
				_leading = value * (_font.ascent + _font.descent) * 1.275;
			}
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
		public function get align():int { return _align; }
		public function set align(value:int):void 
		{
			_align = value;
		}
		
		/**
		 * 文字の vertical align を指定します.
		 */
		public function get alignY():int { return _valign; }
		public function set alignY(value:int):void 
		{
			_valign = value;
		}
		
		/**
		 * 
		 */
		public function textAscent():Number
		{
			if( _font == null )
				return NaN;
			return _font.ascent * _size;
		}
		
		/**
		 * 
		 */
		public function textDescent():Number
		{
			if( _font == null )
				return NaN;
			return _font.descent * _size;
		}
		
		/**
		 * 
		 */
		public function get color():uint { return _color; }
		public function set color(value:uint):void 
		{
			_color = value;
		}
		
		//------------------------------------------------------------------------------------------------------------------- Draw
		
		/**
		 * @private
		 */
		protected function __drawBitmapCharImp( f:IBitmapFont, charcode:uint, x:Number, y:Number ):void
		{
			;//override
		}
		
		/**
		 * @private
		 */
		protected function __drawPathCharImp( f:IPathFont, charcode:uint, x:Number, y:Number ):void
		{
			;//override
		}
		
		/**
		 * @private
		 */
		private function __text( start:int, stop:int, x:Number, y:Number ):void
		{
			if ( _align == CENTER )
				x -= __textWidth( buffer, start, stop ) * 0.5;
			else if ( _align == RIGHT )
				x -= __textWidth( buffer, start, stop );
			
			var index:int;
			if ( _font is IBitmapFont )
			{
				// use PFont : bitmap font
				var pf:IBitmapFont = IBitmapFont( _font );
				for ( index = start; index < stop; index++ )
				{
					__drawBitmapCharImp( pf, buffer.charCodeAt(index), x, y );
					x += _font.charWidth( buffer.charCodeAt(index) ) * _size + _letterspacing;
				}
			}
			else if ( _font is IPathFont )
			{
				// use FFont : graphic path font
				var ff:IPathFont = IPathFont( _font );
				for ( index = start; index < stop; index++ )
				{
					__drawPathCharImp( ff, buffer.charCodeAt(index), x, y );
					x += _font.charWidth( buffer.charCodeAt(index) ) * _size + _letterspacing;
				}
			}
		}
		
		/**
		 * テキストを描画します.
		 */
		public function drawText( str:String, x:Number, y:Number ):void
		{
			if ( _font == null )
			{
				throw new Error( "font is not selected." );
			}
			else if ( __loadcheck && _font.size > 0 )
			{
				size = ( _size < 0 ) ? _font.size : _size;
				__loadcheck = false;
			}
			
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
			
			//draw with align
			var start:int;
			var index:int;
			while ( index < buffer_length )
			{
				if ( buffer.charAt(index) == "\r" || buffer.charAt(index) == "\n" )
				{
					__text( start, index, x, y );
					start = index + 1;
					y += _leading;
				}
				index++;
			}
			if ( start < buffer_length )
				__text( start, index, x, y );
			
		}
		
		/**
		 * 指定の Rect 内にテキストを描画します.
		 */
		public function drawTextArea( str:String, x:Number, y:Number, w:Number, h:Number ):void
		{
			if ( _font == null )
			{
				throw new Error( "font is not selected." );
			}
			else if ( __loadcheck && _font.size > 0 )
			{
				size = ( _size < 0 ) ? _font.size : _size;
				__loadcheck = false;
			}
			
			buffer = str;
			buffer_length = buffer.length;
			
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
					var wordWidth:Number = __textWidth( buffer, wordStart, index );
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
								wordWidth = __textWidth( buffer, wordStart, index );
							} while ( wordWidth > w );
							
							__text( lineStart, index, lineX, currentY );
						}
						else
						{
							__text( lineStart, wordStop, lineX, currentY );
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
						__text( lineStart, index, lineX, currentY );
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
				__text( lineStart, index, lineX, currentY );
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
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
			var _w:Number    = 0;
			var index   :int = 0;
			var start   :int = 0;
			
			while (index < length)
			{
				if ( str.charAt(index) == "\r" || str.charAt(index) == "\n"  )
				{
					_w = __textWidth( str, start, index );
					if ( _w > wide )
						wide = _w;
					start = index+1;
				}
				index++;
			}
			if (start < length)
			{
				_w = __textWidth(str, start, index);
				if ( _w > wide )
					wide = _w;
			}
			return wide;
		}
		
		/**
		 * @private
		 */
		private function __textWidth( str:String, start:int, stop:int ):Number
		{
			var wide:Number = 0;
			for ( var i:int = start; i < stop; i++) {
				wide += _font.charWidth( str.charCodeAt(i) ) * _size;
			}
			return wide;
		}
	}
	
}