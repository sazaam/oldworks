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

package frocessing.bmp {
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	
	/**
	 * TODO: copyPixels と　setPixels の比較
	 */
	/**
	* BitmapData の拡張クラスです.
	* @author nutsu
	* @version 0.5.8
	*/
	public class FBitmapData extends BitmapData
	{		
		/**
		 * 新しく FBitmapData のインスタンスを生成します.
		 */
		public function FBitmapData( width_:uint, height_:uint, transparent_:Boolean = true, bgcolor_:uint = 0xffffffff ) 
		{
			super( width_, height_, transparent_, bgcolor_ );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * アルファブレンディングで pixel の描画を行います.
		 */
		public function drawPixel( x:int, y:int, color32:uint ):void
		{
			var a:uint = color32 >>> 24;
			if ( a > 0 )
			{
				var c1:uint = getPixel32( x, y );
				var a1:uint = c1 >>> 24;
				var a0:uint = a ^ 0xff;
				c1 &= 0x00ffffff;
				var _r:uint = ( a0 * ( c1>>16 & 0xff ) + a * ( color32>>16 & 0xff ) ) >> 8 ;
				var _g:uint = ( a0 * ( c1>>8 & 0xff ) + a * ( color32>>8 & 0xff ) ) >> 8;
				var _b:uint = ( a0 * ( c1 & 0xff ) + a * ( color32 & 0xff ) ) >> 8;
				setPixel32( x, y, Math.min( a1 + a, 0xff ) << 24 | _r << 16 | _g << 8 | _b );
			}
			else
			{
				setPixel( x, y, color32 & 0x00ffffff );
			}
		}
		
		/**
		 * 
		 */
		override public function clone():BitmapData {
			var d:FBitmapData = new FBitmapData( width, height );
			d.copyPixels( this, rect, rect.topLeft );
			return d;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
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
		/*
		public static function drawObject( dobj:DisplayObject, margin:int=0, scaleX:Number=1, scaleY:Number=1, smooth:Boolean=false, bd:BitmapData=null ):BitmapData
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
		*/
	}
}