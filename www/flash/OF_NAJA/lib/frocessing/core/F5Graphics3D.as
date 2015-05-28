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
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import frocessing.shape.FShape;
	
	import frocessing.geom.FNumber3D;
	import frocessing.geom.FMatrix2D;
	import frocessing.geom.FMatrix3D;
	import frocessing.math.FMath;
	import frocessing.f3d.F3DCamera;
	import frocessing.f3d.F3DObject;
	import frocessing.shape.IFShape;
	
	import frocessing.f5internal;
	use namespace f5internal;
	
	/**
	* F5Graphics3D は、F5Graphics に 3D描画 API を実装したクラスです.
	* 
	* @author nutsu
	* @version 0.5.8
	*/
	public class F5Graphics3D extends F5Graphics
	{
		//3D Draw ------------------------------
		/** @private */
		internal var gc3d:GraphicsEx3D;
		/** @private */
		protected var half_width:Number;
		/** @private */
		protected var half_height:Number;
		
		//Transform ------------------------------
		private var __matrix:FMatrix3D;
		private var __matrix_tmp:Array;
		
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
		
		//Camera , Projection ------------------------------
		/** @private */
		f5internal var _cameraObject:F3DCamera;
		private var camera_setting:Boolean;
		private var pers_projection:Boolean;
		
		// Sprite2D perspective rate
		private var sprite2d_pers_width:Number;
		private var sprite2d_pers_height:Number;
		
		// Vertex ------------------------------
		/** @private */
		internal var verticesZ:Array;
		/** @private */
		internal var splineVerticesZ:Array;
		
		//Sphere ------------------------------
		private var sphere_segments:uint;
		
		//Fill Matrix -------------------------
		public var transformFillMatrix:Boolean = true;
		
		/**
		 * 新しく F5Graphics3D のインスタンスを生成します.
		 * 
		 * @param	gc		描画対象の Graphics
		 * @param	width_	スクリーンの幅
		 * @param	height_	スクリーンの高さ
		 */
		public function F5Graphics3D( graphics:Graphics, width_:Number, height_:Number )
		{
			super( graphics );
			
			// size
			_width      	= width_;
			_height     	= height_;
			half_width  	= _width*0.5;
			half_height 	= _height * 0.5;
			gc3d.centerX    = half_width;
			gc3d.centerY	= half_height;
			
			// camrea and projection
			camera_setting 	= false;
			_cameraObject   = new F3DCamera( _width, _height );
			pers_projection = true;
			gc3d.zNear		= _cameraObject.zNear;
			//image sprite2d
			sprite2d_pers_width  = _cameraObject.projectionMatrix.m11;
			sprite2d_pers_height = _cameraObject.projectionMatrix.m22;
			
			// transfrom init
			resetMatrix();
			__matrix_tmp  = [];
			
			// init sphere
			sphereDetail(12);
		}
		
		/**
		 * @private
		 */
		override protected function __initGC(graphics:Graphics):void 
		{
			// 3d rendrer
			gc3d = new GraphicsEx3D( graphics );
			gc = gc3d;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function size(width_:uint, height_:uint):void 
		{
			// init canvas size
			_width      = width_;
			_height     = height_;
			half_width  = _width * 0.5;
			half_height = _height * 0.5;
			
			// init camera and projection
			_cameraObject.setScreenSize( _width, _height );
			gc3d.zNear = _cameraObject.zNear;
			
			// set render center coordinate
			gc3d.centerX = half_width;
			gc3d.centerY = half_height;
			
			// reset transform
			resetMatrix();
		}
		
		/**
		 * 描画を開始するときに実行します.
		 */
		override public function beginDraw():void
		{
			clear();
			resetMatrix();
			camera_setting = false;
			gc3d.beginDraw( pers_projection );
			if ( gc3d.__stroke )
				gc3d.applyStroke();
		}
		
		/**
		 * 描画を終了するときに実行します.実際の描画は endDraw() 後に実行されます.
		 */
		override public function endDraw():void
		{
			// rendering 3d image.
			gc3d.endDraw();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// TRANSFORM
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 現在の Transform を行う FMatrix3D を示します.
		 */
		public function get matrix():FMatrix3D { return __matrix;  }
		public function set matrix( value:FMatrix3D ):void
		{
			__matrix = value;
			update_transform();
		}
		
		/**
		 * 現在の 変換 Matrix を一時的に保持します.
		 */
		override public function pushMatrix():void
		{
			__matrix_tmp.push( new MatrixParam3D(m11,m12,m13,m21,m22,m23,m31,m32,m33,tx,ty,tz) );
		}
		
		/**
		 * 前回、pushMatrix() で保持した 変換 Matrix を復元します.
		 */
		override public function popMatrix():void
		{
			__applyMatrixParam( __matrix_tmp.pop() );
		}
		
		/**
		 * 変換 Matrix をリセットします.
		 */
		public function resetMatrix():void
		{
			__matrix = _cameraObject.matrix;
			update_transform();
		}
		
		/**
		 * @private
		 */
		private function __applyMatrixParam( mt:MatrixParam3D ):void
		{
			__matrix.m11 = m11 = mt.n11;
			__matrix.m12 = m12 = mt.n12;
			__matrix.m13 = m13 = mt.n13;
			__matrix.m21 = m21 = mt.n21;
			__matrix.m22 = m22 = mt.n22;
			__matrix.m23 = m23 = mt.n23;
			__matrix.m31 = m31 = mt.n31;
			__matrix.m32 = m32 = mt.n32;
			__matrix.m33 = m33 = mt.n33;
			__matrix.m41 = tx  = mt.n41;
			__matrix.m42 = ty  = mt.n42;
			__matrix.m43 = tz  = mt.n43;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 描画する Graphics を移動します.
		 * beginCamera()の後では、カメラの移動になります.
		 */
		public function translate( x:Number, y:Number, z:Number=0.0 ):void
		{
			if ( !camera_setting )
			{
				__matrix.prependTranslation( x, y, z );
				update_transform();
			}
			else
			{
				_cameraObject.translate( x, y, z );
			}
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
			if ( !camera_setting )
			{
				if ( isNaN(y) )
					__matrix.prependScale( x, x, x );
				else
					__matrix.prependScale( x, y, z );
				update_transform();
			}
		}
		
		/**
		 * 描画する Graphics を回転します.
		 */
		public function rotate( angle:Number ):void
		{
			rotateZ( angle );
		}
		
		/**
		 * 描画する Graphics をX軸で回転します.
		 * beginCamera()の後では、カメラの回転になります.
		 */
		public function rotateX( angle:Number ):void
		{
			if ( !camera_setting )
			{
				__matrix.prependRotationX( -angle );
				update_transform();
			}
			else
			{
				_cameraObject.rotateX( angle );
			}
		}
		
		/**
		 * 描画する Graphics をY軸で回転します.
		 * beginCamera()の後では、カメラの回転になります.
		 */
		public function rotateY( angle:Number ):void
		{
			if ( !camera_setting )
			{
				__matrix.prependRotationY( -angle );
				update_transform();
			}
			else
			{
				_cameraObject.rotateY( angle );
			}
		}
		
		/**
		 * 描画する Graphics をZ軸で回転します.
		 * beginCamera()の後では、カメラの回転になります.
		 */
		public function rotateZ( angle:Number ):void
		{
			if ( !camera_setting )
			{
				__matrix.prependRotationZ( -angle );
				update_transform();
			}
			else
			{
				_cameraObject.rotateZ( angle );
			}
		}
		
		/**
		 * 変換 Matrix の行列値を指定します.
		 */
		public function applyMatrix(m11_:Number, m12_:Number, m13_:Number,
									m21_:Number, m22_:Number, m23_:Number,
									m31_:Number, m32_:Number, m33_:Number,
									m41_:Number, m42_:Number, m43_:Number):void
		{
			__matrix.prependMatrix( m11_,m12_,m13_, m21_,m22_,m23_, m31_,m32_,m33_, m41_,m42_,m43_);
			update_transform();
		}
		
		/**
		 * Matrixの変換を適用します
		 * @private
		 */
		override public function applyMatrix2D( mat:Matrix ):void
		{
			__matrix.prependMatrix( mat.a,mat.b,0, mat.c,mat.d,0, 0,0,1, mat.tx,mat.ty,0);
			update_transform();
		}
		
		/**
		 * 変換 Matrix の行列値を <code>trace</code> します.
		 */
		public function printMatrix():void
		{
			trace( __matrix );
		}
		
		/**
		 * @private
		 */
		private function update_transform():void
		{
			m11 = __matrix.m11;
			m12 = __matrix.m12;
			m13 = __matrix.m13;
			m21 = __matrix.m21;
			m22 = __matrix.m22;
			m23 = __matrix.m23;
			m31 = __matrix.m31;
			m32 = __matrix.m32;
			m33 = __matrix.m33;
			tx  = __matrix.m41;
			ty  = __matrix.m42;
			tz  = __matrix.m43;
		}
		
		/*
		private function get untransformed():Boolean
		{
			return m11==1 && m12==0 && m13==0 && m21==0 && m22==1 && m23==0 && m31==0 && m32==0 && m33==1 && tx==0 && ty==0 && tz==0;
		}
		*/
		
		//------------------------------------------------------------------------------------------------------------------- COORDINATES
		
		/**
		 * @private
		 */
		internal function getX( x:Number, y:Number, z:Number ):Number
		{
			return x * m11 + y * m21 + z * m31 + tx;
		}
		
		/**
		 * @private
		 */
		internal function getY( x:Number, y:Number, z:Number ):Number
		{
			return x * m12 + y * m22 + z * m32 + ty;
		}
		
		/**
		 * @private
		 */
		internal function getZ( x:Number, y:Number, z:Number ):Number
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
				return new FNumber3D( xx*_cameraObject.zNear/zz + half_width, yy*_cameraObject.zNear/zz + half_height, zz );
			else
				return new FNumber3D( xx + half_width, yy + half_height, zz );
		}
		
		/**
		 * ススクリーン上の x 座標を返します.
		 */
		public function screenX( x:Number, y:Number, z:Number ):Number
		{
			if ( pers_projection )
				return  getX( x, y, z )*_cameraObject.zNear/getZ( x, y, z ) + half_width;
			else
				return  getX( x, y, z ) + half_width;
		}
		
		/**
		 * スクリーン上の y 座標を返します.
		 */
		public function screenY( x:Number, y:Number, z:Number ):Number
		{
			if ( pers_projection )
				return  getY( x, y, z )*_cameraObject.zNear/getZ( x, y, z ) + half_height;
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
			var m:FMatrix3D = _cameraObject.inversion;
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
		
		//-------------------------------------------------------------------------------------------------------------------
		// CAMERA
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		* 透視投影変換(パースペクティブ)でプロジェクションを設定します.
		* @param	fov		field-of-view angle (in radians) for vertical direction
		* @param	aspect	ratio of width to height
		* @param	zNear	z-position of nearest clipping plane
		* @param	zFar	z-position of nearest farthest plane (今は使っていない)
		*/
		public function perspective( fov:Number=NaN, aspect:Number=NaN, zNear:Number=NaN, zFar:Number=NaN ):void
		{
			_cameraObject.perspective( fov, aspect, zNear, zFar );
			gc3d.perspective = pers_projection = true;
			gc3d.zNear       = _cameraObject.zNear;
			
			//image sprite2d
			sprite2d_pers_width  = _cameraObject.projectionMatrix.m11;
			sprite2d_pers_height = _cameraObject.projectionMatrix.m22;
			
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
			_cameraObject.frustum(left, right, bottom, top, zNear, zFar);
			gc3d.perspective = pers_projection = true;
			gc3d.zNear       = _cameraObject.zNear;
			//image sprite2d
			sprite2d_pers_width  = _cameraObject.projectionMatrix.m11;
			sprite2d_pers_height = _cameraObject.projectionMatrix.m22;
			
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
			_cameraObject.ortho( left, right, bottom, top, near, far );
			gc3d.perspective = pers_projection = false;
			
			//image sprite2d
			sprite2d_pers_width  = 1;
			sprite2d_pers_height = 1;
			
			resetMatrix();
		}
		
		public function get cameraX():Number { return _cameraObject.x; }
		public function get cameraY():Number { return _cameraObject.y; }
		public function get cameraZ():Number { return _cameraObject.z; }
		
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
			_cameraObject.camera( eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ );
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
			trace( _cameraObject.cameraMatrix );
		}
		
		/**
		 * プロジェクションの Matrix を trace() します.
		 */
		public function printProjection():void
		{
			trace( _cameraObject.projectionMatrix );
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// 3D PRIMITIVE
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function model( model_:F3DObject ):void
		{
			model_.updateTransform( m11, m12, m13, m21, m22, m23, m31, m32, m33, tx, ty, tz );
			var tmp_culling:Boolean = gc3d.backFaceCulling;
			if ( __texture )
			{
				model_.draw( gc3d );
				gc3d.endTexture();
				__texture = false;
			}
			else
			{
				gc3d.applyFill();
				model_.draw( gc3d );
				gc3d.endFill();
			}
			gc3d.backFaceCulling = tmp_culling;
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
			
			if ( gc3d.fillDo )
			{
				gc3d.applyFill();
				gc3d.plane( x0, y0, z0, x2, y2, z2, x3, y3, z3, x1, y1, z1 );
				gc3d.plane( x2, y2, z2, x4, y4, z4, x5, y5, z5, x3, y3, z3 );
				gc3d.plane( x4, y4, z4, x6, y6, z6, x7, y7, z7, x5, y5, z5 );
				gc3d.plane( x6, y6, z6, x0, y0, z0, x1, y1, z1, x7, y7, z7 );
				gc3d.plane( x6, y6, z6, x4, y4, z4, x2, y2, z2, x0, y0, z0 );
				gc3d.plane( x1, y1, z1, x3, y3, z3, x5, y5, z5, x7, y7, z7 );
				gc3d.endFill();
			}
			else
			{
				gc3d.moveTo3d( x0, y0, z0 ); gc3d.lineTo3d( x2, y2, z2 ); gc3d.lineTo3d( x3, y3, z3 ); gc3d.lineTo3d( x1, y1, z1 ); gc3d.closePath();
				gc3d.moveTo3d( x4, y4, z4 ); gc3d.lineTo3d( x6, y6, z6 ); gc3d.lineTo3d( x7, y7, z7 ); gc3d.lineTo3d( x5, y5, z5 ); gc3d.closePath();
				gc3d.moveTo3d( x0, y0, z0 ); gc3d.lineTo3d( x6, y6, z6 );
				gc3d.moveTo3d( x2, y2, z2 ); gc3d.lineTo3d( x4, y4, z4 );
				gc3d.moveTo3d( x3, y3, z3 ); gc3d.lineTo3d( x5, y5, z5 );
				gc3d.moveTo3d( x1, y1, z1 ); gc3d.lineTo3d( x7, y7, z7 );
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
		
		//-------------------------------------------------------------------------------------------------------------------
		// Shape
		//-------------------------------------------------------------------------------------------------------------------
		
		//------------------------------------------------------------------------------------------------------------------- Path
		
		/**
		 * @inheritDoc
		 */
		override public function moveTo(x:Number, y:Number, z:Number=0 ):void
		{
			gc3d.moveTo3d( getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ) );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function lineTo(x:Number, y:Number, z:Number=0):void
		{
			gc3d.lineTo3d( getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ) );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function curveTo(cx:Number, cy:Number, x:Number, y:Number):void
		{
			curveTo3d( cx, cy, 0, x, y, 0 );
		}
		public function curveTo3d( cx:Number, cy:Number, cz:Number, x:Number, y:Number, z:Number ):void
		{
			gc3d.curveTo3d( getX( cx, cy, cz ), getY( cx, cy, cz ), getZ( cx, cy, cz ),
							getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ) );
		}
		/** @private */
		override internal function _curveTo( cx:Number, cy:Number, cz:Number, x:Number, y:Number, z:Number ):void {
			curveTo3d( cx, cy, cz, x, y, z );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function bezierTo( cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void
		{
			bezierTo3d( cx0, cy0, 0, cx1, cy1, 0, x, y, 0 );
		}
		public function bezierTo3d( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void
		{
			gc3d.bezierTo3d( getX( cx0, cy0, cz0 ), getY( cx0, cy0, cz0 ), getZ( cx0, cy0, cz0 ),
							 getX( cx1, cy1, cz1 ), getY( cx1, cy1, cz1 ), getZ( cx1, cy1, cz1 ),
							 getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ) );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function splineTo(cx0:Number, cy0:Number, cx1:Number, cy1:Number, x:Number, y:Number ):void 
		{
			splineTo3d( cx0, cy0, 0, cx1, cy1, 0, x, y, 0 );
		}
		public function splineTo3d( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void
		{
			gc3d.splineTo3d( getX( cx0, cy0, cz0 ), getY( cx0, cy0, cz0 ), getZ( cx0, cy0, cz0 ),
							 getX( cx1, cy1, cz1 ), getY( cx1, cy1, cz1 ), getZ( cx1, cy1, cz1 ),
							 getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ) );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function point(x:Number, y:Number, z:Number = 0):void 
		{
			gc3d.point3d( getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ) );
		}
		
		//------------------------------------------------------------------------------------------------------------------- 2D Primitives
		
		/**
		 * draw line to 3d space.
		 */
		public function line3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number ):void
		{
			moveTo( x0, y0, z0 );
			lineTo( x1, y1, z1 );
		}
		
		//------------------------------------------------------------------------------------------------------------------- Curves
		
		/**
		 * draw cubic bezier curve to 3d space.
		 */
		public function bezier3d( x0:Number, y0:Number, z0:Number, cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x1:Number, y1:Number, z1:Number ):void
		{
			gc3d.applyFill();
			moveTo( x0, y0, z0 );
			bezierTo3d( cx0, cy0, cz0, cx1, cy1, cz1, x1, y1, z1 );
			gc3d.endFill();
		}
		
		/**
		 * draw spline curve to 3d space.
		 */
		public function curve3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number, x3:Number, y3:Number, z3:Number ):void
		{
			beginShape();
			curveVertex3d( x0, y0, z0 );
			curveVertex3d( x1, y1, z1 );
			curveVertex3d( x2, y2, z2 );
			curveVertex3d( x3, y3, z3 );
			endShape();
		}
		
		//------------------------------------------------------------------------------------------------------------------- Vertex
		
		/**
		 * @param	mode	 POINTS, LINES, TRIANGLES, TRIANGLE_FAN, TRIANGLE_STRIP, QUADS, QUAD_STRIP
		 */
		override public function beginShape( mode:int=0 ):void
		{
			_vertex_mode   = mode;
			verticesX      = [];
			verticesY      = [];
			verticesZ      = [];
			splineVerticesX = [];
			splineVerticesY = [];
			splineVerticesZ = [];
			verticesU      = [];
			verticesV      = [];
			
			vertexCount = 0;
			splineVertexCount = 0;
			
			if ( __texture )
			{
				__texture = false;
				gc3d.endTexture();
			}
			if ( _vertex_mode_polygon = (mode == 0) )
			{
				gc3d.applyFill();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function endShape( close_path:Boolean=false ):void
		{
			if ( _vertex_mode_polygon )
			{
				if ( close_path )
					gc3d.closePath();
				gc3d.endFill();
				_vertex_mode_polygon = false;
			}
			if ( __texture )
			{
				__texture = false;
				gc3d.endTexture();
			}
			vertexCount       = 0;
			splineVertexCount = 0;
			_vertex_mode       = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function texture(textureData:BitmapData):void 
		{
			if ( _tint_do )
				gc3d.beginTexture( tintImageCache.getTintImage( textureData, _tint_color ) );
			else
				gc3d.beginTexture( textureData );
			__texture = true;
			_texture_width  = textureData.width;
			_texture_height = textureData.height;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function vertex(x:Number, y:Number, u:Number=0, v:Number=0 ):void
		{
			vertex3d( x, y, 0, u, v );
		}
		public function vertex3d( x:Number, y:Number, z:Number, u:Number=0, v:Number=0  ):void
		{
			var xx:Number = getX( x, y, z );
			var yy:Number = getY( x, y, z );
			var zz:Number = getZ( x, y, z );
			verticesX[vertexCount] = xx;
			verticesY[vertexCount] = yy;
			verticesZ[vertexCount] = zz;
			if ( _texture_mode < 1 )
			{
				u /= _texture_width;
				v /= _texture_height;
			}
			verticesU[vertexCount] = u;
			verticesV[vertexCount] = v;
			vertexCount++;
			
			var t1:uint;
			var t2:uint;
			var t3:uint;
			
			switch( _vertex_mode )
			{
				case POINTS:
					gc3d.point3d( xx, yy, zz );
					break;
				case LINES:
					if ( vertexCount % 2 == 0 )
					{
						t1 = vertexCount - 2;
						gc3d.moveTo3d( verticesX[t1], verticesY[t1], verticesZ[t1] );
						gc3d.lineTo3d( xx, yy, zz );
					}
					break;
				case TRIANGLES:
					if ( vertexCount % 3 == 0 )
					{
						t1 = vertexCount - 2;
						t2 = vertexCount - 3;
						if ( __texture )
						{
							gc3d.polygon( verticesX[t2], verticesY[t2], verticesZ[t2], 
										  verticesX[t1], verticesY[t1], verticesZ[t1],
										  xx, yy, zz,
										  verticesU[t2], verticesV[t2],
										  verticesU[t1], verticesV[t1],
										  u, v );
						}
						else
						{
							gc3d.applyFill();
							gc3d.polygonSolid( verticesX[t2], verticesY[t2], verticesZ[t2],
											   verticesX[t1], verticesY[t1], verticesZ[t1],
											   xx, yy, zz );
							gc3d.endFill();
						}
					}
					break;
				case TRIANGLE_FAN:
					if ( vertexCount >= 3 )
					{
						t1 = vertexCount - 2;
						if ( __texture )
						{
							gc3d.polygon( verticesX[0], verticesY[0], verticesZ[0], 
										  verticesX[t1], verticesY[t1], verticesZ[t1],
										  xx, yy, zz,
										  verticesU[0], verticesV[0],
										  verticesU[t1], verticesV[t1],
										  u, v );
						}
						else
						{
							gc3d.applyFill();
							gc3d.polygonSolid( verticesX[0], verticesY[0], verticesZ[0],
											   verticesX[t1], verticesY[t1], verticesZ[t1],
											   xx, yy, zz );
							gc3d.endFill();
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
						if ( __texture )
						{
							gc3d.polygon( verticesX[t2], verticesY[t2], verticesZ[t2], 
										  xx, yy, zz,
										  verticesX[t1], verticesY[t1], verticesZ[t1],
										  verticesU[t2], verticesV[t2],
										  u, v,
										  verticesU[t1], verticesV[t1]);
						}
						else
						{
							gc3d.applyFill();
							gc3d.polygonSolid( verticesX[t2], verticesY[t2], verticesZ[t2],
											   xx, yy, zz,
											   verticesX[t1], verticesY[t1], verticesZ[t1] );
							gc3d.endFill();
						}
					}
					break;
				case QUADS:
					if ( vertexCount % 4 == 0 )
					{
						t1 = vertexCount - 2;
						t2 = vertexCount - 3;
						t3 = vertexCount - 4;
						if ( __texture )
						{
							__vertexBitmapQuad3d( verticesX[t3], verticesY[t3], verticesZ[t3], 
												  verticesX[t2], verticesY[t2], verticesZ[t2],
												  verticesX[t1], verticesY[t1], verticesZ[t1],
												  xx, yy, zz,
												  verticesU[t3], verticesV[t3],
												  verticesU[t2], verticesV[t2],
												  verticesU[t1], verticesV[t1],
												  u, v );
						}
						else
						{
							__vertexQuad3d( verticesX[t3], verticesY[t3], verticesZ[t3],
											verticesX[t2], verticesY[t2], verticesZ[t2],
											verticesX[t1], verticesY[t1], verticesZ[t1],
											xx, yy, zz );
						}
					}
					break;
				case QUAD_STRIP:
					if ( vertexCount >= 4 && vertexCount % 2 == 0 )
					{
						t1 = vertexCount - 2;
						t2 = vertexCount - 3;
						t3 = vertexCount - 4;
						if ( __texture )
						{
							__vertexBitmapQuad3d( verticesX[t3], verticesY[t3], verticesZ[t3], 
												  verticesX[t2], verticesY[t2], verticesZ[t2],
												  xx, yy, zz,
												  verticesX[t1], verticesY[t1], verticesZ[t1],
												  verticesU[t3], verticesV[t3],
												  verticesU[t2], verticesV[t2],
												  u, v,
												  verticesU[t1], verticesV[t1] );
						}
						else
						{
							__vertexQuad3d( verticesX[t3], verticesY[t3], verticesZ[t3],
											verticesX[t2], verticesY[t2], verticesZ[t2],
											xx, yy, zz,
											verticesX[t1], verticesY[t1], verticesZ[t1] );
						}
					}
					break;
				default:
					if ( vertexCount == 1 && splineVertexCount < 4 )
						gc3d.moveTo3d( xx, yy, zz );
					else
						gc3d.lineTo3d( xx, yy, zz ); 
					break;
			}
			splineVertexCount = 0;
		}
		
		private function __vertexBitmapQuad3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number, x3:Number, y3:Number, z3:Number,
											   u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number, u3:Number, v3:Number ):void
		{
			gc3d.abortStroke();
			gc3d.image( x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3, u0, v0, u1, v1, u2, v2, u3, v3 );
			if ( gc3d.resumeStroke() )
			{
				gc3d.moveTo3d( x0, y0, z0 );
				gc3d.lineTo3d( x1, y1, z1 );
				gc3d.lineTo3d( x2, y2, z2 );
				gc3d.lineTo3d( x3, y3, z3 );
				gc3d.closePath();
			}
		}
		private function __vertexQuad3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number, x3:Number, y3:Number, z3:Number ):void
		{
			gc3d.applyFill();
			gc3d.moveTo3d( x0, y0, z0 );
			gc3d.lineTo3d( x1, y1, z1 );
			gc3d.lineTo3d( x2, y2, z2 );
			gc3d.lineTo3d( x3, y3, z3 );
			gc3d.closePath();
			gc3d.endFill();
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
			if ( _vertex_mode_polygon )
			{
				var xx:Number = getX( x, y, z );
				var yy:Number = getY( x, y, z );
				var zz:Number = getZ( x, y, z );
				verticesX[vertexCount] = xx;
				verticesY[vertexCount] = yy;
				verticesZ[vertexCount] = zz;
				vertexCount++;
				splineVertexCount = 0;
				gc3d.bezierTo3d( getX( cx0, cy0, cz0 ), getY( cx0, cy0, cz0 ), getZ( cx0, cy0, cz0 ),
								 getX( cx1, cy1, cz1 ), getY( cx1, cy1, cz1 ), getZ( cx1, cy1, cz1 ),
								 xx, yy, zz );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function curveVertex(x:Number, y:Number):void
		{
			curveVertex3d( x, y, 0 );
		}
		public function curveVertex3d( x:Number, y:Number, z:Number ):void
		{
			if ( _vertex_mode_polygon )
			{
				var xx:Number = getX( x, y, z );
				var yy:Number = getY( x, y, z );
				var zz:Number = getZ( x, y, z );
				splineVerticesX[splineVertexCount]= xx;
				splineVerticesY[splineVertexCount]= yy;
				splineVerticesZ[splineVertexCount]= zz;
				splineVertexCount++;
				
				var t1:int = splineVertexCount - 2;
				var t3:int = splineVertexCount - 4;
				
				if( splineVertexCount>4 )
				{
					gc3d.splineTo3d( splineVerticesX[t3], splineVerticesY[t3], splineVerticesZ[t3],
									 xx, yy, zz,
									 splineVerticesX[t1], splineVerticesY[t1], splineVerticesZ[t1] );
				}
				else if ( splineVertexCount == 4 )
				{
					if ( !(vertexCount > 0) )
					{
						var t2:int = splineVertexCount - 3;
						gc3d.moveTo3d(splineVerticesX[t2], splineVerticesY[t2], splineVerticesZ[t2]);
					}
					gc3d.splineTo3d( splineVerticesX[t3], splineVerticesY[t3], splineVerticesZ[t3],
									 xx, yy, zz,
									 splineVerticesX[t1], splineVerticesY[t1], splineVerticesZ[t1] );
				}
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// Shape
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 */
		override public function shape( s:IFShape, x:Number=NaN, y:Number=NaN, w:Number = NaN, h:Number = NaN ):void
		{
			gc3d.pathGroupStart();
			if ( !isNaN(x * y) )
			{
				pushMatrix();
				if ( w>0 && h>0 )
				{
					if( _shape_mode==CENTER )
					{
						x -= w * 0.5;
						y -= h * 0.5;
					}
					else if ( _shape_mode == CORNERS )
					{
						w -= x;
						h -= y;
					}
					translate( x, y );
					scale( w / s.width, h / s.height );
				}
				else if( _shape_mode==CENTER )
				{
					x -= s.width * 0.5;
					y -= s.height * 0.5;
					translate( x, y );
				}
				else
				{
					translate( x, y );
				}
				translate( -s.left, -s.top );
				s.draw(this);
				popMatrix();
			}
			else
			{
				s.draw(this);
			}
			gc3d.pathGroupEnd();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// IMAGE
		//-------------------------------------------------------------------------------------------------------------------
		
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
		public function image2d( img:BitmapData, x:Number, y:Number, z:Number, w:Number = NaN, h:Number = NaN ):void
		{
			var center_:Boolean = false;
			if ( isNaN(w) || isNaN(h) )
			{
				if( _image_mode==RADIUS || _image_mode==CENTER )
					center_ = true;
				w = img.width;
				h = img.height;
			}
			else
			{
				switch( _image_mode )
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
				gc3d.beginTexture( tintImageCache.getTintImage( img, _tint_color ) );
			else
				gc3d.beginTexture( img );
			
			gc3d.bitmap( getX( x, y, z ), getY( x, y, z ), getZ( x, y, z ), w, h, center_ );
			gc3d.endTexture();
		}
		
		/**
		 * 画像を描画します.
		 */
		public function image3d( img:BitmapData, x:Number, y:Number, z:Number, w:Number = NaN, h:Number = NaN ):void
		{
			if ( isNaN(w) || isNaN(h) )
			{
				w = img.width;
				h = img.height;
			}
			switch( _image_mode )
			{
				case CORNERS:
					w  -= x;
					h  -= y;
					break;
				case RADIUS:
					x -= w;
					y -= h;
					w *= 2;
					h *= 2;
					break;
				case CENTER:
					x -= w*0.5;
					y -= h*0.5;
					break;
			}
			_image( img, x, y, w, h, z );
		}
		
		/**
		 * @private
		 */
		override f5internal function _image(img:BitmapData, x1:Number, y1:Number, w:Number, h:Number, z:Number=0):void 
		{
			if ( _tint_do )
				gc3d.beginTexture( tintImageCache.getTintImage( img, _tint_color ) );
			else
				gc3d.beginTexture( img );
			
			var x2:Number = x1 + w;
			var y2:Number = y1 + h;
			gc3d.image( getX( x1, y1, z ), getY( x1, y1, z ), getZ( x1, y1, z ),
					     getX( x2, y1, z ), getY( x2, y1, z ), getZ( x2, y1, z ),
					     getX( x2, y2, z ), getY( x2, y2, z ), getZ( x2, y2, z ),
					     getX( x1, y2, z ), getY( x1, y2, z ), getZ( x1, y2, z ),
					     0, 0, 1, 0, 1, 1, 0, 1 );
			gc3d.endTexture();
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// STYLE
		//-------------------------------------------------------------------------------------------------------------------
		
		public function get backFaceCulling():Boolean { return gc3d.backFaceCulling; }
		public function set backFaceCulling( value_:Boolean ):void{
			gc3d.backFaceCulling = value_;
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		// 
		//-------------------------------------------------------------------------------------------------------------------
		
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
			gc3d.applyFill();
			gc3d.drawTriangles( vtx, indices );
			gc3d.endFill();
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
			gc3d.beginTexture( bitmapdata );
			gc3d.drawTriangles( vtx, indices, uvData );
			gc3d.endTexture();
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
			gc3d.beginTexture( bitmapdata );
			gc3d.drawMesh( vtx, indices, uvData );
			gc3d.endTexture();
		}
		
		/*
		override public function drawBitmapRect( bitmapdata:BitmapData, x:Number, y:Number, w:Number, h:Number ):void
		{
			drawBitmapQuad( bitmapdata, x, y, x + w, y, x + w, y + h, x, y + h );
		}
		
		override public function drawBitmapTriangle( bitmapdata:BitmapData,
											x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number,
											u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number ):void
		{
			gc3d.beginTexture( bitmapdata );
			gc3d.polygon( getX( x0, y0, 0 ), getY( x0, y0, 0 ), getZ( x0, y0, 0 ),
						  getX( x1, y1, 0 ), getY( x1, y1, 0 ), getZ( x1, y1, 0 ),
						  getX( x2, y2, 0 ), getY( x2, y2, 0 ), getZ( x2, y2, 0 ),
						  u0, v0, u1, v1, u2, v2 );
			gc3d.endTexture();
		}
		
		override public function drawBitmapQuad( bitmapdata:BitmapData,
										x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number,
										u0:Number=0, v0:Number=0, u1:Number=1, v1:Number=0, u2:Number=1, v2:Number=1, u3:Number=0, v3:Number=1 ):void
		{
			gc3d.beginTexture( bitmapdata );
			gc3d.image( getX( x0, y0, 0 ), getY( x0, y0, 0 ), getZ( x0, y0, 0 ),
						getX( x1, y1, 0 ), getY( x1, y1, 0 ), getZ( x1, y1, 0 ),
						getX( x2, y2, 0 ), getY( x2, y2, 0 ), getZ( x2, y2, 0 ),
						getX( x3, y3, 0 ), getY( x3, y3, 0 ), getZ( x3, y3, 0 ),
						u0, v0, u1, v1, u2, v2, u3, v3 );
			gc3d.endTexture();
		}
		*/
		
		//-------------------------------------------------------------------------------------------------------------------
		// GRAPHICS
		//-------------------------------------------------------------------------------------------------------------------
		
		/**
		 * not implemented.
		 */
		override public function lineGradientStyle( type:String,colors:Array,alphas:Array,ratios:Array,matrix:Matrix=null,spreadMethod:String="pad",interpolationMethod:String="rgb",focalPointRatio:Number=0.0):void
		{
			;
		}
		
		/**
		 * @private
		 */
		override protected function update_fill_matrix():Boolean
		{
			if ( transformFillMatrix ) {
				var x0:Number = getX( 0, 0, 0 );
				var y0:Number = getY( 0, 0, 0 );
				var x1:Number = getX( 1, 0, 0 );
				var y1:Number = getY( 1, 0, 0 );
				var x2:Number = getX( 0, 1, 0 );
				var y2:Number = getY( 0, 1, 0 );
				if ( pers_projection )
				{
					var znear:Number = _cameraObject.zNear;
					var z0:Number = znear/getZ( 0, 0, 0 );
					var z1:Number = znear/getZ( 1, 0, 0 );
					var z2:Number = znear/getZ( 0, 1, 0 );
					x0 *= z0;
					y0 *= z0;
					x1 *= z1;
					y1 *= z1;
					x2 *= z2;
					y2 *= z2;
				}
				_fill_matrix.setMatrix( x1-x0, y1-y0, x2-x0, y2-y0, x0+half_width, y0+half_height );
				return true;
			}else {
				return false;
			}
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