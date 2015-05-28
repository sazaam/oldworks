// --------------------------------------------------------------------------
// Project Frocessing
// ActionScript 3.0 drawing library like Processing.
// --------------------------------------------------------------------------
//
// Licensed under the MIT License
//
// Frocessing drawing library
// Copyright (C) 2008  TAKANAWA Tomoaki (http://nutsu.com) and
//					   Spark project (www.libspark.org)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

package frocessing.bmp {
	
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * TODO: copyPixels と　setPixels の比較
	 */
	/**
	* BitmapData の拡張クラスです.
	* @author nutsu
	* @version 0.2.1
	*/
	public class FBitmapData extends BitmapData {
		
		private static const zeropoint:Point = new Point();
		
		private var _keep_src:Boolean = false;
		private var _srcbitmap:BitmapData;
		
		/**
		 * 新しく FBitmapData のインスタンスを生成します.
		 */
		public function FBitmapData( width_:uint, height_:uint, transparent_:Boolean = true, bgcolor_:uint = 0xffffffff, keepOriginal_:Boolean=false  ) 
		{
			super( width_, height_, transparent_, bgcolor_ );
			if ( keepOriginal_ )
				keep = keepOriginal_;
		}
		
		
		/**
		 * アルファブレンディングで pixel の描画を行います.
		 */
		public function drawPixel( x:int, y:int, color:uint, alpha:uint=0xff ):void
		{
			var c1:uint = getPixel32( x, y );
			var a1:uint = c1 >>> 24;
			var a0:uint = alpha ^ 0xff;
			c1 &= 0x00ffffff;
			var _r:uint = ( a0 * ( c1>>16) + alpha * (color>>16) ) >> 8 ;
			var _g:uint = ( a0 * (( c1&0x00ff00 )>>8) + alpha * (( color&0x00ff00 )>>8) ) & 0xff00;
			var _b:uint = ( a0 * ( c1 & 0xff ) + alpha * ( color & 0xff ) ) >> 8;
			
			setPixel32( x, y, Math.min( a1 + alpha, 0xff ) << 24 | _r << 16 | _g | _b );
		}
		
		/**
		 * BitmapData 全体の alpha 値 を指定します.
		 */
		public function set alpha( value:Number ):void
		{
			if ( transparent )
			{
				var a:uint = Math.floor( value * 0xff ) << 24 | 0x000000;
				var alphadata:BitmapData = new BitmapData( width, height, true, a );
				copyChannel( alphadata, rect, zeropoint, BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA );
				alphadata.dispose();
				alphadata = null;
			}
			else
			{
				throw new Error( "this bitmapdata is not supported alpha channel." );
			}
		}
		
		/**
		 * オリジナルデータを保持している場合、データを復帰します.
		 */
		public function restore():void
		{
			if ( _keep_src )
				copyPixels( _srcbitmap, rect, zeropoint );
		}
		
		/**
		 * オリジナルデータを保持している場合、データを反映させます.
		 */
		public function store():void
		{
			if ( _keep_src )
				_srcbitmap.copyPixels( this, rect, zeropoint );
		}
		
		/**
		 * original bitmapdata. if not keep, return null
		 */
		public function get original():BitmapData { return _srcbitmap; 	}
		public function set original( value:BitmapData ):void
		{
			if ( width != value.width || height != value.height )
			{
				throw new ArgumentError("not match width or height.");
			}
			else
			{
				if( _srcbitmap )
					_srcbitmap.dispose();					
				_srcbitmap = value;
				_keep_src  = true;
			}
		}
		
		/**
		 * keep original bitmapdata
		 */
		public function get keep():Boolean { return _keep_src; }
		public function set keep(value:Boolean):void 
		{
			if ( _keep_src != value )
			{
				_keep_src = value;
				if ( _keep_src )
				{
					_srcbitmap = super.clone();
				}
				else
				{
					_srcbitmap.dispose();
					_srcbitmap = null;
				}
			}
		}
		
		//--------------------------------------------------------------------------------------------------- OVERRIDE
		
		/**
		 * 
		 */
		override public function clone():BitmapData
		{
			var bd:FBitmapData = new FBitmapData( width, height, transparent );
			bd.copyPixels( this, rect, zeropoint );
			if ( _keep_src )
				bd.original = _srcbitmap.clone();
			return bd;
		}
		
		/**
		 * 
		 */
		override public function dispose():void
		{
			super.dispose();
			if ( _srcbitmap )
			{
				_srcbitmap.dispose();
				_srcbitmap = null;
			}
		}
		
		//--------------------------------------------------------------------------------------------------- STATIC
		
		/**
		 * BitmapData から FBitmapData のインスタンスを生成します.
		 * @param	src
		 * @param	transparent
		 * @param	disposeSrc
		 */
		public static function BD2FBD( src:BitmapData, transparent_:Boolean=true, disposeSrc:Boolean=false ):FBitmapData
		{
			var bd:FBitmapData;
			if ( arguments.length == 1 )
				bd = new FBitmapData( src.width, src.height, src.transparent );
			else
				bd = new FBitmapData( src.width, src.height, transparent_ );
			bd.copyPixels( src, src.rect, zeropoint );
			if ( disposeSrc )
				src.dispose();
			return bd;
		}
		
		/**
		 * DisplayObject から FBitmapData のインスタンスを生成します.
		 * @param	displayobject
		 * @param	margin
		 * @param	scale
		 * @param	smooth
		 * @param	transparent
		 */
		public static function DO2FBD( displayobject:DisplayObject, margin:int=0, scaleX:Number=1, scaleY:Number=1, smooth:Boolean=false, transparent_:Boolean=true ):FBitmapData
		{
			return BD2FBD( BmpUtil.DO2BD( displayobject, margin, scaleX, scaleY, smooth ), transparent_, true );	
		}
	}
	
}