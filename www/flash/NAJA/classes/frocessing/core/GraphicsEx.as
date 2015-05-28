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

package frocessing.core {
	
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import frocessing.bmp.FBitmapData;
	import frocessing.geom.FMatrixMap;
	
	/**
	* GraphicsEx.
	* 
	* <p>※将来的に再構成されなくなる予定です</p>
	* 
	* @author nutsu
	* @version 0.5.8
	*/
	public class GraphicsEx
	{
		/** @private */
		internal var gc:Graphics;
		
		// Fill
		/**
		 * applyFill() によって塗りを適用するかどうかを指定します.
		 */
		public var fillDo:Boolean = true;
		
		/**
		 * 塗りの色を示します.
		 */
		public var fillColor:uint = 0xffffff;
		
		/**
		 * 塗りの透明度を示します.有効な値は 0～1 です.
		 */
		public var fillAlpha:Number = 1.0;
		
		// Stroke
		/** @private */
		internal var __stroke:Boolean = false;
		/** @private */
		internal var __stroke_resume:Boolean = false;
		
		/**
		 * 線の色を示します.
		 */
		public var strokeColor:uint = 0;
		
		/**
		 * 線の透明度を示します.有効な値は 0～1 です.
		 */
		public var strokeAlpha:Number = 1.0;
		
		/**
		 * 線の太さを示します.有効な値は 0～255 です.
		 */
		public var thickness:Number = 0;
		
		/**
		 * 線をヒンティングするかどうかを示します.
		 */
		public var pixelHinting:Boolean = false;
		
		/**
		 * 使用する拡大 / 縮小モードを指定する LineScaleMode クラスの値を示します.
		 * @see flash.display.LineScaleMode
		 */
		public var scaleMode:String = "normal";
		
		/**
		 * 線の終端のキャップの種類を指定する CapsStyle クラスの値を示します.
		 * @see flash.display.CapsStyle
		 */
		public var caps:String = null;
		
		/**
		 * 角で使用する接合点の外観の種類を指定する JointStyle クラスの値を示します.
		 * @see flash.display.JointStyle
		 */
		public var joints:String = null;
		
		/**
		 * マイターが切り取られる限度を示す数値を示します.
		 */
		public var miterLimit:Number = 3;
		
		
		/**
		 * bezierTo（）メソッドで描画する曲線の精度.
		 */
		public var bezierDetail:uint = 20;
		
		/**
		 * splineTo（）メソッドで描画する曲線の精度.
		 */
		public var splineDetail:uint = 20;
		/** @private */
		private var __splineTightness:Number = 1.0;
		/** @private */
		internal var __tightness:Number = __splineTightness / 6;
		
		
		//path status
		/** @private */
		internal var __startX:Number = 0;
		/** @private */
		internal var __startY:Number = 0;
		/** @private */
		internal var __x:Number = 0;
		/** @private */
		internal var __y:Number = 0;
		
		/** @private */
		internal var default_gradient_matrix:Matrix;
		
		/** @private */
		internal var __fill_apply_count:int;
		
		/**
		 * GraphicsEx のインスタンスを生成します.
		 * 
		 * @param	graphics
		 */
		public function GraphicsEx( graphics:Graphics ) 
		{
			gc = graphics;
			__matrix = new FMatrixMap();
			default_gradient_matrix = new Matrix();
			default_gradient_matrix.createGradientBox( 200, 200, 0, -100, -100 );
			__fill_apply_count = 0;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 描画されているグラフィックをクリアします.
		 */
		public function clear():void
		{
			gc.clear();
			__x = __y = __startX = __startY = 0;
			
			if ( __stroke )
			{
				applyStroke();
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------- PATH
		
		/**
		 * @private
		 */
		internal function __resetPathPoint():void
		{
			gc.moveTo( 0, 0 );
		}
		
		/**
		 * 現在の描画位置を (x, y) に移動します.
		 */
		public function moveTo( x:Number, y:Number ):void
		{
			gc.moveTo( x, y );
			__x = __startX = x;
			__y = __startY = y;
		}
		
		/**
		 * 現在の描画位置から (x, y) まで描画します.
		 */
		public function lineTo( x:Number, y:Number ):void
		{
			gc.lineTo( x, y );
			__x = x;
			__y = y;
		}
		
		/**
		 * 指定されたをコントロールポイント(controlX, controlY) を使用し、現在の描画位置から (anchorX, anchorY)まで2次ベジェ曲線を描画します.
		 */
		public function curveTo( controlX:Number, controlY:Number, anchorX:Number, anchorY:Number ):void
		{
			gc.curveTo( controlX, controlY, anchorX, anchorY );
			__x = anchorX;
			__y = anchorY;
			
			/*
			var k:Number = 1.0/bezierDetail;
			var t:Number = 0;
			var tp:Number;
			for ( var i:int = 1; i <= bezierDetail; i++ )
			{
				t += k;
				tp = 1.0-t;
				gc.lineTo( __x*tp*tp + 2*controlX*t*tp + anchorX*t*t, 
							__y*tp*tp + 2*controlY*t*tp + anchorY*t*t );
			}
			__x = anchorX;
			__y = anchorY;
			*/
		}
		
		/**
		 * 3次ベジェ曲線を描画します.
		 */
		public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			var k:Number = 1.0/bezierDetail;
			var t:Number = 0;
			var tp:Number;
			__x -= x;
			__y -= y;
			cx0 -= x;
			cy0 -= y;
			cx1 -= x;
			cy1 -= y;
			for ( var i:int = 1; i <= bezierDetail; i++ )
			{
				t += k;
				tp = 1.0 - t;
				gc.lineTo( __x*tp*tp*tp + 3*cx0*t*tp*tp + 3*cx1*t*t*tp + x, 
						   __y*tp*tp*tp + 3*cy0*t*tp*tp + 3*cy1*t*t*tp + y );
				/*
				gc.lineTo( __x*tp*tp*tp + 3*cx0*t*tp*tp + 3*cx1*t*t*tp + x*t*t*t, 
							__y*tp*tp*tp + 3*cy0*t*tp*tp + 3*cy1*t*t*tp + y*t*t*t );
				//*/
			}
			__x = x;
			__y = y;
		}
		
		/**
		 * スプライン曲線を描画します.
		 * 
		 * @param	cx0	pre point x
		 * @param	cy0	pre point y
		 * @param	cx1	next point x 
		 * @param	cy1 next point y
		 * @param	x	target point x
		 * @param	y	target point x
		 */
		public function splineTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			var k:Number = 1.0 / splineDetail;
			var t:Number = 0;
			
			//convert to bezier
			var cx0:Number = __x + __tightness * ( x - cx0 ) - x;
			var cy0:Number = __y + __tightness * ( y - cy0 ) - y;
			var cx1:Number =     - __tightness * ( cx1 - __x );
			var cy1:Number =     - __tightness * ( cy1 - __y );
			__x -= x;
			__y -= y;
			var tp:Number;
			for ( var i:int = 1; i <= splineDetail; i++ )
			{
				t += k;
				tp = 1.0-t;
				gc.lineTo( __x*tp*tp*tp + 3*cx0*t*tp*tp + 3*cx1*t*t*tp + x, 
						   __y*tp*tp*tp + 3*cy0*t*tp*tp + 3*cy1*t*t*tp + y );
			}
			__x = x;
			__y = y;
			
			/*
			// Catmull-Rom Spline Curve
			// x0, y0, x1, y1, x2, y2, x3, y3
			var v0x:Number = __splineTightness*( x2 - x0 )*0.5;
			var v0y:Number = __splineTightness*( y2 - y0 )*0.5;
			var v1x:Number = __splineTightness*( x3 - x1 )*0.5;
			var v1y:Number = __splineTightness*( y3 - y1 )*0.5;
			for ( var i:int = 1; i <= splineDetail;  i++ )
			{
				t = i*k;
				lineTo( t*t*t*( 2*x1 - 2*x2 + v0x + v1x ) + t*t*( -3*x1 + 3*x2 - 2*v0x - v1x ) + v0x*t + x1,
						t*t*t*( 2*y1 - 2*y2 + v0y + v1y ) + t*t*( -3*y1 + 3*y2 - 2*v0y - v1y ) + v0y*t + y1 );
			}
			*/
		}
		
		/**
		 * スプライン曲線の曲率を指定します.デフォルト値は 1.0 です.
		 */
		public function get splineTightness():Number { return __splineTightness; }
		public function set splineTightness(value:Number):void 
		{
			__splineTightness = value;
			__tightness = value / 6;
		}
		
		/**
		 * 描画しているシェイプを閉じます.
		 */
		public function closePath():void
		{
			gc.lineTo( __startX, __startY );
			__x = __startX;
			__y = __startY;
		}
		
		/**
		 * 現在の描画位置に moveTo() します.
		 */
		public function moveToLast():void
		{
			gc.moveTo( __x, __y );
			__startX = __x;
			__startY = __y;
		}
		
		/**
		 * 点を描画します.
		 * 
		 * @param	x
		 * @param	y
		 */
		public function point( x:Number, y:Number ):void
		{
			abortStroke();
			gc.moveTo( x, y );
			gc.beginFill( strokeColor, strokeAlpha );
			//gc.moveTo( x, y );
			gc.lineTo( x + 1, y );
			gc.lineTo( x + 1, y + 1 );
			gc.lineTo( x, y + 1 );
			gc.endFill();
			resumeStroke();
			__x = __startX = x;
			__y = __startY = y;
		}
		
		//------------------------------------------------------------------------------------------------------------------- 
		// STYLE
		//-------------------------------------------------------------------------------------------------------------------
		
		//------------------------------------------------------------------------------------------------------------------- Stroke
		
		/**
		 * 一時的に、線のスタイルを無効化します.
		 */
		public function abortStroke():Boolean
		{
			if ( __stroke )
			{
				__stroke_resume = true;
				noStroke();
				return true;
			}
			else
			{
				__stroke_resume = false;
				return false;
			}
		}
		
		/**
		 * abortStroke() で無効化した線のスタイルを復帰します.
		 */
		public function resumeStroke():Boolean
		{
			if ( __stroke_resume )
			{
				__stroke_resume = false;
				applyStroke();
				return true;
			}
			else
			{
				__stroke_resume = false;
				return false;
			}
		}
		
		/**
		 * 線の塗りが指定されている場合、スタイルを更新します.
		 */
		public function reapplyStroke():void
		{
			if ( __stroke )
				applyStroke();
		}
		
		/**
		 * 指定されている線のスタイルをを適用します.
		 */
		public function applyStroke():void
		{
			gc.lineStyle( thickness, strokeColor, strokeAlpha, pixelHinting, scaleMode, caps, joints, miterLimit );
			__stroke = true;
		}
		
		/**
		 * 線のスタイルを指定します.
		 * 
		 * @param	thickness
		 * @param	color
		 * @param	alpha
		 * @param	pixelHinting
		 * @param	scaleMode
		 * @param	caps
		 * @param	joints_
		 * @param	miterLimit_
		 */
		public function lineStyle( thickness:Number = NaN, color:uint = 0, alpha:Number = 1, 
								   pixelHinting:Boolean = false, scaleMode:String = "normal",
								   caps:String=null, joints_:String=null, miterLimit_:Number=3 ):void
		{
			if ( thickness>=0 )
			{
				this.strokeColor	= color;
				this.strokeAlpha    = alpha;
				this.thickness		= thickness;
				this.pixelHinting	= pixelHinting;
				this.scaleMode		= scaleMode;
				this.caps			= caps;
				this.joints			= joints;
				this.miterLimit		= miterLimit;
				applyStroke();
			}
			else
			{
				noStroke();
			}
		}
		
		/**
		 * 線スタイルのグラデーションを指定します.
		 * 
		 * @param	type
		 * @param	colors
		 * @param	alphas
		 * @param	ratios
		 * @param	matrix
		 * @param	spreadMethod
		 * @param	interpolationMethod
		 * @param	focalPointRatio
		 */
		public function lineGradientStyle( type:String, colors:Array, alphas:Array, ratios:Array,
										   matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb",
										   focalPointRatio:Number=0.0 ):void
		{
			gc.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		}
		
		/**
		 * 線のスタイルを無効化します.
		 */
		public function noStroke():void
		{
			gc.lineStyle();
			__stroke = false;
		}
		
		//------------------------------------------------------------------------------------------------------------------- Fill
		
		/**
		 * 指定されている塗りで beginFill() を実行します.
		 */
		public function applyFill():void
		{
			if ( fillDo && __fill_apply_count<1 )
			{
				__resetPathPoint();// moveToLast();
				gc.beginFill( fillColor, fillAlpha );
				__fill_apply_count = 1;
			}
			else
			{
				__fill_apply_count++;
			}
		}
		
		/**
		 * 今後の描画に使用する単色塗りを指定します.
		 * 
		 * @param	color
		 * @param	alpha
		 */
		public function beginFill(color:uint, alpha:Number=1.0):void
		{
			__fill_apply_count = 1;
			fillColor = color;
			fillAlpha = alpha;
			gc.beginFill( fillColor, fillAlpha );
		}
		
		/**
		 * 描画領域をビットマップイメージで塗りつぶします.
		 * 
		 * @param	bitmap
		 * @param	matrix
		 * @param	repeat
		 * @param	smooth
		 */
		public function beginBitmapFill( bitmap:BitmapData, matrix:Matrix=null, repeat:Boolean=true, smooth:Boolean=false ):void
		{
			__fill_apply_count = 1;
			gc.beginBitmapFill( bitmap, matrix, repeat, smooth );
		}
		
		/**
		 * 今後の描画に使用するグラデーション塗りを指定します.
		 * 
		 * @param	type
		 * @param	color
		 * @param	alphas
		 * @param	ratios
		 * @param	matrix
		 * @param	spreadMethod
		 * @param	interpolationMethod
		 * @param	focalPointRatio
		 */
		public function beginGradientFill( type:String, color:Array, alphas:Array, ratios:Array,
										   matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb",
										   focalPointRatio:Number=0.0 ):void
		{
			__fill_apply_count = 1;
			gc.beginGradientFill( type, color, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio );
		}
		
		/**
		 * beginFill()、beginGradientFill()、または beginBitmapFill() メソッドへの最後の呼び出し以降に追加された線と曲線に塗りを適用します.
		 */
		public function endFill():void
		{
			__fill_apply_count--;
			if ( __fill_apply_count < 1 )
			{
				gc.endFill();
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------- Image
		
		/**
		 * Bitmap 描画の Smoothing を示します.
		 */
		public var imageSmoothing:Boolean = false;
		
		/**
		 * drawBitmapQuad() メソッドで描画する際の分割数を示します. （1以上)
		 * <p>
		 * 例えば、分割数を 4 で設定した場合、4 x 4 x 2 の　32ポリゴンで描画されます.
		 * </p>
		 */
		public var imageDetail:uint = 4;
		
		private var __matrix:FMatrixMap;
		
		private var __image:BitmapData;
		private var __image_width:int;
		private var __image_height:int;
		
		private var vx0:Number;
		private var vy0:Number;
		private var vx1:Number;
		private var vy1:Number;
		
		/**
		 * BitmapData の描画を開始します. drawメソッドの前に必ず実行します.
		 * <p>
		 * drawBitmap(),drawBitmapTriangle(),drawBitmapTriangles(),drawBitmapQuad()の前に実行します.
		 * </p>
		 */
		public function beginBitmap( bitmapdata:BitmapData ):void
		{
			if ( bitmapdata !== __image )
			{
				__image = bitmapdata;
				__image_width  = __image.width;
				__image_height = __image.height;
			}
		}
		
		/**
		 * BitmapData の描画を終了します. BitmapData が null に設定されます.
		 */
		public function endBitmap():void
		{
			__image = null;
		}
		
		/**
		 * beginBitmap()で指定した BitmapData で Rect の領域を描画します.
		 * 
		 * @param	x	x 座標
		 * @param	y	y 座標
		 * @param	w	描画する幅
		 * @param	h	描画する高さ
		 * @param	mtx	変形を指定する Matrix	
		 */
		public function drawBitmap( x:Number, y:Number, w:Number, h:Number, mtx:Matrix=null ):void
		{
			__matrix.setMatrix( w/__image_width, 0, 0, h/__image_height, x, y );
			if ( mtx == null )
			{
				__x = __startX = x;
				__y = __startY = y;
				gc.beginBitmapFill( __image, __matrix, false, imageSmoothing );
				gc.drawRect( x, y, w, h );
				gc.endFill();
			}
			else
			{
				__matrix.concat( mtx );
				var a:Number  = mtx.a;
				var b:Number  = mtx.b;
				var c:Number  = mtx.c;
				var d:Number  = mtx.d;
				var tx:Number = mtx.tx;
				var ty:Number = mtx.ty;
				__x = __startX = a * x + c * y + tx;
				__y = __startY = b * x + d * y + ty;
				gc.beginBitmapFill( __image, __matrix, false, imageSmoothing );
				gc.moveTo( __x, __y );  x += w;
				gc.lineTo( a * x + c * y + tx, b * x + d * y + ty );  y += h;
				gc.lineTo( a * x + c * y + tx, b * x + d * y + ty );  x -= w;
				gc.lineTo( a * x + c * y + tx, b * x + d * y + ty );
				gc.endFill();
			}
		}
		
		/**
		 * beginBitmap()で指定した BitmapData で Triangle の領域を描画します.
		 */
		public function drawBitmapTriangle( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number,
											u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number ):void
		{
			__x = __startX = x0;
			__y = __startY = y0;
			vx0 = x1 - x0;
			vy0 = y1 - y0;
			vx1 = x2 - x0;
			vy1 = y2 - y0;
			__matrix.createTriangleBox( x0, y0, x1, y1, x2, y2, u0, v0, u1, v1, u2, v2, __image_width, __image_height );
			gc.beginBitmapFill( __image, __matrix, false, imageSmoothing && ( vx0 * vy1 - vy0 * vx1 > 255 ) );
			gc.moveTo( x0, y0 );
			gc.lineTo( x1, y1 );
			gc.lineTo( x2, y2 );
			gc.endFill();
		}
		
		/**
		 * beginBitmap()で指定した BitmapData で Triangle の領域を描画します.
		 */
		public function drawBitmapTriangles( vertices:Array, indices:Array, uvData:Array ):void
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
				drawBitmapTriangle( vertices[i0], vertices[j0], vertices[i1], vertices[j1], vertices[i2], vertices[j2], 
									uvData[i0], uvData[j0], uvData[i1], uvData[j1], uvData[i2], uvData[j2] );
			}
		}
		
		/**
		 * beginBitmap()で指定した BitmapData で Quad の領域を描画します.
		 */
		public function drawBitmapQuad( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number,
										u0:Number=0, v0:Number=0, u1:Number=1, v1:Number=0, u2:Number=1, v2:Number=1, u3:Number=0, v3:Number=1 ):void
		{
			__x = __startX = x0;
			__y = __startY = y0;
			
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
			
			var d:Number = 1 / imageDetail;
			
			for( var i:int=1; i<=imageDetail; i++ )
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
				for ( var j:int = 1; j <=imageDetail; j++ )
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
					__matrix.createTriangleBox( h0x0, h0y0, h1x0, h1y0, h0x1, h0y1, h0u0, h0v0, h1u0, h1v0, h0u1, h0v1, __image_width, __image_height );
					gc.beginBitmapFill( __image, __matrix, false, imageSmoothing && ( vx0 * vy1 - vy0 * vx1 > 255 ) );
					gc.moveTo( h0x0, h0y0 );
					gc.lineTo( h1x0, h1y0 );
					gc.lineTo( h0x1, h0y1 );
					gc.endFill();
					
					vx0 = h1x1 - h1x0;
					vy0 = h1y1 - h1y0;
					vx1 = h0x1 - h1x0;
					vy1 = h0y1 - h1y0;
					__matrix.createTriangleBox( h1x0, h1y0, h1x1, h1y1, h0x1, h0y1, h1u0, h1v0, h1u1, h1v1, h0u1, h0v1, __image_width, __image_height );
					gc.beginBitmapFill( __image, __matrix, false, imageSmoothing && ( vx0 * vy1 - vy0 * vx1 > 255 ) );
					gc.moveTo( h1x0, h1y0 );
					gc.lineTo( h1x1, h1y1 );
					gc.lineTo( h0x1, h0y1 );
					gc.endFill();
					
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
		
		//-------------------------------------------------------------------------------------------------------------------
		// Pixel
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		internal var pixelbitmap:FBitmapData;
		
		/**
		 * @private
		 */
		internal function pixel():void
		{
			pixelbitmap.drawPixel( __x, __y, uint(strokeAlpha*0xff)<<24 | strokeColor );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// BG
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		internal function __BG( w:Number, h:Number, color:uint, alpha:Number ):void
		{
			clear();
			abortStroke();
			gc.beginFill( color, alpha );
			gc.moveTo( 0, 0 );
			gc.lineTo( w, 0 );
			gc.lineTo( w, h );
			gc.lineTo( 0, h );
			gc.endFill();
			resumeStroke();
		}
	}
	
}