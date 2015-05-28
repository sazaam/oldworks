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
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import frocessing.geom.FMatrix2D;
	
	/**
	* FBitmapGraphics は BitmapData を描画するメソッドを提供します.
	* 
	* @author nutsu
	* @version 0.2.6
	*/
	public class FBitmapGraphics {
		
		private var _gc:Graphics;
		private var _smooth:Boolean;
		private var _detail:uint;
		private var _matrix:FMatrix2D;
		
		private var _bitmapdata:BitmapData;
		private var _image_width:int;
		private var _image_height:int;
		
		private var vx0:Number;
		private var vy0:Number;
		private var vx1:Number;
		private var vy1:Number;
		
		/**
		 * 新しい FBitmapGraphics クラスのインスタンスを生成します.
		 * @param	gc			描画する Graphics
		 * @param	smoothig	描画のスムーシング
		 * @param	detail		BitmapData を変形する場合の分割数
		 */
		public function FBitmapGraphics( gc:Graphics, smooth_:Boolean=true, detail_:uint=4 ) {
			_gc     = gc;
			_smooth = smooth_;
			_detail = detail_;
			_matrix = new FMatrix2D();
		}
		
		/**
		 * 描画する Graphics を示します.
		 */
		public function get graphics():Graphics { return _gc; }
		public function set graphics(value:Graphics):void {
			_gc = value;
		}
		
		/**
		 * 描画の Smoothing を示します.
		 */
		public function get smooth():Boolean { return _smooth; }
		public function set smooth(value:Boolean):void {
			_smooth = value;
		}
		
		/**
		 * drawQuad() メソッドで描画する際の分割数を示します. （1以上)
		 * 
		 * <p>
		 * 例えば、分割数を 4 で設定した場合、4 x 4 x 2 の　32ポリゴンで描画されます.
		 * </p>
		 */
		public function get detail():uint { return _detail; }
		public function set detail(value:uint):void {
			_detail = Math.max( 1, value );
		}
		
		/**
		 * 現在の BitmapData を示します.
		 */
		public function get bitmapdata():BitmapData { return _bitmapdata; }
		
		//--------------------------------------------------------------------------------------------------- 
		
		/**
		 * 描画する BitmapData を指定します. drawメソッドの前に必ず実行します.
		 * @param	bitmapdata
		 * @param	smoothing
		 * @param	detail
		 */
		public function beginBitmap( bitmapdata:BitmapData ):void
		{
			if ( bitmapdata !== _bitmapdata )
			{
				_bitmapdata   = bitmapdata;
				_image_width  = _bitmapdata.width;
				_image_height = _bitmapdata.height;
			}
		}
		
		/**
		 * draw 後に実行します. BitmapData が null に設定されます.
		 */
		public function endBitmap():void
		{
			_bitmapdata = null;
		}
		
		//--------------------------------------------------------------------------------------------------- 
		
		/**
		 * BitmapData を描画します.
		 * @param	x
		 * @param	y
		 * @param	w
		 * @param	h
		 * @param	center
		 */
		public function drawBitmap( x:Number, y:Number, w:Number, h:Number ):void
		{
			_matrix.setMatrix( w/_image_width, 0, 0, h/_image_height, x, y );
			_gc.beginBitmapFill( _bitmapdata, _matrix, false, _smooth );
			_gc.drawRect( x, y, w, h  );
			_gc.endFill();
		}
		
		
		/**
		 * BitmapData を Rect の領域に描画します.
		 * @param	bitmapdata
		 * @param	x	x 座標
		 * @param	y	y 座標
		 * @param	w	描画する幅
		 * @param	h	描画する高さ
		 * @param	mtx	変形を指定する Matrix	
		 */
		public function drawRect( x:Number, y:Number, w:Number, h:Number, mtx:Matrix=null ):void
		{
			_matrix.setMatrix( w/_image_width, 0, 0, h/_image_height, x, y );
			if ( mtx == null )
			{
				_gc.beginBitmapFill( _bitmapdata, _matrix, false, _smooth );
				_gc.drawRect( x, y, w, h  );
				_gc.endFill();
			}
			else
			{
				_matrix.concat( mtx );
				var a:Number  = mtx.a;
				var b:Number  = mtx.b;
				var c:Number  = mtx.c;
				var d:Number  = mtx.d;
				var tx:Number = mtx.tx;
				var ty:Number = mtx.ty;
				_gc.beginBitmapFill( _bitmapdata, _matrix, false, _smooth );
				_gc.moveTo( a * x + c * y + tx, b * x + d * y + ty );  x += w;
				_gc.lineTo( a * x + c * y + tx, b * x + d * y + ty );  y += h;
				_gc.lineTo( a * x + c * y + tx, b * x + d * y + ty );  x -= w;
				_gc.lineTo( a * x + c * y + tx, b * x + d * y + ty );
				_gc.endFill();
			}
		}
		
		/**
		 * 
		 */
		public function drawTriangle( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number,
									  u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number ):void
		{
			vx0 = x1 - x0;
			vy0 = y1 - y0;
			vx1 = x2 - x0;
			vy1 = y2 - y0;
			_matrix.createUVBox( x0, y0, x1, y1, x2, y2, u0, v0, u1, v1, u2, v2, _image_width, _image_height );
			_gc.beginBitmapFill( _bitmapdata, _matrix, false, _smooth && ( vx0 * vy1 - vy0 * vx1 > 255 ) );
			_gc.moveTo( x0, y0 );
			_gc.lineTo( x1, y1 );
			_gc.lineTo( x2, y2 );
			_gc.endFill();
		}
		
		/**
		 * 
		 */
		public function drawTriangles( vertices:Array, indices:Array, uvData:Array ):void
		{
			var len:int = indices.length;
			var i0:int;
			var i1:int;
			var i2:int;
			var j0:int;
			var j1:int;
			var j2:int;
			for ( var i:int = 0; i < len; i += 3 )
			{
				i0 = 2 * indices[i];
				i1 = 2 * indices[i+1];
				i2 = 2 * indices[i + 2];
				j0 = i0 + 1;
				j1 = i1 + 1;
				j2 = i2 + 1;
				drawTriangle( vertices[i0], vertices[j0], vertices[i1], vertices[j1], vertices[i2], vertices[j2], 
						      uvData[i0], uvData[j0], uvData[i1], uvData[j1], uvData[i2], uvData[j2] );
			}
		}
		
		/**
		 * BitmapData を変形して描画します.
		 */
		public function drawQuad( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number,
								  u0:Number=0, v0:Number=0, u1:Number=1, v1:Number=0, u2:Number=1, v2:Number=1, u3:Number=0, v3:Number=1 ):void
		{
			var u:Number;
			var v:Number;
			
			var v0x0:Number = x0;
			var v0y0:Number = y0;
			var v0x1:Number = x1;
			var v0y1:Number = y1;
			var v1x0:Number;
			var v1y0:Number;
			var v1x1:Number;
			var v1y1:Number;
			
			var v0u0:Number = u0;
			var v0v0:Number = u0;
			var v0u1:Number = u1;
			var v0v1:Number = v1;
			var v1u0:Number;
			var v1v0:Number;
			var v1u1:Number;
			var v1v1:Number;
			
			var h0x0:Number;
			var h0y0:Number;
			var h0x1:Number;
			var h0y1:Number;
			var h1x0:Number;
			var h1y0:Number;
			var h1x1:Number;
			var h1y1:Number;
			
			var h0u0:Number;
			var h0v0:Number;
			var h0u1:Number;
			var h0v1:Number;
			var h1u0:Number;
			var h1v0:Number;
			var h1u1:Number;
			var h1v1:Number;
			
			var d:Number = 1 / _detail;
			
			for( var i:int=1; i<=_detail; i++ )
			{
				v = i * d;
				v1x0 = x0 + (x3 - x0) * v;
				v1y0 = y0 + (y3 - y0) * v;
				v1x1 = x1 + (x2 - x1) * v;
				v1y1 = y1 + (y2 - y1) * v;
				v1u0 = u0 + (u3 - u0) * v;
				v1v0 = v0 + (v3 - v0) * v;
				v1u1 = u1 + (u2 - u1) * v;
				v1v1 = v1 + (v2 - v1) * v;
				
				h0x0 = v0x0; h0y0 = v0y0;
				h0x1 = v1x0; h0y1 = v1y0;
				h0u0 = v0u0; h0v0 = v0v0;
				h0u1 = v1u0; h0v1 = v1v0;
				for ( var j:int = 1; j <=_detail; j++ )
				{
					u = j * d;
					h1x0 = v0x0 + (v0x1 - v0x0) * u;
					h1y0 = v0y0 + (v0y1 - v0y0) * u;
					h1x1 = v1x0 + (v1x1 - v1x0) * u;
					h1y1 = v1y0 + (v1y1 - v1y0) * u;
					h1u0 = v0u0 + (v0u1 - v0u0) * u;
					h1v0 = v0v0 + (v0v1 - v0v0) * u;
					h1u1 = v1u0 + (v1u1 - v1u0) * u;
					h1v1 = v1v0 + (v1v1 - v1v0) * u;
					
					vx0 = h1x0 - h0x0;
					vy0 = h1y0 - h0y0;
					vx1 = h0x1 - h0x0;
					vy1 = h0y1 - h0y0;
					_matrix.createUVBox( h0x0, h0y0, h1x0, h1y0, h0x1, h0y1,
										 h0u0, h0v0, h1u0, h1v0, h0u1, h0v1,
										 _image_width, _image_height );
					_gc.beginBitmapFill( _bitmapdata, _matrix, false, _smooth && ( vx0 * vy1 - vy0 * vx1 > 255 ) );
					_gc.moveTo( h0x0, h0y0 );
					_gc.lineTo( h1x0, h1y0 );
					_gc.lineTo( h0x1, h0y1 );
					_gc.endFill();
					
					vx0 = h1x1 - h1x0;
					vy0 = h1y1 - h1y0;
					vx1 = h0x1 - h1x0;
					vy1 = h0y1 - h1y0;
					_matrix.createUVBox( h1x0, h1y0, h1x1, h1y1, h0x1, h0y1,
										 h1u0, h1v0, h1u1, h1v1, h0u1, h0v1,
										 _image_width, _image_height );
					_gc.beginBitmapFill( _bitmapdata, _matrix, false, _smooth && ( vx0 * vy1 - vy0 * vx1 > 255 ) );
					_gc.moveTo( h1x0, h1y0 );
					_gc.lineTo( h1x1, h1y1 );
					_gc.lineTo( h0x1, h0y1 );
					_gc.endFill();
					
					h0x0 = h1x0; h0y0 = h1y0;
					h0x1 = h1x1; h0y1 = h1y1;
					h0u0 = h1u0; h0v0 = h1v0;
					h0u1 = h1u1; h0v1 = h1v1;
				}
				v0x0 = v1x0; v0y0 = v1y0;
				v0x1 = v1x1; v0y1 = v1y1;
				v0u0 = v1u0; v0v0 = v1v0;
				v0u1 = v1u1; v0v1 = v1v1;
			}
		}
	}
	
}