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

package frocessing.core {
	
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import frocessing.bmp.FBitmapData;
	
	/**
	* F5BitmapData3D は、F5Graphics3D の描画を BitmapData で保持するクラスです.
	* 
	* @author nutsu
	* @version 0.2.1
	*/
	public class F5BitmapData3D extends F5Graphics3D{
		
		private var _bitmapData:FBitmapData;
		private var screenRect:Rectangle;
		private var _shape:Shape;
		private var bitmapdata_transparent:Boolean;
		
		/**
		 * 新しい F5BitmapData3D クラスのインスタンスを生成します.
		 * 
		 * @param	width_			BitmapData の幅
		 * @param	height_			BitmapData の高さ
		 * @param	transparent_	BitmapData の transparent
		 * @param	bgcolor			BitmapData の 背景色( 32bit Color )
		 */
		public function F5BitmapData3D( width_:uint, height_:uint, transparent_:Boolean=false, bgcolor:uint=0xffcccccc ){
			super( (_shape = new Shape()).graphics, width_, height_ );
			bitmapdata_transparent = transparent_;
			_background.value32 = bgcolor;
			_bitmapData = new FBitmapData( _width, _height, bitmapdata_transparent, _background.value32 );
			__renderGC.pixelbitmap = _bitmapData;
		}
		
		/**
		 * 描画の対象となる BitmapData を示します.
		 */
		public function get bitmapData():BitmapData { return _bitmapData; }
		
		/**
		 * 描画を終了するときに実行します.このメソッドにより Graphics　の内容が BitmapData にドローされます.
		 */
		override public function endDraw():void
		{
			super.endDraw();
			_bitmapData.draw( _shape, null, null, null, screenRect, imageSmoothing );
		}
		
		/**
		 * 幅と高さを設定します. このメソッドにより bitmapData のサイズが変更され、描画が初期状態になります.
		 */
		override public function size( width_:uint, height_:uint ):void
		{
			super.size( width_, height_ );
			screenRect.width = width_;
			screenRect.height = height_;
			if ( _bitmapData ) _bitmapData.dispose();
			_bitmapData = new FBitmapData( width_, height_, bitmapdata_transparent, _background.value32 );
		}
		
		public function pixel( x:Number, y:Number, z:Number ):void
		{
			moveTo3d( x, y, z );
			__renderGC.pixel( _startX, _startY, _startZ, __renderGC.strokeColor, __renderGC.strokeAlpha );
		}
	}
	
}