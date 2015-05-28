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

package frocessing.bmp 
{
	import flash.display.Bitmap;
	import flash.display.IBitmapDrawable;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import frocessing.geom.FViewBox;
	
	/**
	* FImage
	* 
	* @author nutsu
	* @version 0.5.8
	*/
	public class FImage 
	{
		
		/** @private */
		protected var _bitmapdata:BitmapData;
		
		private var _rect:Rectangle = new Rectangle();
		private var _zeropt:Point = new Point();
		
		public function FImage( bitmapData:BitmapData ) 
		{
			_bitmapdata = bitmapData;
		}

		public function get bitmapData():BitmapData { return _bitmapdata; }
		
		//------------------------------------------------------------------------------------------------------------------- UTIL
		
		/**
		 * alpha bitmapData.
		 */
		public function alpha( value:Number ):void {
			//TODO: alpha blending.
			_bitmapdata.colorTransform( _bitmapdata.rect, new ColorTransform(1, 1, 1, 0, 0, 0, 0, value * 0xff) );
		}
		
		/**
		 * mask bitmapData.
		 * 
		 * @param	src			IBitmapDrawable( DisplayObject or BitmapData ).
		 * @param	channel		src channel for alpha channel.
		 * @param	alphaBlend	blends alpha channel and mask channel.
		 */
		public function mask( src:IBitmapDrawable, channel:uint=8, alphaBlend:Boolean=true ):void
		{
			//make mask bitmapdata.
			var maskdata:BitmapData = new BitmapData( _bitmapdata.width, _bitmapdata.height, true, (channel==8) ? 0 : 0xff000000 );
			if ( src is BitmapData ) {
				maskdata.copyChannel( BitmapData(src), BitmapData(src).rect, _zeropt, channel, channel );
			}else {
				maskdata.draw( src );
			}
			//apply mask.
			if ( alphaBlend ) {
				if ( channel != 8 )
					maskdata.copyChannel( maskdata, maskdata.rect, _zeropt, channel, BitmapDataChannel.ALPHA );
				_bitmapdata.copyPixels( _bitmapdata, _bitmapdata.rect, _zeropt, maskdata, _zeropt, false );
			}else {
				_bitmapdata.copyChannel( maskdata, maskdata.rect, _zeropt, channel, BitmapDataChannel.ALPHA );
			}
			maskdata.dispose();
		}
		
		/**
		 * BitmapData をスライスします.
		 */
		public function slice( left:Number, top:Number, width:Number, height:Number ):BitmapData
		{
			_rect.x = left;
			_rect.y = top;
			_rect.width = width;
			_rect.height = height;
			var bd:BitmapData = new BitmapData( width, height, _bitmapdata.transparent, 0x00000000 );
			bd.copyPixels( _bitmapdata, _rect, _zeropt );
			return bd;
		}
		
		/**
		 * BitmapData をグリッドにそって分割します.
		 * 
		 * @param	split_x_num
		 * @param	split_y_num
		 * @return	BitmapData[]
		 */
		public function split( split_x_num:uint=1, split_y_num:uint=1 ):Array
		{
			var gg:int = split_x_num * split_y_num;
			if ( gg <= 0 )
				return [];
			else if ( gg == 1 )
				return [_bitmapdata.clone()];
			
			var w:int  = _bitmapdata.width;
			var h:int  = _bitmapdata.height;
			var wd:int = Math.ceil( w/split_x_num );
			var hd:int = Math.ceil( h/split_y_num );
			var d:Array = [];
			for ( var th:int = 0; th < h ; th += hd ){
				var ty1:int = Math.min( th + hd, h );
				for ( var tw:int = 0; tw < w ; tw += wd ){
					d.push( slice( tw, th, Math.min( tw + wd, w )-tw, ty1 - th ) );
				}
			}
			return d;
		}
		
		/**
		 * BitmapData のサイズを変更します.
		 * 
		 * @param	width
		 * @param	height
		 * @param	align
		 * @param	scaleMode	
		 * @param	bgcolor
		 * @param	smooth
		 * 
		 * @see frocessing.geom.FViewBox
		 */
		public function setSize( width:int, height:int, align:String = null, scaleMode:String = null, bgcolor:uint = 0, smooth:Boolean = true ):void
		{
			var vb:FViewBox  = new FViewBox( 0, 0, _bitmapdata.width, _bitmapdata.height );
			if ( align != null )     vb.align = align;
			if ( scaleMode != null ) vb.scaleMode = scaleMode;
			var bd:BitmapData = new BitmapData( width, height, _bitmapdata.transparent, bgcolor );
			bd.draw( _bitmapdata, vb.getTransformMatrix( 0, 0, width, height ), null, null, null, smooth );
			_bitmapdata.dispose();
			_bitmapdata = bd;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		public function dispose():void
		{
			_bitmapdata.dispose();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		public function valueOf():BitmapData
		{
			return _bitmapdata;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * DisplayObject を BitmapDataに変換します.
		 * 
		 * @param	dobj		DisplayObject
		 * @param	width		BitmapData width( 0 to dobj.width )
		 * @param	height		BitmapData height( 0 to dobj.height )
		 * @param	align		draw align. default center. 
		 * @param	scaleMode	draw scaleMode. default noScale.
		 * @param	transparent	BitmapData transparent.
		 * @param	bgcolor		BitmapData bg color.
		 * 
		 * @see frocessing.geom.FViewBox
		 */
		public static function toImage( dobj:DisplayObject, width:int=0, height:int=0, align:String=null, scaleMode:String=null, transparent:Boolean=true, bgcolor:uint=0xff000000 ):BitmapData
		{
			var mt:Matrix    = dobj.transform.matrix;
			var rt:Rectangle = ( dobj.parent ) ? dobj.getBounds( dobj.parent ) : dobj.getBounds( dobj );
			var vb:FViewBox  = new FViewBox( rt.x, rt.y, rt.width, rt.height );
			if ( align != null )     vb.align = align;
			if ( scaleMode != null ) vb.scaleMode = scaleMode;
			if ( width <= 0 ) 		 width = rt.width;
			if ( height <= 0 )		 height = rt.height;
			mt.concat( vb.getTransformMatrix( 0, 0, width, height ) ); 
			var bd:BitmapData = new BitmapData( width, height, transparent, bgcolor );
			bd.draw( dobj, mt, dobj.transform.colorTransform, null, null );
			return bd;
		}
	}
	
}