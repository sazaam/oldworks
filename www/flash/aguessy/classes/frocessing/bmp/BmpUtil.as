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
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	/**
	* Utilities of BitmapData.
	* 
	* @author nutsu
	* @version 0.2.1
	*/
	public class BmpUtil {
		
		private static const zeropoint:Point = new Point();
		private static var _colortransform:ColorTransform = new ColorTransform();
		
		//--------------------------------------------------------------------------------------------------- Tint
		
		/**
		 * 指定の色でカラー調整(colorTransform)を適用します.
		 * 
		 * @param	c1
		 * @param	c2
		 * @param	c3
		 * @param	c4
		 */
		public static function tint( target:BitmapData, c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void
		{
			if ( isNaN( c2 ) )
			{
				_colortransform.redMultiplier   = c1;
				_colortransform.greenMultiplier = c1;
				_colortransform.blueMultiplier  = c1;
				_colortransform.alphaMultiplier = 1.0;
			}
			else if ( isNaN( c3 ) )
			{
				_colortransform.redMultiplier   = c1;
				_colortransform.greenMultiplier = c1;
				_colortransform.blueMultiplier  = c1;
				_colortransform.alphaMultiplier = c2;
			}
			else if ( isNaN( c4 ) )
			{
				_colortransform.redMultiplier   = c1;
				_colortransform.greenMultiplier = c2;
				_colortransform.blueMultiplier  = c3;
				_colortransform.alphaMultiplier = 1.0;
			}
			else
			{
				_colortransform.redMultiplier   = c1;
				_colortransform.greenMultiplier = c2;
				_colortransform.blueMultiplier  = c3;
				_colortransform.alphaMultiplier = c4;
			}
			target.colorTransform( target.rect, _colortransform );
		}
		
		//--------------------------------------------------------------------------------------------------- Mask
		
		/**
		 * BitmapData を BitmapData で マスク します.
		 * @param	alphaSrc	BitmapData
		 * @param	channel		Alpha　を指定する　BitmapDataChannel
		 */
		public static function mask( target:BitmapData, alphaSrc:BitmapData, channel:uint=8 ):void
		{
			target.copyChannel( alphaSrc, target.rect, zeropoint, channel, BitmapDataChannel.ALPHA );
		}
		
		/**
		 * BitmapData を DisplayObject で マスク します.
		 * @param	shape	マスクシェイプ
		 * @param	fit		シェイプを BitmapData のサイズに合わせます
		 */
		public static function maskShape( target:BitmapData, alphaSrc:DisplayObject, fit:Boolean = false ):void
		{
			var scaleX:Number = 1;
			var scaleY:Number = 1;
			if ( fit )
			{
				scaleX = target.width/alphaSrc.width;
				scaleY = target.height/alphaSrc.height;
			}
			var alphashape:BitmapData = DO2BD( alphaSrc, 0, scaleX, scaleY, false );
			mask( target, alphashape );
			alphashape.dispose();
			alphashape = null;
		}
		
		//--------------------------------------------------------------------------------------------------- DisplayObject
		
		/**
		 * DisplayObject を BitmapDataに変換します.
		 * 
		 * @param	dobj	DisplayObject
		 * @param	margin	BitmapDataの余白のサイズを指定します
		 * @param	scale	描画するスケールを指定します
		 * @param	smooth	スムーシングを指定します
		 * @param	bd		BitmapData を指定します.指定がない場合、新しい BitmapData を生成します.
		 * @return	BitmapData
		 */
		public static function DO2BD( dobj:DisplayObject, margin:int=0, scaleX:Number=1, scaleY:Number=1, smooth:Boolean=false, bd:BitmapData=null ):BitmapData
		{
			var mt:Matrix    = dobj.transform.matrix;
			var rt:Rectangle = ( dobj.parent ) ? dobj.getBounds( dobj.parent ) : dobj.getBounds( dobj );
			var w:uint = Math.ceil( rt.width * scaleX );
			var h:uint = Math.ceil( rt.height * scaleY );
			mt.translate( -rt.x, -rt.y );
			mt.scale( scaleX, scaleY );
			mt.translate( margin, margin );
			if( bd==null )
				bd = new BitmapData( w+margin*2, h+margin*2, true, 0x00000000 );
			bd.draw( dobj, mt, dobj.transform.colorTransform, null, null, smooth );
			return bd;
		}
		
		//--------------------------------------------------------------------------------------------------- Grid Cut
		
		/**
		 * BitmapData をグリッドにそって分割します.
		 * 
		 * @param	bd
		 * @param	grid_width
		 * @param	grid_height
		 * @return	BitmapData[]
		 */
		public static function splitByGrid( bd:BitmapData, grid_width:uint, grid_height:uint ):Array
		{
			var w:Number = bd.rect.width;
			var h:Number = bd.rect.height;
			if ( grid_width >= w && grid_height >= h )
				return [bd.clone()];
			
			var d:Array = [];
			grid_width  = Math.min( w, grid_width );
			grid_height = Math.min( h, grid_height );
			
			var srect:Rectangle = new Rectangle();
			for ( var th:int = 0; th < h ; th += grid_height )
			{
				var ty0:int = th;
				var ty1:int = Math.min( th + grid_height, h );
				for ( var tw:int = 0; tw < w ; tw += grid_width )
				{
					var tx0:int = tw;
					var tx1:int = Math.min( tw + grid_width, w );
					srect.x = tx0;
					srect.y = ty0;
					srect.width =  tx1 - tx0;
					srect.height = ty1 - ty0;
					var bmpdata:BitmapData = new BitmapData( srect.width, srect.height, bd.transparent, 0x00000000 );
					bmpdata.copyPixels( bd, srect, zeropoint );
					d.push( bmpdata );
				}
			}
			return d;
		}
	}
	
}