// --------------------------------------------------------------------------
// Project Frocessing
// ActionScript 3.0 drawing library like Processing.
// --------------------------------------------------------------------------
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
	import flash.geom.Matrix;
	
	/**
	* Graphics を拡張するための基底クラスです.
	* 
	* @author nutsu
	* @version 0.2.1
	*/
	public class GraphicsBase {
		
		// Target Graphics
		protected var _gc      :Graphics;
		
		// Coordinates
		protected var _startX    :Number;
		protected var _startY    :Number;
		protected var _lastX     :Number;
		protected var _lastY     :Number;
		protected var _lastCtrlX :Number;
		protected var _lastCtrlY :Number;
		
		// Stroke Attributes
		internal var _stroke_color:uint;
		internal var _stroke_alpha:Number;
		internal var _thickness:Number;
		internal var _pixelHinting:Boolean;
		internal var _scaleMode:String;
		internal var _caps:String;
		internal var _joints:String;
		internal var _miterLimit:Number;
		
		// Fill Attributes
		internal var _fill_color:uint;
		internal var _fill_alpha:Number;
		internal var default_gradient_matrix:Matrix;
		
		//
		protected var _stroke_do:Boolean;
		
		/**
		 * 新しい GraphicsBase クラスのインスタンスを生成します.
		 * 
		 * @param	gc	描画対象となる Graphics を指定します
		 */
		public function GraphicsBase( gc:Graphics )
		{
			_lastCtrlX = _lastX = _startX = 0.0;
			_lastCtrlY = _lastY = _startY = 0.0;
			_gc = gc;
			_stroke_do = false;
			default_gradient_matrix = new Matrix();
			default_gradient_matrix.createGradientBox( 200, 200, 0, -100, -100 );
		}
		
		/**
		 * 描画対象となる Graphics を示します.
		 * 
		 * [get graphics()は削除するかも]
		 */
		public function get graphics():Graphics { return _gc; }
		public function set graphics( gc:Graphics ):void
		{
			_gc = gc;
		}
		
		/**
		 * 現在の描画位置 x 座標を示します.
		 */
		public function get lastX():Number { return _lastX; }
		/**
		 * 現在の描画位置 y 座標を示します.
		 */
		public function get lastY():Number { return _lastY; }
		/**
		 * 
		 */
		public function get startX():Number { return _startX; }
		/**
		 * 
		 */
		public function get startY():Number { return _startY; }
		/**
		 * 
		 */
		public function get lastCtrlX():Number { return _lastCtrlX; }
		/**
		 * 
		 */
		public function get lastCtrlY():Number { return _lastCtrlY; }
		
		//---------------------------------------------------------------------------------------------------　ATTRIBUTES
		
		/**
		 * 線の色を示します.
		 * 適用するには、applyLineStyle() メソッドを実行する必要があります.
		 */
		public function get strokeColor():uint { return _stroke_color; }
		public function set strokeColor(value:uint):void {
			_stroke_color = value;
		}
		
		/**
		 * 線の透明度を示します.有効な値は 0～1 です.
		 * 適用するには、applyLineStyle() メソッドを実行する必要があります.
		 */
		public function get strokeAlpha():Number { return _stroke_alpha; }
		public function set strokeAlpha(value:Number):void {
			_stroke_alpha = value;
		}
		
		/**
		 * 線の太さを示します.有効な値は 0～255 です.
		 * 適用するには、applyLineStyle() メソッドを実行する必要があります.
		 */
		public function get thickness():Number { return _thickness; }
		public function set thickness(value_:Number):void{
			_thickness = value_;
		}
		
		/**
		 * 線をヒンティングするかどうかを示します.
		 * 適用するには、applyLineStyle() メソッドを実行する必要があります.
		 */
		public function get pixelHinting():Boolean { return _pixelHinting; }
		public function set pixelHinting(value_:Boolean):void {
			_pixelHinting = value_;
		}
		
		/**
		 * 使用する拡大 / 縮小モードを指定する LineScaleMode クラスの値を示します.
		 * 適用するには、applyLineStyle() メソッドを実行する必要があります.
		 * @see flash.display.LineScaleMode
		 */
		public function get scaleMode():String { return _scaleMode; }
		public function set scaleMode(value_:String):void {
			_scaleMode = value_;
		}
		
		/**
		 * 線の終端のキャップの種類を指定する CapsStyle クラスの値を示します.
		 * 適用するには、applyLineStyle() メソッドを実行する必要があります.
		 * @see flash.display.CapsStyle
		 */
		public function get caps():String { return _caps; }
		public function set caps(value_:String):void {
			_caps = value_;
		}
		
		/**
		 * 角で使用する接合点の外観の種類を指定する JointStyle クラスの値を示します.
		 * 適用するには、applyLineStyle() メソッドを実行する必要があります.
		 * @see flash.display.JointStyle
		 */
		public function get joints():String { return _joints; }
		public function set joints(value_:String):void {
			_joints = value_;
		}
		
		/**
		 * マイターが切り取られる限度を示す数値を示します.
		 * 適用するには、applyLineStyle() メソッドを実行する必要があります.
		 */
		public function get miterLimit():Number { return _miterLimit; }
		public function set miterLimit(value_:Number):void {
			_miterLimit = value_;
		}
		
		/**
		 * 塗りの色を示します.
		 * 指定の色で描画する場合は、beignFill() メソッド の代わりに　applyFill() メソッド を使用します.
		 */
		public function get fillColor():uint { return _fill_color; }
		public function set fillColor(value:uint):void {
			_fill_color = value;
		}
		
		/**
		 * 塗りの透明度を示します.有効な値は 0～1 です.
		 * 指定の色で描画する場合は、beignFill() メソッド の代わりに　applyFill() メソッド を使用します.
		 */
		public function get fillAlpha():Number { return _fill_alpha; }
		public function set fillAlpha(value:Number):void {
			_fill_alpha = value;
		}
		
		//--------------------------------------------------------------------------------------------------- OUT CORE
		
		/**
		 * graphics.clear を出力値として使用する場合にoverrideします.
		 * @param	x
		 * @param	y
		 */
		protected function $clear():void
		{
			_gc.clear();
		}
		
		/**
		 * graphics.moveTo の値を出力値として使用する場合にoverrideします.
		 * @param	x
		 * @param	y
		 */
		protected function $moveTo( x:Number, y:Number ):void
		{
			_gc.moveTo( x, y );
		}
		
		/**
		 * graphics.lineTo の値を出力値として使用する場合にoverrideします.
		 * @param	x
		 * @param	y
		 */
		protected function $lineTo( x:Number, y:Number ):void
		{
			_gc.lineTo( x, y );
		}
		
		/**
		 * graphics.curveTo の値を出力値として使用する場合にoverrideします.
		 * @param	x
		 * @param	y
		 */
		protected function $curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
			_gc.curveTo( controlX, controlY, anchorX, anchorY );
		}
		
		/**
		 * closePath の値を出力値として使用する場合にoverrideします.
		 * @param	x
		 * @param	y
		 */
		protected function $closePath():void
		{
			_gc.lineTo( _startX, _startY );
		}
		
		/**
		 * 点の描画メソッドです.出力値として使用する場合にoverrideします.
		 * @param	x
		 * @param	y
		 * @param	color
		 * @param	alpha
		 */
		protected function $point( x:Number, y:Number, color:uint, alpha:Number=1.0 ):void
		{
			if ( _stroke_do )
			{
				_gc.lineStyle();
				_gc.beginFill( color, alpha ); 
				_gc.drawRect( x, y, 1, 1 );
				_gc.endFill();
				applyLineStyle();
			}
			else
			{
				_gc.beginFill( color, alpha ); 
				_gc.drawRect( x, y, 1, 1 );
				_gc.endFill();
			}
		}
		
		//--------------------------------------------------------------------------------------------------- CORE
		
		/**
		 * Graphics オブジェクトに描画されているグラフィックをクリアします.
		 */
		public function clear():void
		{
			_lastCtrlX = _lastX = _startX = 0.0;
			_lastCtrlY = _lastY = _startY = 0.0;
			$clear();
		}
		
		/**
		 * 現在の描画位置を (x, y) に移動します.
		 * @param	x
		 * @param	y
		 */
		public function moveTo(x:Number, y:Number):void
		{
			_lastCtrlX = _lastX = _startX = x;
			_lastCtrlY = _lastY = _startY = y;
			$moveTo( _startX, _startY );
		}
		
		/**
		 * 現在の描画位置から (x, y) まで描画します.
		 * @param	x
		 * @param	y
		 */
		public function lineTo(x:Number, y:Number):void
		{
			_lastCtrlX = _lastX = x;
			_lastCtrlY = _lastY = y;
			$lineTo( _lastX, _lastY );
		}
		
		/**
		 * 指定されたをコントロールポイント(controlX, controlY) を使用し、現在の描画位置から (anchorX, anchorY)まで2次ベジェ曲線を描画します.
		 * @param	controlX
		 * @param	controlY
		 * @param	anchorX
		 * @param	anchorY
		 */
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
			_lastCtrlX = controlX;
			_lastCtrlY = controlY;
			_lastX     = anchorX;
			_lastY     = anchorY;
			$curveTo( _lastCtrlX, _lastCtrlY, _lastX, _lastY );
		}
		
		/**
		 * moveTo() や lineTo() で描画しているシェイプを閉じます.
		 * closePath()メソッドにより、 moveTo() で指定した座標まで lineTo() されます.
		 */
		public function closePath():void
		{
			_lastCtrlX = _lastX = _startX;
			_lastCtrlY = _lastY = _startY;
			$closePath();
		}
		
		/**
		 * 現在の描画位置へ moveTo() します.
		 */
		public function moveToLast():void 
		{
			_lastCtrlX = _startX = _lastX;
			_lastCtrlY = _startY = _lastY;
			$moveTo( _lastX, _lastY );
		}
		
		//--------------------------------------------------------------------------------------------------- ATTRIBUTES
		
		/**
		 * 指定されている線のスタイルをを適用します.
		 */
		public function applyLineStyle():void
		{
			_stroke_do = true;
			_gc.lineStyle( _thickness, _stroke_color, _stroke_alpha, _pixelHinting, _scaleMode, _caps, _joints, _miterLimit );
		}
		
		/**
		 * 線が描画されないようにします.
		 */
		public function noLineStyle():void
		{
			_stroke_do = false;
			_gc.lineStyle();
		}
		
		/**
		 * 指定されている塗りで beginFill() を実行します.
		 */
		public function applyFill():void
		{
			_gc.beginFill( _fill_color, _fill_alpha );
		}
		
		/**
		 * 線のスタイルを指定します.
		 * @param	thickness
		 * @param	color
		 * @param	alpha
		 * @param	pixelHinting
		 * @param	scaleMode
		 * @param	caps
		 * @param	joints
		 * @param	miterLimit
		 */
		public function lineStyle(thickness_:Number=0,color_:uint=0,alpha_:Number=1,pixelHinting_:Boolean=false,scaleMode_:String="normal",caps_:String=null,joints_:String=null,miterLimit_:Number=3):void
		{
			if ( arguments.length > 0 )
			{
				_stroke_color   = color_;
				_stroke_alpha   = alpha_;
				_thickness		= thickness_;
				_pixelHinting	= pixelHinting_;
				_scaleMode		= scaleMode_;
				_caps			= caps_;
				_joints			= joints_;
				_miterLimit		= miterLimit_;
				applyLineStyle();
			}
			else
			{
				noLineStyle();
			}
		}
		
		/**
		 * 線スタイルのグラデーションを指定します.
		 * @param	type
		 * @param	colors
		 * @param	alphas
		 * @param	ratios
		 * @param	matrix
		 * @param	spreadMethod
		 * @param	interpolationMethod
		 * @param	focalPointRatio
		 */
		public function lineGradientStyle( type:String,colors:Array,alphas:Array,ratios:Array,matrix:Matrix=null,spreadMethod:String="pad",interpolationMethod:String="rgb",focalPointRatio:Number=0.0):void
		{
			_gc.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		}
		
		/**
		 * 今後の描画に使用する単色塗りを指定します.
		 * @param	color
		 * @param	alpha
		 */
		public function beginFill(color:uint, alpha:Number=1.0):void
		{
			_fill_color = color;
			_fill_alpha = alpha;
			_gc.beginFill(color,alpha);
		}
		
		/**
		 * 描画領域をビットマップイメージで塗りつぶします.
		 * @param	bitmap
		 * @param	matrix
		 * @param	repeat
		 * @param	smooth
		 */
		public function beginBitmapFill(bitmap:BitmapData,matrix:Matrix=null,repeat:Boolean=true,smooth:Boolean=false):void
		{
			_gc.beginBitmapFill( bitmap, matrix, repeat, smooth );
		}
		
		/**
		 * 今後の描画に使用するグラデーション塗りを指定します.
		 * @param	type
		 * @param	color
		 * @param	alphas
		 * @param	ratios
		 * @param	matrix
		 * @param	spreadMethod
		 * @param	interpolationMethod
		 * @param	focalPointRation
		 */
		public function beginGradientFill(type:String, color:Array, alphas:Array, ratios:Array, matrix:Matrix=null, spreadMethod:String="pad", interpolationMethod:String="rgb",focalPointRation:Number=0.0):void
		{
			_gc.beginGradientFill( type, color, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRation );
		}
		
		/**
		 * beginFill()、beginGradientFill()、または beginBitmapFill() メソッドへの最後の呼び出し以降に追加された線と曲線に塗りを適用します.
		 */
		public function endFill():void
		{
			_gc.endFill();
		}
		
		//--------------------------------------------------------------------------------------------------- DRAW
		
		/**
		 * 円を描画します.
		 * @param	x
		 * @param	y
		 * @param	radius
		 */
		public function drawCircle(x:Number, y:Number, radius:Number):void
		{
			_gc.drawCircle( x, y, radius );
		}
		
		/**
		 * 楕円を描画します.
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 */
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void
		{
			_gc.drawEllipse( x, y, width, height );
		}
		
		/**
		 * 矩形を描画します.
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 */
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void{
			_gc.drawRect( x, y, width, height );
		}
		
		/**
		 * 角丸矩形を描画します.
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 * @param	ellipseWidth
		 * @param	ellipseHeight
		 */
		public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number):void
		{
			_gc.drawRoundRect( x, y, width, height, ellipseWidth, ellipseHeight );
		}
		
		/**
		 * 各コーナーの角丸を指定して、角丸矩形を描画します.
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 * @param	topLeftRadius
		 * @param	topRightRadius
		 * @param	bottomLeftRadius
		 * @param	bottomRightRadius
		 */
		public function drawRoundRectComplex(x:Number, y:Number, width:Number, height:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number):void
		{
			_gc.drawRoundRectComplex( x, y, width, height, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius );
		}
		
	}
	
}