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

package frocessing.display {
	
	import flash.display.Shape;
	import flash.display.BitmapData;
	import frocessing.f3d.*;
	import frocessing.f3d.models.*;
	import frocessing.f3d.materials.*;
	import frocessing.geom.FNumber3D;
	
	import frocessing.FC;
	import frocessing.core.F5Graphics3D;
	
	/**
	* F5MovieClip3D
	* 
	* @author nutsu
	* @version 0.3
	*/
	public dynamic class F5MovieClip3D extends F5MovieClip{
		
		public var fg:F5Graphics3D;
		
		/**
		 * 
		 */
		public function F5MovieClip3D() {
			super();
		}
		
		/**
		 * 
		 */
		override protected function init():void
		{
			draw_shape = new Shape();
			fg  = new F5Graphics3D( draw_shape.graphics, 100, 100 );
			_fg = fg;
			addChild( draw_shape );
		}
		
		public function noBackground():void {
			fg.noBackground();
		}
		
		//--------------------------------------------------------------------------------------------------- 
		
		// Transform
		
		public function translate( x_:Number, y_:Number, z_:Number=0.0 ):void{
			fg.translate( x_, y_, z_ );
		}
		public function scale( x_:Number, y_:Number = NaN, z_:Number=1.0 ):void{
			fg.scale( x_, y_, z_ );
		}
		public function rotate( angle:Number ):void{
			fg.rotate( angle );
		}
		public function rotateX( angle:Number ):void{
			fg.rotateX( angle );
		}
		public function rotateY( angle:Number ):void{
			fg.rotateY( angle );
		}
		public function rotateZ( angle:Number ):void{
			fg.rotateZ( angle );
		}
		public function pushMatrix():void{
			fg.pushMatrix();
		}
		public function popMatrix():void{
			fg.popMatrix();
		}
		public function resetMatrix():void{
			fg.resetMatrix();
		}
		public function printMatrix():void {
			fg.printMatrix();
		}
		
		public function screenXYZ( x:Number, y:Number, z:Number ):FNumber3D{
			return fg.screenXYZ( x, y, z );
		}
		
		public function screenX( x:Number, y:Number, z:Number ):Number{
			return fg.screenX( x, y, z );
		}
		public function screenY( x:Number, y:Number, z:Number ):Number{
			return fg.screenY( x, y, z );
		}
		public function screenZ( x:Number, y:Number, z:Number ):Number{
			return fg.screenZ( x, y, z );
		}
		
		public function modelXYZ( x:Number, y:Number, z:Number ):FNumber3D{
			return fg.modelXYZ( x, y, z );
		}
		public function modelX( x:Number, y:Number, z:Number ):Number{
			return fg.modelX( x, y, z );
		}
		public function modelY( x:Number, y:Number, z:Number ):Number{
			return fg.modelY( x, y, z );
		}
		public function modelZ( x:Number, y:Number, z:Number ):Number{
			return fg.modelZ( x, y, z );
		}
		
		//--------------------------------------------------------------------------------------------------- 
		
		// Camera & Projection
		
		public function perspective( fov:Number=NaN, aspect:Number=NaN, zNear:Number=NaN, zFar:Number=NaN ):void{
			fg.perspective( fov, aspect, zNear, zFar );
		}
		public function frustum(left:Number, right:Number, bottom:Number, top:Number, zNear:Number, zFar:Number):void{
			fg.frustum(left, right, bottom, top, zNear, zFar);
		}
		public function ortho(left:Number=NaN, right:Number=NaN, bottom:Number=NaN, top:Number=NaN, zNear:Number=NaN, zFar:Number=NaN):void{
			fg.ortho(left, right, bottom, top, zNear, zFar);
		}
		public function printProjection():void{
			fg.printProjection();
		}
		
		public function camera( eyeX:Number = NaN, eyeY:Number = NaN, eyeZ:Number = NaN, centerX:Number = NaN, centerY:Number = NaN, centerZ:Number = NaN, upX:Number = 0, upY:Number = 1, upZ:Number = 0 ):void{
			fg.camera( eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ );
		}
		public function beginCamera():void{
			fg.beginCamera();
		}
		public function translateCamera( x:Number, y:Number, z:Number=0.0 ):void{
			fg.translateCamera( x, y, z );
		}
		public function rotateXCamera( angle:Number ):void{
			fg.rotateXCamera( angle );
		}
		public function rotateYCamera( angle:Number ):void{
			fg.rotateYCamera( angle );
		}
		public function rotateZCamera( angle:Number ):void{
			fg.rotateZCamera( angle );
		}
		public function endCamera():void{
			fg.endCamera();
		}
		public function printCamera():void{
			fg.printCamera();
		}
		
		//--------------------------------------------------------------------------------------------------- 
		
		// 3D Primitive
		
		public function box( w:Number, h:Number = NaN , d:Number = NaN ):void {
			fg.box( w, h, d );
		}
		public function sphereDetail( detail:uint ):void {
			fg.sphereDetail( detail );
		}
		public function sphere( radius:Number ):void {
			fg.sphere( radius );
		}
		
		// 3D Object
		public function model( model_:F3DObject ):void{
			fg.model( model_ );
		}
		
		//--------------------------------------------------------------------------------------------------- 
		
		public function moveTo3d( x:Number, y:Number, z:Number ):void {
			fg.moveTo3d( x, y, z );
		}
		public function lineTo3d( x:Number, y:Number, z:Number ):void {
			fg.lineTo3d( x, y, z );
		}
		public function curveTo3d( cx:Number, cy:Number, cz:Number, x:Number, y:Number, z:Number ):void {
			fg.curveTo3d( cx, cy, cz, x, y, z );
		}
		
		public function point3d( x:Number, y:Number, z:Number ):void{
			fg.point3d( x, y, z );
		}
		public function line3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number ):void{
			fg.line3d( x0, y0, z0, x1, y1, z1 );
		}
		public function bezier3d( x0:Number, y0:Number, z0:Number, cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x1:Number, y1:Number, z1:Number ):void{
			fg.bezier3d( x0, y0, z0, cx0, cy0, cz0, cx1, cy1, cz1, x1, y1, z1 );
		}
		public function curve3d( x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number, x3:Number, y3:Number, z3:Number ):void{
			fg.curve3d( x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3 );
		}
		public function vertex3d( x:Number, y:Number, z:Number, u:Number=0, v:Number=0 ):void {
			fg.vertex3d( x, y, z, u, v );
		}
		public function bezierVertex3d( cx0:Number, cy0:Number, cz0:Number, cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void {
			fg.bezierVertex3d( cx0, cy0, cz0, cx1, cy1, cz1, x, y, z );
		}
		public function curveVertex3d( x:Number, y:Number, z:Number ):void {
			fg.curveVertex3d( x, y, z );
		}
		
		public function rlineTo3d( x:Number, y:Number, z:Number ):void {
			fg.rlineTo3d( x, y, z );
		}
		public function scurveTo3d( x:Number, y:Number, z:Number ):void {
			fg.scurveTo3d( x, y, z );
		}
		public function sbezierTo3d( cx1:Number, cy1:Number, cz1:Number, x:Number, y:Number, z:Number ):void {
			fg.sbezierTo3d( cx1, cy1, cz1, x, y, z );
		}
		
		//--------------------------------------------------------------------------------------------------- 
		
		public function image3d( img:BitmapData, x:Number, y:Number, z:Number, w:Number = NaN, h:Number = NaN ):void {
			fg.image3d( img, x, y, z, w, h );
		}
		
	}
	
}