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
	
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import frocessing.color.FColor;
	import frocessing.bmp.FBitmapData;
	
	/**
	* F5BitmapData2D は、F5Graphics2D の描画を BitmapData で保持するクラスです.
	* 
	* @author nutsu
	* @version 0.5.7
	*/
	public class F5BitmapData2D extends F5Graphics2D{
		
		private var _bitmapData:FBitmapData;
		private var screenRect:Rectangle;
		private var _shape:Shape;
		private var bitmapdata_transparent:Boolean;
		private var bitmapdata_bg:uint;
		
		public var blendMode:String;
		
		/**
		 * 新しい F5BitmapData2D クラスのインスタンスを生成します.
		 * 
		 * @param	width_			BitmapData の幅
		 * @param	height_			BitmapData の高さ
		 * @param	transparent		BitmapData の transparent
		 * @param	bgcolor			BitmapData の 背景色( 32bit Color )
		 */
		public function F5BitmapData2D( width_:uint, height_:uint, transparent:Boolean = false, bgcolor:uint = 0xffcccccc )
		{
			super( (_shape = new Shape()).graphics );
			bitmapdata_transparent = transparent;
			bitmapdata_bg = bgcolor;
			_width  = width_;
			_height = height_;
			screenRect = new Rectangle( 0, 0, width_, height_ );
			_bitmapData = new FBitmapData( _width, _height, bitmapdata_transparent, bitmapdata_bg );
			gc.pixelbitmap = _bitmapData;
		}
		
		/**
		 * 描画の対象となる BitmapData を示します.
		 */
		public function get bitmapData():BitmapData { return _bitmapData; }
		
		/**
		 * 
		 */
		override public function beginDraw():void
		{
			super.beginDraw();
			_bitmapData.lock();
		}
		
		/**
		 * 描画を終了するときに実行します.このメソッドにより Graphics　の内容が BitmapData にドローされます.
		 */
		override public function endDraw():void
		{
			super.endDraw();
			_bitmapData.draw( _shape, null, null, blendMode, screenRect, gc.imageSmoothing );
			_bitmapData.unlock();
		}
		
		/**
		 * 幅と高さを設定します. このメソッドにより bitmapData のサイズが変更され、描画が初期状態になります.
		 */
		override public function size( width_:uint, height_:uint ):void
		{
			super.size( width_, height_ );
			screenRect.width = _width;
			screenRect.height = _height;
			if( _bitmapData ) _bitmapData.dispose();
			_bitmapData = new FBitmapData( _width, _height, bitmapdata_transparent, bitmapdata_bg );
			gc.pixelbitmap = _bitmapData;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function background( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void
		{
			if ( _width > 0 && _height > 0 )
			{
				__calcColor( c1, c2, c3, c4 );
				_bitmapData.fillRect( _bitmapData.rect, uint(__calc_alpha * 0xff) << 24 | __calc_color );
			}
		}
		
		/**
		 * 
		 */
		public function pixel( x:Number, y:Number ):void
		{
			moveTo( x, y );
			gc.pixel();
		}
		
		
	}
	
}