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

package frocessing.core {
	
	import flash.display.BitmapData;
	import frocessing.text.FAbstractText;
	import frocessing.text.IBitmapFont;
	import frocessing.text.IFont;
	import frocessing.text.IPathFont;
	import frocessing.text.IBitmapFont;
	
	import frocessing.f5internal;
	use namespace f5internal;
	
	/**
	* Processing の vlw形式、またはベクターでテキストを描画するクラス.
	* 
	* <p>※将来的に再構成されなくなる予定です</p>
	* 
	* @author nutsu 
	* @version 0.5
	*/
	public class F5Typographics extends FAbstractText
	{
		//
		private var _fg:F5Graphics;
		
		// tmp z
		private var _z:Number = 0;
		
		/**
		 * 新しく F5TypoGraphics クラスのインスタンスを生成します.
		 */
		public function F5Typographics( fg:F5Graphics ) 
		{
			super();
			_fg = fg;
			_z  = 0;
		}
		
		/**
		 * 
		 */
		public function text( str:String, x:Number, y:Number, z:Number = 0.0 ):void
		{
			_z = z;
			if ( _font is IBitmapFont )
			{
				_fg.gc.abortStroke();
				var tmp_detail:uint = _fg.gc.imageDetail ;
				var tmp_color:uint  = _fg.tintColor;
				_fg.gc.imageDetail  = IBitmapFont(_font).imageDetail;
				_fg.tintColor       = _color;
				drawText( str, x, y );
				_fg.gc.imageDetail	= tmp_detail;
				_fg.tintColor		= tmp_color;
				_fg.gc.reapplyStroke();
			}
			else
			{
				drawText( str, x, y );
			}
			_z = 0;
		}
		
		/**
		 * 
		 */
		public function textArea( str:String, x:Number, y:Number, w:Number, h:Number, z:Number = 0.0 ):void
		{
			_z = z;
			if ( _font is IBitmapFont )
			{
				_fg.gc.abortStroke();
				var tmp_detail:uint = _fg.gc.imageDetail ;
				var tmp_color:uint  = _fg.tintColor;
				_fg.gc.imageDetail  = IBitmapFont(_font).imageDetail;
				_fg.tintColor       = _color;
				drawTextArea( str, x, y, w, h );
				_fg.gc.imageDetail 	= tmp_detail;
				_fg.tintColor		= tmp_color;
				_fg.gc.reapplyStroke();
			}
			else
			{
				drawTextArea( str, x, y, w, h );
			}
			_z = 0;
		}
		
		/**
		 * @private
		 */
		override protected function __drawBitmapCharImp( f:IBitmapFont, charcode:uint, x:Number, y:Number ):void
		{
			var glyph:int = _font.index( charcode );
			
			//Glyphデータ無し
			if ( glyph == -1 )
				return;
			
			var sc:Number = _size/f.size;			
			_fg.f5internal::_image( f.getFontImage(glyph), 
									x  + f.getOffsetX(glyph) * sc, y  - f.getOffsetY(glyph) * sc,
									f.getWidth( glyph ) * sc, f.getHeight( glyph ) * sc, _z );
		}
		
		/**
		 * @private
		 */
		override protected function __drawPathCharImp( f:IPathFont, charcode:uint, x:Number, y:Number ):void
		{
			var glyph:int = _font.index( charcode );
			
			//Glyphデータ無し
			if ( glyph == -1 )
				return;
			
			var sc:Number = _size/f.size;
			var c:Array   = f.getCommands(glyph);
			var p:Array   = f.getPathData(glyph);
			
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
						_fg.moveTo( x + p[xi] * sc, y + p[yi] * sc, _z );
						xi += 2;
						yi += 2;
						break;
					case 2:
						_fg.lineTo( x + p[xi] * sc, y + p[yi] * sc, _z );
						xi += 2;
						yi += 2;
						break;
					case 3:
						cxi = xi + 2;
						cyi = yi + 2;
						_fg._curveTo( x + p[xi] * sc, y + p[yi] * sc, _z, x + p[cxi] * sc, y + p[cyi] * sc, _z );
						xi += 4;
						yi += 4;
						break;
					default:
						break;
				}
			}
			_fg.endFill();
		}
	}
	
}