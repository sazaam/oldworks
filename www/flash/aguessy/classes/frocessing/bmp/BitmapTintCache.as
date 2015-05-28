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

package frocessing.bmp 
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import flash.geom.ColorTransform;
	import flash.utils.getTimer;
	
	/**
	* カラー調整した BitmapData を保持する為のクラスです.
	* @author nutsu
	* @version 0.2
	*/
	public class BitmapTintCache 
	{
		private var d:Dictionary;
		private var ct:ColorTransform;
		
		/**
		 * 新しく BitmapTintCache クラスのインスタンスを生成します.
		 */
		public function BitmapTintCache()
		{
			d  = new Dictionary(false);
			ct = new ColorTransform();
		}
		
		/**
		 * カラー調整した BitmapData を取得します.
		 * 
		 * <p>指定の TintColor に対応した BitmapData が存在しない場合、カラー調整したデータを生成して返します.</p>
		 * 
		 * @param	src		
		 * @param	color32	tint color
		 * @return
		 */
		public function getTintImage( src:BitmapData, color32:uint ):BitmapData
		{
			if ( color32 != 0xffffffff )
			{
				if ( d[src] )
				{
					if ( d[src][color32] == null )
						d[src][color32] = tint( src, color32 );
				}
				else
				{
					d[src] = [];
					d[src][color32] = tint( src, color32 );
				}
				return d[src][color32];
			}
			else
			{
				return src;
			}
		}
		
		/**
		 * @private
		 */
		private function tint( src:BitmapData, color32:uint ):BitmapData
		{
			var img:BitmapData = src.clone();
			ct.alphaMultiplier = ( (color32 & 0xff000000) >>> 24 ) / 0xff;
			ct.redMultiplier   = ( (color32 & 0x00ff0000) >>> 16 ) / 0xff;
			ct.greenMultiplier = ( (color32 & 0x0000ff00) >>> 8  ) / 0xff;
			ct.blueMultiplier  = (color32 & 0x000000ff) / 0xff;
			img.colorTransform( img.rect, ct );
			return img;
		}
		
		/**
		 * 保持しているカラー調整済み BitmapData を dispose します.
		 * @param	img	nullを指定した場合、全てのデータを dispose します.
		 */
		public function dispose( targetSrcImg:BitmapData=null ):void
		{
			var d2:Array;
			var tintImg:BitmapData;
			if ( targetSrcImg == null )
			{
				for ( var img:* in d )
				{
					d2 = d[img];
					for each ( tintImg in d2 )
					{
						tintImg.dispose();
					}
					delete d[img];
				}
			}
			else
			{
				d2 = d[targetSrcImg];
				if ( d2 != null )
				{
					for each ( tintImg in d2 )
					{
						tintImg.dispose();
					}
					delete d[targetSrcImg];
				}
			}
		}
	}
	
}