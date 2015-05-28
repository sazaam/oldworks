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
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import frocessing.geom.FNumber3D;
	
	import frocessing.f5internal;
	import frocessing.geom.FMatrix2D;
	import frocessing.geom.FMatrix3D;
	import frocessing.math.FMath;
	import frocessing.f3d.F3DCamera;
	import frocessing.f3d.F3DGraphics;
	import frocessing.f3d.F3DObject;
	
	use namespace f5internal;
	
	/**
	* F5Graphics3D
	* 
	* @author nutsu
	* @version 0.3
	*/
	public class F5Graphics3D extends F5Graphics
	{
		protected var half_width:Number;
		protected var half_height:Number;
		
		//Transform
		private var _matrix:FMatrix3D;
		private var _matrix_tmp:Array;
		
		private var m11:Number;
		private var m12:Number;
		private var m13:Number;
		private var m21:Number;
		private var m22:Number;
		private var m23:Number;
		private var m31:Number;
		private var m32:Number;
		private var m33:Number;
		private var tx:Number;
		private var ty:Number;
		private var tz:Number;
		
		//Camera , Projection
		private var f_camera:F3DCamera;
		private var camera_setting:Boolean;
		private var pers_projection:Boolean;
		
		//Z Coordinates
		protected var vertexsZ:Array;
		protected var splineVertexZ:Array;
		protected var _startZ:Number    = 0;
		protected var _lastZ:Number     = 0;
		protected var _lastCtrlZ:Number = 0;
		protected var _splineZ0:Number  = 0;
		protected var _splineZ1:Number  = 0;
		protected var _splineZ2:Number  = 0;
		
		//Sphere
		private var sphere_segments:uint;
		
		//3D Draw
		protected var __renderGC:F3DGraphics;
		
		//backgeound
		protected var _background_do:Boolean;
		
		// Sprite2D perspective rate
		private var sprite2d_pers_width:Number;
		private var sprite2d_pers_height:Number;
		
		//
		public var transformFillMatrix:Boolean;
		private var fill_matrix:FMatrix2D;
		
		/**
		 * 新しく F5Graphics3D のインスタンスを生成します.
		 * 
		 * @param	gc		描画対象の Graphics
		 * @param	width_	スクリーンの幅
		 * @param	height_	スクリーンの高さ
		 */
		public function F5Graphics3D( gc:Graphics, width_:Number, height_:Number )
		{
			// 3d rendrer
			__renderGC = new F3DGraphics( gc, width_*0.5, height_*0.5 );
			
			super(gc);
			
			_background_do = false;
			
			// size
			_width      = width_;
			_height     = height_;
			half_width  = _width*0.5;
			half_height = _height*0.5;
			
			// camrea and projection
			camera_setting = false;
			f_camera       = new F3DCamera( _width, _height );
			pers_projection = true;
			__renderGC.zNear = f_camera.zNear;
			//image sprite2d
			sprite2d_pers_width  = f_camera.projectionMatrix.m11;
			sprite2d_pers_height = f_camera.projectionMatrix.m22;
			
			// transfrom init
			resetMatrix();
			_matrix_tmp  = [];
			
			// init sphere
			sphereDetail(12);
			
			//
			_bmpGC = null;
			
			//stroke は全て F3DGraphics にて
			_stroke_color = NaN;
			_stroke_alpha = NaN;
			_thickness    = NaN;
			_pixelHinting = false;
			_scaleMode    = null;
			_caps         = null;
			_joints       = null;
			_miterLimit   = NaN;
			
			//
			transformFillMatrix = true;
			fill_matrix = new FMatrix2D();
		}
		
		//--------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function size(width_:uint, height_:uint):void 
		{
			// init canvas size
			_width      = width_;
			_height     = height_;
			half_width  = _width*0.5;
			half_height = _height * 0.5;
			
			// init camera and projection
			f_camera.setScreenSize( width_, height_ );
			__renderGC.zNear = f_camera.zNear;
			
			// set render center coordinate
			__renderGC.centerX = half_width;
			__renderGC.centerY = half_height;
			
			// reset transform
			resetMatrix();
		}
		
		//--------------------------------------------------------------------------------------------------- BEGIN AND END
		
		/**
		 * 描画を開始するときに実行します.
		 */
		override public function beginDraw():void
		{
			clear();
			resetMatrix();
			__renderGC.beginDraw( pers_projection );
			if ( _stroke_do )
				__renderGC.applyLineStyle();
		}
		
		/**
		 * 描画を終了するときに実行します.実際の描画は endDraw() 後に実行されます.
		 */
		override public function endDraw():void
		{
			if ( _background_do )
			{
				_gc.lineStyle();
				_gc.beginFill( _background.value, _background.alpha );
				_gc.drawRect( 0, 0, _width, _height );
				_gc.endFill();
			}
			// rendering 3d image.
			__renderGC.endDraw();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clear():void {
			_lastCtrlX = _lastX = _startX = 0.0;
			_lastCtrlY = _lastY = _startY = 0.0;
			_lastCtrlZ = _lastZ = _startZ = 0.0;
			tintImageCache.dispose();
			__renderGC.clear();
		}
		/**
		 * 
		 */
		override protected function $clear():void { ; }
		
		//-------------------------------------------------------------------------------------------------- DRAW STYLES
		
		/**
		 * @inheritDoc
		 */
		override public function applyLineStyle():void
		{
			__renderGC.applyLineStyle();
			_stroke_do = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function noLineStyle():void
		{
			__renderGC.noLineStyle();
			_stroke_do = false;
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function lineStyle(thickness_:Number=0,color_:uint=0,alpha_:Number=1,pixelHinting_:Boolean=false,scaleMode_:String="normal",caps_:String=null,joints_:String=null,miterLimit_:Number=3):void
		{
			__renderGC.lineStyle.apply( null, arguments );
		}
		
		/**
		 * 実装していません.
		 */
		override public function lineGradientStyle( type:String,colors:Array,alphas:Array,ratios:Array,matrix:Matrix=null,spreadMethod:String="pad",interpolationMethod:String="rgb",focalPointRatio:Number=0.0):void
		{
			// まだ実装していないです.
		}
		
		/**
		 * @inheritDoc
		 */
		override public function beginFill(color:uint, alpha:Number=1.0):void
		{
			_fill_color = color;
			_fill_alpha = alpha;
			__renderGC.beginFill( color, alpha );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function beginBitmapFill(bitmap_:BitmapData, matrix_:Matrix=null, repeat_:Boolean=true, smooth_:Boolean=false ):void
		{
			if ( transformFillMatrix )
			{
				update_fill_matrix();
				if ( matrix_ )
					fill_matrix.prepend( matrix_ );
				__renderGC.beginBitmapFill( bitmap_, fill_matrix, repeat_, smooth_ );
			}
			else
			{
				__renderGC.beginBitmapFill( bitmap_, matrix_, repeat_, smooth_ );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix_:Matrix=null, spreadMethod:String="pad", interpolationMethod:String="rgb",focalPointRation:Number=0.0):void
		{
			if ( transformFillMatrix )
			{
				update_fill_matrix();
				if ( matrix_ )
					fill_matrix.prepend( matrix_ );
				else
					fill_matrix.prepend( default_gradient_matrix );
				__renderGC.beginGradientFill( type, colors, alphas, ratios, fill_matrix, spreadMethod, interpolationMethod, focalPointRation );
			}
			else
			{
				__renderGC.beginGradientFill( type, colors, alphas, ratios, matrix_, spreadMethod, interpolationMethod, focalPointRation );
			}
		}
		
		private function update_fill_matrix():void
		{
			var x0:Number = getX( 0, 0, 0 );
			var y0:Number = getY( 0, 0, 0 );
			var x1:Number = getX( 1, 0, 0 );
			var y1:Number = getY( 1, 0, 0 );
			var x2:Number = getX( 0, 1, 0 );
			var y2:Number = getY( 0, 1, 0 );
			
			if ( pers_projection )
			{
				var znear:Number = f_camera.zNear;
				x0 *= znear / getZ( 0, 0, 0 );
				y0 *= znear / getZ( 0, 0, 0 );
				x1 *= znear / getZ( 1, 0, 0 );
				y1 *= znear / getZ( 1, 0, 0 );
				x2 *= znear / getZ( 0, 1, 0 );
				y2 *= znear / getZ( 0, 1, 0 );
			}
			x1 -= x0;
			y1 -= y0;
			x2 -= x0;
			y2 -= y0;
			x0 += half_width;
			y0 += half_height;
			fill_matrix.setMatrix( x1, y1, x2, y2, x0, y0 );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function applyFill():void
		{
			if( _fill_do )
				__renderGC.beginFill( _fill_color, _fill_alpha );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function endFill():void
		{
			__renderGC.endFill();
		}
		
		//--------------------------------------------------------------------------------------------------- ATTRIBUTES
		
		/**
		 * @inheritDoc
		 */
		override public function background( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void
		{
			color_mode.setColor( _background, c1, c2, c3, c4 );
			clear();
			_background_do = true;
		}
		
		/**
		 * 
		 */
		public function noBackground():void
		{
			_background_do = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function stroke( c1:Number, c2:Number=NaN, c3:Number=NaN, c4:Number=NaN ):void
		{
			color_mode.setColor( _stroke, c1, c2, c3, c4 );
			__renderGC.strokeColor = _stroke.value;
			__renderGC.strokeAlpha = _stroke.alpha;
			applyLineStyle();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function strokeWeight( thickness_:Number ):void
		{
			__renderGC.thickness = thickness_;
			applyLineStyle();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function strokeJoin( jointStyle:String ):void
		{
			__renderGC.joints = jointStyle;
			applyLineStyle();
		}
		
		/**
		 * 線の終端のキャップの種類を指定します.
		 * このメソッドにより lineStyle　が実行され線のスタイルが適用されます.
		 * @see	flash.display.CapsStyle
		 */
		override public function strokeCap( capsStyle:String ):void
		{
			__renderGC.caps = capsStyle;
			applyLineStyle();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get strokeColor():uint { return __renderGC.strokeColor;  }
		override public function set strokeColor(value:uint):void {
			__renderGC.strokeColor = value;
			applyLineStyle();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get strokeAlpha():Number { return __renderGC.strokeAlpha;  }
		override public function set strokeAlpha(value:Number):void {
			__renderGC.strokeAlpha = value;
			applyLineStyle();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get thickness():Number { return __renderGC.thickness;  }
		override public function set thickness(value_:Number):void{
			__renderGC.thickness = value_;
			applyLineStyle();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get pixelHinting():Boolean { return __renderGC.pixelHinting;  }
		override public function set pixelHinting(value_:Boolean):void {
			__renderGC.pixelHinting = value_;
			applyLineStyle();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get scaleMode():String { return __renderGC.scaleMode;  }
		override public function set scaleMode(value_:String):void {
			__renderGC.scaleMode = value_;
			applyLineStyle();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get caps():String { return __renderGC.caps;  }
		override public function set caps(value_:String):void {
			__renderGC.caps = value_;
			applyLineStyle();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get joints():String { return __renderGC.joints;  }
		override public function set joints(value_:String):void {
			__renderGC.joints = value_;
			applyLineStyle();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get miterLimit():Number { return __renderGC.miterLimit;  }
		override public function set miterLimit(value_:Number):void {
			__renderGC.miterLimit = value_;
			applyLineStyle();
		}
		
		//---------------------------------------------------------------------------------------------------
		
		public function get backFaceCulling():Boolean { return __renderGC.backFaceCulling; }
		public function set backFaceCulling( value_:Boolean ):void{
			__renderGC.backFaceCulling = value_;
		}
		
		//--------------------------------------------------------------------------------------------------- OUT TO RENDER
		
		/**
		 * render moveTo. start shape.
		 */
		protected function $moveTo3d( x:Number, y:Number, z:Number ):void
		{
			__renderGC.moveTo( x, y, z );
		}
		
		/**
		 * render lineTo
		 */
		protected function $lineTo3d( x:Number, y:Number, z:Number ):void
		{
			__renderGC.lineTo( x, y, z );
		}
		
		/**
		 * render curveTo
		 */
		protected function $curveTo3d( cx:Number, cy:Number, cz:Number, x:Number, y:Number, z:Number ):void
		{
			__renderGC.curveTo( cx, cy, cz, x, y, z );
		}
		
		/**
		 * render closePath. end shape.
		 */
		override protected function $closePath():void
		{
			__renderGC.closePath();
		}
		
		/**
		 * add Point to render.
		 */
		protected function $point3d( x:Number, y:Number, z:Number, color:uint, alpha_:Number ):void
		{
			__renderGC.point( x, y, z, color, alpha_ );
		}
		
		//--------------------------------------------------------------------------------------------------- 
		
		/**
		 * 
		 */
		override protected function $moveTo( x:Number, y:Number ):void
		{
			__renderGC.moveTo( x, y, _startZ );
		}
		
		/**
		 * 
		 */
		override protected function $lineTo( x:Number, y:Number ):void
		{
			__renderGC.lineTo( x, y, _lastZ );
		}
		
		/**
		 * 
		 */
		override protected function $curveTo( cx:Number, cy:Number, x:Number, y:Number ):void
		{
			__renderGC.curveTo( cx, cy, _lastCtrlZ, x, y, _lastZ );
		}
		
		/**
		 * 
		 */
		override protected function $point( x:Number, y:Number, color:uint, alpha_:Number=1.0 ):void
		{
			$point3d( x, y, 0, color, alpha_ );
		}
		
		//--------------------------------------------------------------------------------------------------- TRANSFORM
		
		/**
		 * 現在の Transform を行う FMatrix3D を示します.
		 */
		public function get matrix():FMatrix3D { return _matrix;  }
		public function set matrix( value:FMatrix3D ):void
		{
			_matrix = value;
			update_transform();
		}
		
		/**
		 * 描画する Graphics を回転します.
		 */
		public function rotate( angle:Number ):void
		{
			rotateZ( angle );
		}
		
		/**
		 * 描画する Graphics を移動します.
		 */
		public function translate( x:Number, y:Number, z:Number=0.0 ):void
		{
			_matrix.prependTranslation( x, y, z );
			update_transform();
		}
		
		/**
		 * 描画する Graphics を拡大/縮小します.
		 * 
		 * @param	x	x のスケールを指定します. xのみが指定された場合、全体のスケールになります.
		 * @param	y	y のスケールを指定します.
		 * @param	z	z のスケールを指定します.
		 */
		public function scale( x:Number, y:Number=NaN, z:Number=1.0 ):void
		{
			if ( isNaN(y) )
				_matrix.prependScale( x, x, x );
			else
				_matrix.prependScale( x, y, z );
			update_transform();
		}
		
		/**
		 * 描画する Graphics をX軸で回転します.
		 */
		public function rotateX( angle:Number ):void
		{
			_matrix.prependRotationX( -angle );
			update_transform();
		}
		
		/**
		 * 描画する Graphics をY軸で回転します.
		 */
		public function rotateY( angle:Number ):void
		{
			_matrix.prependRotationY( -angle );
			update_transform();
		}
		
		/**
		 * 描画する Graphics をZ軸で回転します.
		 */
		public function rotateZ( angle:Number ):void
		{
			_matrix.prependRotationZ( -angle );
			update_transform();
		}
		
		/**
		 * 現在の 変換 Matrix を一時的に保持します.
		 */
		public function pushMatrix():void
		{
			_matrix_tmp.push( new MatrixParam3D(m11,m12,m13,m21,m22,m23,m31,m32,m33,tx,ty,tz) );
		}
		
		/**
		 * 前回、pushMatrix() で保持した 変換 Matrix を復元します.
		 */
		public function popMatrix():void
		{
			applyMatrixParam( _matrix_tmp.pop() );
		}
		
		/**
		 * 変換 Matrix をリセットします.
		 */
		public function resetMatrix():void
		{
			_matrix = f_camera.matrix;
			update_transform();
		}
		
		/**
		 * 変換 Matrix の行列値を指定します.
		 */
		public function applyMatrix(m11_:Number, m12_:Number, m13_:Number,
									m21_:Number, m22_:Number, m23_:Number,
									m31_:Number, m32_:Number, m33_:Number,
									m41_:Number, m42_:Number, m43_:Number):void
		{
			_matrix = f_camera.matrix;
			_matrix.prependMatrix( m11_,m12_,m13_, m21_,m22_,m23_, m31_,m32_,m33_, m41_,m42_,m43_);
			update_transform();
		}
		
		/**
		 * @private
		 */
		private function applyMatrixParam( mt:MatrixParam3D ):void
		{
			_matrix.m11 = m11 = mt.n11;
			_matrix.m12 = m12 = mt.n12;
			_matrix.m13 = m13 = mt.n13;
			_matrix.m21 = m21 = mt.n21;
			_matrix.m22 = m22 = mt.n22;
			_matrix.m23 = m23 = mt.n23;
			_matrix.m31 = m31 = mt.n31;
			_matrix.m32 = m32 = mt.n32;
			_matrix.m33 = m33 = mt.n33;
			_matrix.m41 = tx  = mt.n41;
			_matrix.m42 = ty  = mt.n42;
			_matrix.m43 = tz  = mt.n43;
		}
		
		/**
		 * 変換 Matrix の行列値を <code>trace</code> します.
		 */
		public function printMatrix():void
		{
			trace( _matrix );
		}
		
		/**
		 * @private
		 */
		private function update_transform():void
		{
			m11 = _matrix.m11;
			m12 = _matrix.m12;
			m13 = _matrix.m13;
			m21 = _matrix.m21;
			m22 = _matrix.m22;
			m23 = _matrix.m23;
			m31 = _matrix.m31;
			m32 = _matrix.m32;
			m33 = _matrix.m33;
			tx  = _matrix.m41;
			ty  = _matrix.m42;
			tz  = _matrix.m43;
		}
		
		/*
		private function get untransformed():Boolean
		{
			return m11==1 && m12==0 && m13==0 && m21==0 && m22==1 && m23==0 && m31==0 && m32==0 && m33==1 && tx==0 && ty==0 && tz==0;
		}
		*/
		
		
		//--------------------------------------------------------------------------------------------------- CAMERA
		
		
		/**
		* 透視投影変換(パースペクティブ)でプロジェクションを設定します.
		* @param	fov		field-of-view angle (in radians) for vertical direction
		* @param	aspect	ratio of width to height
		* @param	zNear	z-position of nearest clipping plane
		* @param	zFar	z-position of nearest farthest plane (今は使っていない)
		*/
		public function perspective( fov:Number=NaN, aspect:Number=NaN, zNear:Number=NaN, zFar:Number=NaN ):void
		{
			f_camera.perspective( fov, aspect, zNear, zFar );
			__renderGC.perspective = pers_projection = true;
			__renderGC.zNear       = f_camera.zNear;
			
			//image sprite2d
			sprite2d_pers_width  = f_camera.projectionMatrix.m11;
			sprite2d_pers_height = f_camera.projectionMatrix.m22;
			
			resetMatrix();
		}
		
		/**
		 * 透視投影変換でプロジェクションを設定します.
		 * @param	left
		 * @param	right
		 * @param	bottom
		 * @param	top
		 * @param	near
		 * @param	far		z far (今は使っていない)
		 */
		public function frustum(left:Number, right:Number, bottom:Number, top:Number, zNear:Number, zFar:Number):void
		{
			f_camera.frustum(left, right, bottom, top, zNear, zFar);
			__renderGC.perspective = pers_projection = true;
			__renderGC.zNear       = f_camera.zNear;
			
			//image sprite2d
			sprite2d_pers_width  = f_camera.projectionMatrix.m11;
			sprite2d_pers_height = f_camera.projectionMatrix.m22;
			
			resetMatrix();
		}
		
		/**
		 * 平行投影変換でプロジェクションを設定します.
		 * @param	left	default 0
		 * @param	right	default width
		 * @param	bottom	default 0
		 * @param	top		default height
		 * @param	near	default -10
		 * @param	far		default 10
		 */
		public function ortho(left:Number=NaN, right:Number=NaN, bottom:Number=NaN, top:Number=NaN, near:Number=NaN, far:Number=NaN):void
		{
			f_camera.ortho( left, right, bottom, top, near, far );
			__renderGC.perspective = pers_projection = false;
			
			//image sprite2d
			sprite2d_pers_width  = 1;
			sprite2d_pers_height = 1;
			
			resetMatrix();
		}
		
		
		public function get cameraX():Number { return f_camera.x; }
		public function get cameraY():Number { return f_camera.y; }
		public function get cameraZ():Number { return f_camera.z; }
		
		/**
		* カメラを設定します.
		* @param	eyeX	カメラの座標 x
		* @param	eyeY	カメラの座標 y
		* @param	eyeZ	カメラの座標 z
		* @param	centerX	中心座標 x
		* @param	centerY	中心座標 y
		* @param	centerZ	中心座標 y
		* @param	upX		カメラ姿勢ベクトル x
		* @param	upY		カメラ姿勢ベクトル y
		* @param	upZ		カメラ姿勢ベクトル z
		*/
		public function camera( eyeX:Number=NaN, eyeY:Number=NaN, eyeZ:Number=NaN, centerX:Number=NaN, centerY:Number=NaN, centerZ:Number=NaN, upX:Number=0, upY:Number=1, upZ:Number=0 ):void
		{
			f_camera.camera( eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ );
			resetMatrix();
		}
		
		/**
		 * 
		 */
		public function beginCamera():void
		{
			if ( camera_setting == false )
				camera_setting = true;
		}
		
		/**
		 * 
		 */
		public function translateCamera( x:Number, y:Number, z:Number=0.0 ):void
		{
			if( camera_setting )
				f_camera.translate( x, y, z );
		}
		
		/**
		 * 
		 */
		public function rotateXCamera( angle:Number ):void
		{
			if( camera_setting )
				f_camera.rotateX( angle );
		}
		
		/**
		 * 
		 */
		public function rotateYCamera( angle:Number ):void
		{
			if( camera_setting )
				f_camera.rotateY( angle );
		}
		
		/**
		 * 
		 */
		public function rotateZCamera( angle:Number ):void
		{
			if( camera_setting )
				f_camera.rotateZ( angle );
		}
		
		/**
		 * 
		 */
		public function endCamera():void
		{
			if ( camera_setting )
			{
				camera_setting = false;
				resetMatrix();
			}
		}
		
		/**
		 * カメラの Matrix を trace() します.
		 */
		public function printCamera():void
		{
			trace( f_camera.cameraMatrix );
		}
		
		/**
		 * プロジェクションの Matrix を trace() します.
		 */
		public function printProjection():void
		{
			trace( f_camera.projectionMatrix );
		}
		
		//--------------------------------------------------------------------------------------------------- COORDINATES
		
		/**
		 * @private
		 */
		private function getX( x:Number, y:Number, z:Number ):Number
		{
			return x * m11 + y * m21 + z * m31 + tx;
		}
		
		/**
		 * @private
		 */
		private function getY( x:Number, y:Number, z:Number ):Number
		{
			return x * m12 + y * m22 + z * m32 + ty;
		}
		
		/**
		 * @private
		 */
		private function getZ( x:Number, y:Number, z:Number ):Number
		{
			return x * m13 + y * m23 + z * m33 + tz;
		}
		
		/**
		 * スクリーン上の座標を返します.
		 */
		public function screenXYZ( x:Number, y:Number, z:Number ):FNumber3D
		{
			var xx:Number = getX( x, y, z );
			var yy:Number = getY( x, y, z );
			var zz:Number = getZ( x, y, z );
			if ( pers_projection )
				return new FNumber3D( xx*f_camera.zNear/zz + half_width, yy*f_camera.zNear/zz + half_height, zz );
			else
				return new FNumber3D( xx + half_width, yy + half_height, zz );
		}
		
		/**
		 * ススクリーン上の x 座標を返します.
		 */
		public function screenX( x:Number, y:Number, z:Number ):Number
		{
			if ( pers_projection )
				return  getX( x, y, z )*f_camera.zNear/getZ( x, y, z ) + half_width;
			else
				return  getX( x, y, z ) + half_width;
		}
		
		/**
		 * スクリーン上の y 座標を返します.
		 */
		public function screenY( x:Number, y:Number, z:Number ):Number
		{
			if ( pers_projection )
				return  getY( x, y, z )*f_camera.zNear/getZ( x, y, z ) + half_height;
			else
				return  getY( x, y, z ) + half_height;
		}
		
		/**
		 * スクリーン上の z 座標を返します.
		 */
		public function screenZ( x:Number, y:Number, z:Number ):Number
		{
			return  getZ( x, y, z );
		}
		
		/**
		 * 変換後の座標を返します.
		 */
		public function modelXYZ( x:Number, y:Number, z:Number ):FNumber3D
		{
			var m:FMatrix3D = f_camera.inversion;
			var xx:Number = getX( x, y, z );
			var yy:Number = getY( x, y, z );
			var zz:Number = getZ( x, y, z );
			return new FNumber3D( xx * m.m11 + yy * m.m21 + zz * m.m31 + m.m41,
								  xx * m.m21 + yy * m.m22 + zz * m.m32 + m.m42,
								  xx * m.m13 + yy * m.m23 + zz * m.m33 + m.m43 );
		}
		
		/**
		 * 変換後の x 座標を返します.
		 */
		public function modelX( x:Number, y:Number, z:Number ):Number
		{
			return modelXYZ( x, y, z ).x;
		}
		
		/**
		 * 変換後の y 座標を返します.
		 */
		public function modelY( x:Number, y:Number, z:Number ):Number
		{
			return modelXYZ( x, y, z ).y;
		}
		
		/**
		 * 変換後の z 座標を返します.
		 */
		public function modelZ( x:Number, y:Number, z:Number ):Number
		{
			return modelXYZ( x, y, z ).z;
		}
		
		//--------------------------------------------------------------------------------------------------- 3D PRIMITIVE
		
		/**
		 * 
		 */
		public function model( model_:F3DObject ):void
		{
			model_.updateTransform( m11, m12, m13, m21, m22, m23, m31, m32, m33, tx, ty, tz );
			if ( texture_mode == false )
				applyFill();
			model_.draw( __renderGC );
		}
		
		/**
		 * 立方体を描画します.
		 * 
		 * box(size) or box( width, height, depth );
		 * 
		 * @param	w	size or width
		 * @param	h	height
		 * @param	d	depth
		 */
		public function box( w:Number, h:Number=NaN ,d:Number=NaN, x:Number=0, y:Number=0, z:Number=0 ):void
		{
			w *= 0.5;
			if( isNaN(h) )
			{
				h = w;
				d = w;
			}
			else
			{
				h *= 0.5;
				d *= 0.5;
			}
			
			var x0:Number = getX( x-w, y-h, z+d );
			var y0:Number = getY( x-w, y-h, z+d );
			var z0:Number = getZ( x-w, y-h, z+d );
			var x1:Number = getX( x-w, y+h, z+d );
			var y1:Number = getY( x-w, y+h, z+d );
			var z1:Number = getZ( x-w, y+h, z+d );
			var x2:Number = getX( x+w, y-h, z+d );
			var y2:Number = getY( x+w, y-h, z+d );
			var z2:Number = getZ( x+w, y-h, z+d );
			var x3:Number = getX( x+w, y+h, z+d );
			var y3:Number = getY( x+w, y+h, z+d );
			var z3:Number = getZ( x+w, y+h, z+d );
			var x4:Number = getX( x+w, y-h, z-d );
			var y4:Number = getY( x+w, y-h, z-d );
			var z4:Number = getZ( x+w, y-h, z-d );
			var x5:Number = getX( x+w, y+h, z-d );
			var y5:Number = getY( x+w, y+h, z-d );
			var z5:Number = getZ( x+w, y+h, z-d );
			var x6:Number = getX( x-w, y-h, z-d );
			var y6:Number = getY( x-w, y-h, z-d );
			var z6:Number = getZ( x-w, y-h, z-d );
			var x7:Number = getX( x-w, y+h, z-d );
			var y7:Number = getY( x-w, y+h, z-d );
			var z7:Number = getZ( x-w, y+h, z-d );
			/*
			applyFill();
			__renderGC.polygonSolid( x0, y0, z0, x2, y2, z2, x1, y1, z1 ); endFill();
			applyFill();
			__renderGC.polygonSolid( x2, y2, z2, x3, y3, z3, x1, y1, z1 ); endFill();
			applyFill();
			__renderGC.polygonSolid( x2, y2, z2, x4, y4, z4, x3, y3, z3 ); endFill();
			applyFill();
			__renderGC.polygonSolid( x4, y4, z4, x5, y5, z5, x3, y3, z3 ); endFill();
			applyFill();
			__renderGC.polygonSolid( x4, y4, z4, x6, y6, z6, x5, y5, z5 ); endFill();
			applyFill();
			__renderGC.polygonSolid( x6, y6, z6, x7, y7, z7, x5, y5, z5 ); endFill();
			applyFill();
			__renderGC.polygonSolid( x6, y6, z6, x0, y0, z0, x7, y7, z7 ); endFill();
			applyFill();
			__renderGC.polygonSolid( x0, y0, z0, x1, y1, z1, x7, y7, z7 ); endFill();
			applyFill();
			__renderGC.polygonSolid( x6, y6, z6, x4, y4, z4, x0, y0, z0 ); endFill();
			applyFill();
			__renderGC.polygonSolid( x4, y4, z4, x2, y2, z2, x0, y0, z0 ); endFill();
			applyFill();
			__renderGC.polygonSolid( x1, y1, z1, x3, y3, z3, x7, y7, z7 ); endFill();
			applyFill();
			__renderGC.polygonSolid( x3, y3, z3, x5, y5, z5, x7, y7, z7 ); endFill();
			*/
			
			if ( _fill_do )
			{
				applyFill();
				$moveTo3d( x0, y0, z0 ); $lineTo3d( x2, y2, z2 ); $lineTo3d( x3, y3, z3 ); $lineTo3d( x1, y1, z1 ); $closePath(); endFill();
				applyFill();
				$moveTo3d( x2, y2, z2 ); $lineTo3d( x4, y4, z4 ); $lineTo3d( x5, y5, z5 ); $lineTo3d( x3, y3, z3 ); $closePath(); endFill();
				applyFill();
				$moveTo3d( x4, y4, z4 ); $lineTo3d( x6, y6, z6 ); $lineTo3d( x7, y7, z7 ); $lineTo3d( x5, y5, z5 ); $closePath(); endFill();
				applyFill();
				$moveTo3d( x6, y6, z6 ); $lineTo3d( x0, y0, z0 ); $lineTo3d( x1, y1, z1 ); $lineTo3d( x7, y7, z7 ); $closePath(); endFill();
				applyFill();
				$moveTo3d( x6, y6, z6 ); $lineTo3d( x4, y4, z4 ); $lineTo3d( x2, y2, z2 ); $lineTo3d( x0, y0, z0 ); $closePath(); endFill();
				applyFill();
				$moveTo3d( x1, y1, z1 ); $lineTo3d( x3, y3, z3 ); $lineTo3d( x5, y5, z5 ); $lineTo3d( x7, y7, z7 ); $closePath(); endFill();
			}
			else
			{
				$moveTo3d( x0, y0, z0 ); $lineTo3d( x2, y2, z2 ); $lineTo3d( x3, y3, z3 ); $lineTo3d( x1, y1, z1 ); $closePath();
				$moveTo3d( x4, y4, z4 ); $lineTo3d( x6, y6, z6 ); $lineTo3d( x7, y7, z7 ); $lineTo3d( x5, y5, z5 ); $closePath();
				$moveTo3d( x0, y0, z0 ); $lineTo3d( x6, y6, z6 );
				$moveTo3d( x2, y2, z2 ); $lineTo3d( x4, y4, z4 );
				$moveTo3d( x3, y3, z3 ); $lineTo3d( x5, y5, z5 );
				$moveTo3d( x1, y1, z1 ); $lineTo3d( x7, y7, z7 );
			}
		}
		
		/**
		 * 球体の分割精度を設定します.
		 * @param	detail	segments minimum 3, default 12
		 */
		public function sphereDetail( detail:uint ):void
		{
			sphere_segments = Math.max( 3, detail );
		}
		
		/**
		 * 球体を描画します.
		 * @param	radius
		 */
		public function sphere( radius:Number ):void
		{
			//var smodel:F3DSphere = new F3DSphere( radius, sphere_segments );
			//drawTriangles( smodel.vertices, smodel.indices );
			
			var dh:Number = TWO_PI/sphere_segments;
			var dv:Number = PI/sphere_segments;
			var i:int;
			var j:int;
			var h:Number;
			var h2:Number;
			var r:Number;
			var r2:Number;
			
			beginShape(TRIANGLE_FAN);
			vertex3d( 0, -radius, 0 );
			h = -radius * Math.cos(dv);
			r = radius * Math.sin(dv);
			for ( i = 0; i <=sphere_segments; i++ )
				vertex3d( r * Math.cos( dh * i ), h, r *Math.sin( dh * i ) );
			endShape();
			
			beginShape(TRIANGLE_FAN);
			vertex3d( 0, radius, 0 );
			h *= -1;
			for ( i = 0; i <=sphere_segments; i++ )
				vertex3d( r * Math.cos( dh * i ), h, -r * Math.sin( dh * i ) );
			endShape();
			
			for ( j = 1; j < sphere_segments-1; j++ )
			{
				var dr:Number = dv * j;
				h  = -radius * Math.cos(dr);
				r  =  radius * Math.sin(dr);
				h2 = -radius * Math.cos(dr + dv );
				r2 =  radius * Math.sin(dr + dv );
				beginShape( TRIANGLE_STRIP );
				//beginShape( QUAD_STRIP );
				for ( i = 0; i <= sphere_segments; i++ )
				{
					var c:Number = Math.cos( -dh * i );
					var s:Number = Math.sin( -dh * i );
					vertex3d( r*c,  h,  r*s );
					vertex3d( r2*c, h2, r2*s );
				}
				endShape();
			}
		}
		
		//--------------------------------------------------------------------------------------------------- DRAW
		
		/**
		 * draw point to 3d space.
		 */
		public function point3d( x:Number, y:Number, z:Number ):void
		{
			moveTo3d( x, y, z );
			$point3d( _startX, _startY, _startZ, __renderGC.strokeColor, __renderGC.strokeAlpha );
		}
		
		/**
		 * draw line to 3d space.
		 */
		public function line3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number ):void
		{
			moveTo3d( x0, y0, z0 );
			lineTo3d( x1, y1, z1 );
		}
		
		/**
		 * draw cubic bezier curve to 3d space.
		 */
		public function bezier3d( x0:Number, y0:Number, z0:Number, cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x1:Number, y1:Number, z1:Number ):void
		{
			moveTo3d( x0, y0, z0 );
			bezierTo3d( cx0, cy0, cz0, cx1, cy1, cz1, x1, y1, z1 );
		}
		
		/**
		 * draw spline curve to 3d space.
		 */
		public function curve3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number, x3:Number, y3:Number, z3:Number ):void
		{
			splineInit3d( x0, y0, z0, x1, y1, z1, x2, y2, z2 );
			splineTo3d( x3, y3, z3 );
		}
		
		//--------------------------------------------------------------------------------------------------- VERTEX
		
		/**
		 * @inheritDoc
		 */
		override public function beginShape( mode:int=99 ):void
		{
			shape_mode    = mode;
			vertexsX      = [];
			vertexsY      = [];
			vertexsZ      = [];
			vertexsU      = [];
			vertexsV      = [];
			splineVertexX = [];
			splineVertexY = [];
			splineVertexZ = [];
			
			vertexCount = 0;
			splineVertexCount = 0;
			
			if ( shape_mode_polygon = (mode == POLYGON) )
				applyFill();
		}
		
		override public function texture(textureData:BitmapData):void 
		{
			texture_mode = true;
			if ( _tint_do )
				__renderGC.beginTexture( tintImageCache.getTintImage( textureData, _tint_color ) );
			else
				__renderGC.beginTexture( textureData );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function vertex(x:Number, y:Number, u:Number=0, v:Number=0 ):void
		{
			vertex3d(x, y, 0, u, v );
		}
		/**
		 * 
		 */
		public function vertex3d( x:Number, y:Number, z:Number, u:Number=0, v:Number=0  ):void
		{
			var xx:Number = getX( x, y, z );
			var yy:Number = getY( x, y, z );
			var zz:Number = getZ( x, y, z );
			vertexsX[vertexCount] = xx;
			vertexsY[vertexCount] = yy;
			vertexsZ[vertexCount] = zz;
			vertexsU[vertexCount] = u;
			vertexsV[vertexCount] = v;
			vertexCount++;
			
			var t1:uint;
			var t2:uint;
			var t3:uint;
			
			switch( shape_mode )
			{
				case POINTS:
					_lastCtrlX = _lastX = _startX = xx;
					_lastCtrlY = _lastY = _startY = yy;
					_lastCtrlZ = _lastZ = _startZ = zz;
					$point3d( _startX, _startY, _startZ, __renderGC.strokeColor, __renderGC.strokeAlpha );
					break;
				case LINES:
					if ( vertexCount % 2 == 0 )
					{
						t1 = vertexCount - 2;
						_moveTo3d( vertexsX[t1], vertexsY[t1], vertexsZ[t1] );
						_lineTo3d( xx, yy, zz );
					}
					break;
				case TRIANGLES:
					if ( vertexCount % 3 == 0 )
					{
						t1 = vertexCount - 2;
						t2 = vertexCount - 3;
						_lastCtrlX = _lastX = _startX = vertexsX[t2];
						_lastCtrlY = _lastY = _startY = vertexsY[t2];
						_lastCtrlZ = _lastZ = _startZ = vertexsZ[t2];
						if ( texture_mode )
						{
							__renderGC.polygon( _startX, _startY, _startZ, 
												vertexsX[t1], vertexsY[t1], vertexsZ[t1],
												xx, yy, zz,
												vertexsU[t2], vertexsV[t2],
												vertexsU[t1], vertexsV[t1],
												u, v );
						}
						else
						{
							applyFill();
							__renderGC.polygonSolid( _startX, _startY, _startZ,
													 vertexsX[t1], vertexsY[t1], vertexsZ[t1],
													 xx, yy, zz );
							endFill();
						}
					}
					break;
				case TRIANGLE_FAN:
					if ( vertexCount >= 3 )
					{
						t1 = vertexCount - 2;
						_lastCtrlX = _lastX = _startX = vertexsX[0];
						_lastCtrlY = _lastY = _startY = vertexsY[0];
						_lastCtrlZ = _lastZ = _startZ = vertexsZ[0];
						if ( texture_mode )
						{
							__renderGC.polygon( _startX, _startY, _startZ, 
												vertexsX[t1], vertexsY[t1], vertexsZ[t1],
												xx, yy, zz,
												vertexsU[0], vertexsV[0],
												vertexsU[t1], vertexsV[t1],
												u, v );
						}
						else
						{
							applyFill();
							__renderGC.polygonSolid( _startX, _startY, _startZ,
													 vertexsX[t1], vertexsY[t1], vertexsZ[t1],
													 xx, yy, zz );
							endFill();
						}
					}
					break;
				case TRIANGLE_STRIP:
					if ( vertexCount >= 3 )
					{
						if ( vertexCount % 2 )
						{
							t1 = vertexCount - 2;
							t2 = vertexCount - 3;
						}
						else
						{
							t2 = vertexCount - 2;
							t1 = vertexCount - 3;
						}
						_lastCtrlX = _lastX = _startX = vertexsX[t2];
						_lastCtrlY = _lastY = _startY = vertexsY[t2];
						_lastCtrlZ = _lastZ = _startZ = vertexsZ[t2];
						if ( texture_mode )
						{
							__renderGC.polygon( _startX, _startY, _startZ, 
												xx, yy, zz,
												vertexsX[t1], vertexsY[t1], vertexsZ[t1],
												vertexsU[t2], vertexsV[t2],
												u, v,
												vertexsU[t1], vertexsV[t1]);
						}
						else
						{
							applyFill();
							__renderGC.polygonSolid( _startX, _startY, _startZ,
													 xx, yy, zz,
													 vertexsX[t1], vertexsY[t1], vertexsZ[t1] );
							endFill();
						}
					}
					break;
				case QUADS:
					if ( vertexCount % 4 == 0 )
					{
						t1 = vertexCount - 2;
						t2 = vertexCount - 3;
						t3 = vertexCount - 4;
						if ( texture_mode )
						{
							_lastCtrlX = _lastX = _startX = vertexsX[t3];
							_lastCtrlY = _lastY = _startY = vertexsY[t3];
							_lastCtrlZ = _lastZ = _startZ = vertexsZ[t3];
							__renderGC.image( _startX, _startY, _startZ, 
											  vertexsX[t2], vertexsY[t2], vertexsZ[t2],
											  vertexsX[t1], vertexsY[t1], vertexsZ[t1],
											  xx, yy, zz,
											  vertexsU[t3], vertexsV[t3],
											  vertexsU[t2], vertexsV[t2],
											  vertexsU[t1], vertexsV[t1],
											  u, v );
						}
						else
						{
							applyFill();
							_moveTo3d( vertexsX[t3], vertexsY[t3], vertexsZ[t3] );
							_lineTo3d( vertexsX[t2], vertexsY[t2], vertexsZ[t2] );
							_lineTo3d( vertexsX[t1], vertexsY[t1], vertexsZ[t1] );
							_lineTo3d( xx, yy, zz );
							closePath();
							endFill();
						}
					}
					break;
				case QUAD_STRIP:
					if ( vertexCount >= 4 && vertexCount % 2 == 0 )
					{
						t1 = vertexCount - 2;
						t2 = vertexCount - 3;
						t3 = vertexCount - 4;
						if ( texture_mode )
						{
							_lastCtrlX = _lastX = _startX = vertexsX[t3];
							_lastCtrlY = _lastY = _startY = vertexsY[t3];
							_lastCtrlZ = _lastZ = _startZ = vertexsZ[t3];
							__renderGC.image( _startX, _startY, _startZ, 
											  vertexsX[t2], vertexsY[t2], vertexsZ[t2],
											  xx, yy, zz,
											  vertexsX[t1], vertexsY[t1], vertexsZ[t1],
											  vertexsU[t3], vertexsV[t3],
											  vertexsU[t2], vertexsV[t2],
											  u, v,
											  vertexsU[t1], vertexsV[t1] );
						}
						else
						{
							applyFill();
							_moveTo3d( vertexsX[t3], vertexsY[t3], vertexsZ[t3] );
							_lineTo3d( vertexsX[t2], vertexsY[t2], vertexsZ[t2] );
							_lineTo3d( xx, yy, zz );
							_lineTo3d( vertexsX[t1], vertexsY[t1], vertexsZ[t1] );
							closePath();
							endFill();
						}
					}
					break;
				default:
					if ( vertexCount > 1 )
						_lineTo3d( xx, yy, zz );
					else
						_moveTo3d( xx, yy, zz );
					break;
			}			
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function bezierVertex(cx0:Number, cy0:Number, cx1:Number, cy1:Number, x1:Number, y1:Number):void 
		{
			bezierVertex3d(cx0, cy0, 0, cx1, cy1, 0, x1, y1, 0 );
		}
		public function bezierVertex3d( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void
		{
			if ( shape_mode_polygon )
			{
				var xx:Number = getX( x, y, z );
				var yy:Number = getY( x, y, z );
				var zz:Number = getZ( x, y, z );
				vertexsX[vertexCount] = xx;
				vertexsY[vertexCount] = yy;
				vertexsZ[vertexCount] = zz;
				vertexCount++;
				
				_bezierTo3d( getX( cx0, cy0, cz0 ), getY( cx0, cy0, cz0 ), getZ( cx0, cy0, cz0 ),
							 getX( cx1, cy1, cz1 ), getY( cx1, cy1, cz1 ), getZ( cx1, cy1, cz1 ),
							 xx, yy, zz );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function curveVertex(x:Number, y:Number):void
		{
			curveVertex3d(x, y, 0);
		}
		public function curveVertex3d( x:Number, y:Number, z:Number ):void
		{
			if ( shape_mode_polygon )
			{
				var xx:Number = getX( x, y, z );
				var yy:Number = getY( x, y, z );
				var zz:Number = getZ( x, y, z );
				splineVertexX[splineVertexCount]= xx;
				splineVertexY[splineVertexCount]= yy;
				splineVertexZ[splineVertexCount]= zz;
				splineVertexCount++;
				
				if( splineVertexCount>4 )
				{
					_splineTo3d( xx, yy, zz );
				}
				else if ( splineVertexCount == 4 )
				{
					var t1:int = splineVertexCount - 2;
					var t2:int = splineVertexCount - 3;
					var t3:int = splineVertexCount - 4;
					if ( vertexCount > 0 )
					{
						_splineX0  = splineVertexX[t3];
						_splineY0  = splineVertexY[t3];
						_splineZ0  = splineVertexZ[t3];
						_splineX1  = splineVertexX[t2];
						_splineY1  = splineVertexY[t2];
						_splineZ1  = splineVertexZ[t2];
						_splineX2  = splineVertexX[t1];
						_splineY2  = splineVertexY[t1];
						_splineZ2  = splineVertexZ[t1];
						_splineTo3d( xx, yy, zz );
					}
					else
					{
						_splineInit3d( splineVertexX[t3], splineVertexY[t3], splineVertexZ[t3],
									   splineVertexX[t2], splineVertexY[t2], splineVertexZ[t2],
									   splineVertexX[t1], splineVertexY[t1], splineVertexZ[t1] );
						_splineTo3d( xx, yy, zz );
					}
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function endShape( close_path:Boolean=false ):void
		{
			if ( shape_mode_polygon && close_path )
				closePath();
			vertexCount       = 0;
			splineVertexCount = 0;
			shape_mode        = NONE_SHAPE;
			shape_mode_polygon = false;
			
			if ( texture_mode )
			{
				texture_mode = false;
				__renderGC.endTexture();
			}
		}
		
		//--------------------------------------------------------------------------------------------------- CORE
		
		/**
		 * @inheritDoc
		 */
		override public function moveTo(x:Number, y:Number):void
		{
			_moveTo3d( getX( x, y, 0 ),
					   getY( x, y, 0 ), 
					   getZ( x, y, 0 ) );
		}
		/**
		 *
		 */
		public function moveTo3d( x:Number, y:Number, z:Number ):void
		{
			_moveTo3d( getX( x, y, z ),
					   getY( x, y, z ), 
					   getZ( x, y, z ) );
		}
		private function _moveTo3d( x:Number, y:Number, z:Number ):void
		{
			_lastCtrlX = _lastX = _startX = x;
			_lastCtrlY = _lastY = _startY = y;
			_lastCtrlZ = _lastZ = _startZ = z;
			$moveTo3d( x, y, z );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function lineTo(x:Number, y:Number):void
		{
			_lineTo3d( getX( x, y, 0 ),
					   getY( x, y, 0 ), 
					   getZ( x, y, 0 ) );
		}
		/**
		 *
		 */
		public function lineTo3d(x:Number, y:Number, z:Number):void
		{
			_lineTo3d( getX( x, y, z ),
					   getY( x, y, z ), 
					   getZ( x, y, z ) );
		}
		private function _lineTo3d(x:Number, y:Number, z:Number):void
		{
			_lastCtrlX = _lastX = x;
			_lastCtrlY = _lastY = y;
			_lastCtrlZ = _lastZ = z;
			$lineTo3d( x, y, z );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function curveTo(cx:Number, cy:Number, x:Number, y:Number):void
		{
			curveTo3d( cx, cy, 0, x, y, 0 );
		}
		/**
		 * 
		 */
		public function curveTo3d( cx:Number, cy:Number, cz:Number, x:Number, y:Number, z:Number ):void
		{
			_curveTo3d( getX( cx, cy, cz ),
			            getY( cx, cy, cz ),
						getZ( cx, cy, cz ),
						getX( x, y, z ),
						getY( x, y, z ),
						getZ( x, y, z ));
		}
		private function _curveTo3d( cx:Number, cy:Number, cz:Number, x:Number, y:Number, z:Number ):void
		{
			_lastCtrlX = cx;
			_lastCtrlY = cy;
			_lastCtrlZ = cz;
			_lastX     = x;
			_lastY     = y;
			_lastZ     = z;
			$curveTo3d( _lastCtrlX, _lastCtrlY, _lastCtrlZ, _lastX, _lastY, _lastZ );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function closePath():void
		{
			_lastCtrlX = _lastX = _startX;
			_lastCtrlY = _lastY = _startY;
			_lastCtrlZ = _lastZ = _startZ;
			$closePath();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function moveToLast():void 
		{
			_lastCtrlX = _startX = _lastX;
			_lastCtrlY = _startY = _lastY;
			_lastCtrlZ = _startZ = _lastZ;
			$moveTo3d( _lastX, _lastY, _lastZ );
		}
		
		//--------------------------------------------------------------------------------------------------- 
		
		 /**
		 * @inheritDoc
		 */
		override protected function splineInit( x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number  ):void
		{
			splineInit3d( x0, y0, 0, x1, y1, 0, x2, y2, 0 );
		}
		/**
		 * SPLINE INIT
		 */
		protected function splineInit3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number ):void
		{
			_splineInit3d( getX( x0, y0, z0 ),
						   getY( x0, y0, z0 ),
						   getZ( x0, y0, z0 ),
						   getX( x1, y1, z1 ),
						   getY( x1, y1, z1 ),
						   getZ( x1, y1, z1 ),
						   getX( x2, y2, z2 ),
						   getY( x2, y2, z2 ),
						   getZ( x2, y2, z2 ) );
		}
		private function _splineInit3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number ):void
		{
			_lastCtrlX = _lastX = _startX = x1;
			_lastCtrlY = _lastY = _startY = y1;
			_lastCtrlZ = _lastZ = _startZ = z1;
			$moveTo3d( _startX, _startY, _startZ );
			_splineX0  = x0;
			_splineY0  = y0;
			_splineZ0  = z0;
			_splineX1  = x1;
			_splineY1  = y1;
			_splineZ1  = z1;
			_splineX2  = x2;
			_splineY2  = y2;
			_splineZ2  = z2;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function splineTo( x:Number, y:Number ):void
		{
			splineTo3d( x, y, 0 );
		}
		/**
		 * spline to : after curve
		 */
		public function splineTo3d( x:Number, y:Number, z:Number ):void
		{
			_splineTo3d( getX( x, y, z ),
						 getY( x, y, z ),
						 getZ( x, y, z ) );	
		}
		private function _splineTo3d( x:Number, y:Number, z:Number ):void
		{
			var x0:Number  = _lastX;
			var y0:Number  = _lastY;
			var z0:Number  = _lastZ;
			var cx0:Number = _splineX1 + spline_tightness*( _splineX2 - _splineX0 )/6;
			var cy0:Number = _splineY1 + spline_tightness*( _splineY2 - _splineY0 )/6;
			var cz0:Number = _splineZ1 + spline_tightness*( _splineZ2 - _splineZ0 )/6;
			var cx1:Number = _splineX2 + spline_tightness*( _splineX1 - x )/6;
			var cy1:Number = _splineY2 + spline_tightness*( _splineY1 - y )/6;
			var cz1:Number = _splineZ2 + spline_tightness*( _splineZ1 - z )/6;
			_splineX0      = _splineX1;
			_splineY0      = _splineY1;
			_splineZ0      = _splineZ1;
			_splineX1      = _splineX2;
			_splineY1      = _splineY2;
			_splineZ1      = _splineZ2;
			_splineX2      = x;
			_splineY2      = y;
			_splineZ2      = z;
			_lastCtrlX     = cx1;
			_lastCtrlY     = cy1;
			_lastCtrlZ     = cz1;
			_lastX         = _splineX1;
			_lastY         = _splineY1;
			_lastZ         = _splineZ1;
			$bezier3d( x0, y0, z0, cx0, cy0, cz0, cx1, cy1, cz1, _lastX, _lastY, _lastZ, spline_draw_step );
			//$spline3d(_splineX0,_splineY0,_splineZ0,_splineX1,_splineY1,_splineZ1,_splineX2,_splineY2,_splineZ2,x,y,z,spline_draw_step);
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x1:Number, y1:Number ):void
		{
			bezierTo3d( cx0, cy0, 0, cx1, cy1, 0, x1, y1, 0 );
		}
		/**
		 * cubic bezier to
		 */
		public function bezierTo3d( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void
		{
			_bezierTo3d( getX( cx0, cy0, cz0 ),
						 getY( cx0, cy0, cz0 ),
						 getZ( cx0, cy0, cz0 ),
						 getX( cx1, cy1, cz1 ),
						 getY( cx1, cy1, cz1 ),
						 getZ( cx1, cy1, cz1 ),
						 getX( x, y, z ),
						 getY( x, y, z ),
						 getZ( x, y, z ) );
		}
		private function _bezierTo3d( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void
		{
			var x0:Number = _lastX;
			var y0:Number = _lastY;
			var z0:Number = _lastY;
			_lastCtrlX    = cx1;
			_lastCtrlY    = cy1;
			_lastCtrlZ    = cz1;
			_lastX        = x;
			_lastY        = y;
			_lastZ        = z;
			$bezier3d( x0, y0, z0, cx0, cy0, cz0, cx1, cy1, cz1, x, y, z, bezier_draw_step );
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function rlineTo( x:Number, y:Number ):void
		{
			rlineTo3d( x, y, 0 );
		}
		/**
		 * 
		 */
		public function rlineTo3d( x:Number, y:Number, z:Number ):void
		{
			_lastX += getX( x, y, z );
			_lastY += getY( x, y, z );
			_lastZ += getZ( x, y, z );
			_lineTo3d( _lastX, _lastY, _lastZ );
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function scurveTo( x:Number, y:Number ):void
		{
			scurveTo3d( x, y, 0 );
		}
		public function scurveTo3d( x:Number, y:Number, z:Number ):void
		{
			_curveTo3d( 2*_lastX - _lastCtrlX,
						2*_lastY - _lastCtrlY,
						2*_lastZ - _lastCtrlZ,
						getX( x, y, z ),
						getY( x, y, z ),
						getZ( x, y, z ) );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function sbezierTo( cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			sbezierTo3d( cx1, cy1, 0, x, y, 0 );
			
		}
		public function sbezierTo3d( cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void
		{
			_bezierTo3d( 2*_lastX - _lastCtrlX,
						 2*_lastY - _lastCtrlY,
						 2*_lastZ - _lastCtrlZ,
						 getX( cx1, cy1, cz1 ),
						 getY( cx1, cy1, cz1 ),
						 getZ( cx1, cy1, cz1 ),
						 getX( x, y, z ),
						 getY( x, y, z ),
						 getZ( x, y, z ) );
		}
		
		/**
		 * draw cubic bezier to
		 * @internal global coordinates
		 */
		protected function $bezier3d( x0:Number, y0:Number, z0:Number, cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x1:Number, y1:Number, z1:Number, drawstep:uint ):void
		{
			var k:Number = 1.0/drawstep;
			var t:Number;
			var tp:Number;
			
			for ( var i:int = 1; i <= drawstep; i++ )
			{
				t = i*k;
				tp = 1.0 - t;
				_lastX = x0*tp*tp*tp + 3*cx0*t*tp*tp + 3*cx1*t*t*tp + x1*t*t*t;
				_lastY = y0*tp*tp*tp + 3*cy0*t*tp*tp + 3*cy1*t*t*tp + y1*t*t*t;
				_lastZ = z0*tp*tp*tp + 3*cz0*t*tp*tp + 3*cz1*t*t*tp + z1*t*t*t;
				$lineTo3d( _lastX, _lastY, _lastZ );
			}
		}
		
		/**
		 * draw spline curve to
		 * @internal global coordinates
		 */
		protected function $spline3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number, x3:Number, y3:Number, z3:Number, drawstep:uint  ):void
		{
			// Catmull-Rom Spline Curve
			var k:Number = 1.0/spline_draw_step;
			var t:Number;
			var v0x:Number = spline_tightness*( x2 - x0 )*0.5;
			var v0y:Number = spline_tightness*( y2 - y0 )*0.5;
			var v0z:Number = spline_tightness*( z2 - z0 )*0.5;
			var v1x:Number = spline_tightness*( x3 - x1 )*0.5;
			var v1y:Number = spline_tightness*( y3 - y1 )*0.5;
			var v1z:Number = spline_tightness*( z3 - z1 )*0.5;
			
			for ( var i:int = 1; i <= spline_draw_step;  i++ )
			{
				t = i*k;
				_lastX = t*t*t*( 2*x1 - 2*x2 + v0x + v1x ) + t*t*( -3*x1 + 3*x2 - 2*v0x - v1x ) + v0x*t + x1;
				_lastY = t*t*t*( 2*y1 - 2*y2 + v0y + v1y ) + t*t*( -3*y1 + 3*y2 - 2*v0y - v1y ) + v0y*t + y1;
				_lastZ = t*t*t*( 2*z1 - 2*z2 + v0z + v1z ) + t*t*( -3*z1 + 3*z2 - 2*v0z - v1z ) + v0z*t + z1;
				$lineTo3d( _lastX, _lastY, _lastZ );
			}
		}
		
		//--------------------------------------------------------------------------------------------------- IMAGE
		
		/**
		 * @inheritDoc
		 */
		override public function get imageSmoothing():Boolean { return __renderGC.smooth; }
		override public function set imageSmoothing( value_:Boolean ):void
		{
			__renderGC.smooth = value_;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get imageDetail():uint { return __renderGC.detail; }
		override public function set imageDetail( value_:uint ):void
		{
			__renderGC.detail = value_;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function image(img:BitmapData, x:Number, y:Number, w:Number = NaN, h:Number = NaN):void
		{
			image3d( img, x, y, 0, w, h );
		}
		
		/**
		 * 画像を描画します.
		 * 画像には回転などの変形は適用されません.Z値によるパースペクティブが適用されます.
		 */
		public function image3d( img:BitmapData, x:Number, y:Number, z:Number, w:Number = NaN, h:Number = NaN ):void
		{
			var center_:Boolean = false;
			if ( isNaN(w) || isNaN(h) )
			{
				if( image_mode==RADIUS || image_mode==CENTER )
					center_ = true;
				w = img.width;
				h = img.height;
			}
			else
			{
				switch( image_mode )
				{
					case CORNERS:
						w  -= x;
						h  -= y;
						break;
					case RADIUS:
						center_ = true;
						w *= 2;
						h *= 2;
						break;
					case CENTER:
						center_ = true;
						break;
				}
			}
			w *= sprite2d_pers_width;
			h *= sprite2d_pers_height;
			
			if ( _tint_do )
				__renderGC.beginTexture( tintImageCache.getTintImage( img, _tint_color ) );
			else
				__renderGC.beginTexture( img );
			
			__renderGC.bitmap( getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ), w, h, center_ );
			__renderGC.endTexture();
		}
		
		//--------------------------------------------------------------------------------------------------- BITMAP
		
		/**
		 * 
		 * @param	bitmapdata
		 * @param	vertices	[x,y,z,...] vertex data
		 */
		public function drawTriangles( vertices:Array, indices:Array ):void
		{
			var len:int = vertices.length;
			var xx:Number;
			var yy:Number;
			var zz:Number;
			var vtx:Array = [];
			var i:int = 0;
			var j:int = 1;
			var k:int = 2;
			for ( i = 0; i < len; i+=3 )
			{
				xx = vertices[i];
				yy = vertices[j];
				zz = vertices[k];
				vtx[i] = getX( xx, yy, zz );
				vtx[j] = getY( xx, yy, zz );
				vtx[k] = getZ( xx, yy, zz );
				j += 3;
				k += 3;
			}
			applyFill();
			__renderGC.drawTriangles( vtx, indices );
			endFill();
		}
		
		/**
		 * 
		 * @param	bitmapdata
		 * @param	vertices	[x,y,z,...] vertex data
		 * @param	indices
		 * @param	uvData
		 */
		public function drawBitmapTriangles( bitmapdata:BitmapData, vertices:Array, indices:Array, uvData:Array ):void
		{
			var len:int = vertices.length;
			var xx:Number;
			var yy:Number;
			var zz:Number;
			var vtx:Array = [];
			var i:int = 0;
			var j:int = 1;
			var k:int = 2;
			for ( i = 0; i < len; i+=3 )
			{
				xx = vertices[i];
				yy = vertices[j];
				zz = vertices[k];
				vtx[i] = getX( xx, yy, zz );
				vtx[i] = getY( xx, yy, zz );
				vtx[k] = getZ( xx, yy, zz );
				j += 3;
				k += 3;
			}
			__renderGC.beginTexture( bitmapdata );
			__renderGC.drawTriangles( vtx, indices, uvData );
			__renderGC.endTexture();
		}
		
		/**
		 * 
		 * @param	bitmapdata
		 * @param	vertices	[x,y,z,...] vertex data
		 * @param	indices
		 * @param	uvData
		 */
		public function drawBitmapMesh( bitmapdata:BitmapData, vertices:Array, indices:Array, uvData:Array ):void
		{
			var len:int = vertices.length;
			var xx:Number;
			var yy:Number;
			var zz:Number;
			var vtx:Array = [];
			var i:int = 0;
			var j:int = 1;
			var k:int = 2;
			for ( i = 0; i < len; i += 3 )
			{
				xx = vertices[i];
				yy = vertices[j];
				zz = vertices[k];
				vtx[i] = getX( xx, yy, zz );
				vtx[j] = getY( xx, yy, zz );
				vtx[k] = getZ( xx, yy, zz );
				j += 3;
				k += 3;
			}
			__renderGC.beginTexture( bitmapdata );
			__renderGC.drawMesh( vtx, indices, uvData );
			__renderGC.endTexture();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function drawBitmapRect( bitmapdata:BitmapData, x:Number, y:Number, w:Number, h:Number ):void
		{
			drawBitmapQuad( bitmapdata, x, y, x + w, y, x + w, y + h, x, y + h );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function drawBitmapTriangle( bitmapdata:BitmapData,
											x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number,
											u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number ):void
		{
			__renderGC.beginTexture( bitmapdata );
			__renderGC.polygon( getX( x0, y0, 0 ), getY( x0, y0, 0 ), getZ( x0, y0, 0 ),
								getX( x1, y1, 0 ), getY( x1, y1, 0 ), getZ( x1, y1, 0 ),
								getX( x2, y2, 0 ), getY( x2, y2, 0 ), getZ( x2, y2, 0 ),
								u0, v0, u1, v1, u2, v2 );
			__renderGC.endTexture();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function drawBitmapQuad( bitmapdata:BitmapData,
										x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number,
										u0:Number=0, v0:Number=0, u1:Number=1, v1:Number=0, u2:Number=1, v2:Number=1, u3:Number=0, v3:Number=1 ):void
		{
			__renderGC.beginTexture( bitmapdata );
			__renderGC.image( getX( x0, y0, 0 ), getY( x0, y0, 0 ), getZ( x0, y0, 0 ),
							  getX( x1, y1, 0 ), getY( x1, y1, 0 ), getZ( x1, y1, 0 ),
							  getX( x2, y2, 0 ), getY( x2, y2, 0 ), getZ( x2, y2, 0 ),
							  getX( x3, y3, 0 ), getY( x3, y3, 0 ), getZ( x3, y3, 0 ),
							  u0, v0, u1, v1, u2, v2, u3, v3 );
			__renderGC.endTexture();
		}
		
		
		//--------------------------------------------------------------------------------------------------- f5internal
		
		/**
		 * 
		 */
		f5internal override function f5DrawBitmapFont( img:BitmapData, x1:Number, y1:Number, x2:Number, y2:Number, z:Number=0 ):void
		{
			if ( _tint_do )
				__renderGC.beginTexture( tintImageCache.getTintImage( img, _tint_color ) );
			else
				__renderGC.beginTexture( img );
			
			__renderGC.image( getX( x1, y1, z ), getY( x1, y1, z ), getZ( x1, y1, z ),
							  getX( x2, y1, z ), getY( x2, y1, z ), getZ( x2, y1, z ),
							  getX( x2, y2, z ), getY( x2, y2, z ), getZ( x2, y2, z ),
							  getX( x1, y2, z ), getY( x1, y2, z ), getZ( x1, y2, z ),
							  0, 0, 1, 0, 1, 1, 0, 1 );
			__renderGC.endTexture();
		}
		
		/**
		 * 
		 */
		f5internal override function f5Vertex( x:Number, y:Number, z:Number, u:Number=0, v:Number=0 ):void
		{
			vertex3d( x, y, z, u, v );
		}
		/**
		 * 
		 */
		f5internal override function f5moveTo( x:Number, y:Number, z:Number ):void
		{
			moveTo3d( x, y, z );
		}
		/**
		 * 
		 */
		f5internal override function f5lineTo( x:Number, y:Number, z:Number ):void
		{
			lineTo3d( x, y, z );
		}
		/**
		 * 
		 */
		f5internal override function f5curveTo( cx:Number, cy:Number, cz:Number, x:Number, y:Number, z:Number ):void
		{
			curveTo3d( cx, cy, cz, x, y, z );
		}
		
	}
	
}

class MatrixParam3D 
{
	internal var n11:Number;
	internal var n12:Number;
	internal var n13:Number;
	internal var n21:Number;
	internal var n22:Number;
	internal var n23:Number;
	internal var n31:Number;
	internal var n32:Number;
	internal var n33:Number;
	internal var n41:Number;
	internal var n42:Number;
	internal var n43:Number;
	
	function MatrixParam3D(m11_:Number, m12_:Number, m13_:Number,
						   m21_:Number, m22_:Number, m23_:Number,
						   m31_:Number, m32_:Number, m33_:Number,
						   m41_:Number, m42_:Number, m43_:Number ){
		n11 = m11_; n12 = m12_; n13 = m13_;
		n21 = m21_; n22 = m22_; n23 = m23_;
		n31 = m31_; n32 = m32_; n33 = m33_;
		n41 = m41_; n42 = m42_; n43 = m43_;
	}
}