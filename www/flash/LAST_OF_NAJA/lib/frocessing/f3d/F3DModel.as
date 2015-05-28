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

package frocessing.f3d 
{
	import frocessing.core.GraphicsEx3D;
	import frocessing.f3d.materials.F3DColorMaterial;
	import frocessing.f3d.materials.IF3DMaterial;
	import frocessing.f3d.materials.F3DEmptyMaterial;
	import frocessing.f3d.materials.F3DBmpMaterial;
	import frocessing.geom.FMatrix3D;
	import frocessing.geom.FNumber3D;
	import flash.display.BitmapData;
	
	/**
	* Abstract 3D Model Data Class (Test).
	* 
	* @author nutsu
	* @version 0.3.1
	* 
	*/
	public class F3DModel extends F3DObject
	{
		private var _name:String;
		
		//original vertex : FNumber3D[]
		public var vertices:Array;
		
		//transformed vertex : Number[]
		public var $vertices:Array;
		
		//indexes of polygon vertex :uint[]
		public var faces:Array;
		
		//uv of each faces : Number[]
		public var uv:Array;
		
		//set of face and uv
		public var faceSet:Array;
		public var uvSet:Array;
		
		//material
		/**
		 * @private
		 */
		protected var _material:IF3DMaterial;
		
		/**
		 * 
		 * @param	vertices_
		 * @param	faces_
		 * @param	uv_
		 * @param	defaultMatrix_
		 */
		public function F3DModel( defaultMatrix:FMatrix3D = null ) 
		{
			super(defaultMatrix);
			
			vertices     = [];
			$vertices    = [];
			faces        = [];
			uv           = [];
			faceSet      = [];
			uvSet        = [];
			_material    = new F3DEmptyMaterial();
		}
		
		public function get faceSetNum():uint
		{
			return faceSet.length;
		}
		
		/**
		 * face, uv は共有でコピー
		 */
		public function copy():F3DModel
		{
			var fm:F3DModel = new F3DModel(matrix);
			fm.setMesh( vertices.concat(), faces, uv, faceSet, uvSet );
			fm.material = material;
			return fm;
		}
		
		/**
		 * 
		 * @param	vertices_
		 * @param	faces_
		 * @param	uv_
		 * @param	faceSet_
		 * @param	uvSet_
		 */
		public function setMesh( vertices_:Array, faces_:Array, uv_:Array=null, faceSet_:Array=null, uvSet_:Array=null ):void
		{
			vertices  = vertices_;
			faces     = faces_;
			uv        = ( uv_ ) ? uv_ : [];
			faceSet   = ( faceSet_ ) ? faceSet_ : faces;
			uvSet     = ( uvSet_ ) ? uvSet_ : uv;
			updateTransform( 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0 );
		}
		
		//--------------------------------------------------------------------------------------------------- Basic Material
		
		public function get material():IF3DMaterial { return _material; }
		public function set material(value:IF3DMaterial):void 
		{
			if ( value == null )
				_material = new F3DEmptyMaterial();
			else
				_material = value;
		}
		
		/**
		 * 
		 * @param	color
		 * @param	alpha
		 */
		public function setColor( color:uint, alpha:Number = 1.0 ):void
		{
			_material = new F3DColorMaterial( color, alpha );
		}
		
		/**
		 * 
		 * @param	texture_
		 * @param	texture_back_
		 */
		public function setTexture( texture:BitmapData, backTexture:BitmapData=null ):void
		{
			_material = new F3DBmpMaterial( texture, backTexture );
		}
		
		/**
		 * 
		 */
		public function noMaterial():void
		{
			_material = new F3DEmptyMaterial();
		}
		
		//--------------------------------------------------------------------------------------------------- Override F3DObject
		
		/**
		 * 
		 * @param	g
		 * @param	fillcolor
		 * @param	fillalpha
		 */
		override public function draw( g:GraphicsEx3D ):void
		{
			_material.draw( g, this );
		}
		
		/**
		 * 
		 * @param	mtx
		 */
		override public function updateTransform( m11_:Number, m12_:Number, m13_:Number,
												  m21_:Number, m22_:Number, m23_:Number,
												  m31_:Number, m32_:Number, m33_:Number,
												  m41_:Number, m42_:Number, m43_:Number ):void
		{
			super.updateTransform( m11_, m12_, m13_, m21_, m22_, m23_, m31_, m32_, m33_, m41_, m42_, m43_ );
			
			var len:int = vertices.length;
			var vt:FNumber3D;
			var c:int = 0;
			for ( var i:int = 0; i < len; i ++ )
			{
				vt = vertices[i];
				$vertices[c] = vt.x * m11 + vt.y * m21 + vt.z * m31 + m41;  c++;
				$vertices[c] = vt.x * m12 + vt.y * m22 + vt.z * m32 + m42;  c++;
				$vertices[c] = vt.x * m13 + vt.y * m23 + vt.z * m33 + m43;  c++;
			}
		}		
	}
	
}