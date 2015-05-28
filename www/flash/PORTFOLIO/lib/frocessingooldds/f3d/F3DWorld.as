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
	import flash.display.Sprite;
	import frocessing.core.GraphicsEx3D;
	import frocessing.geom.FMatrix3D;
	
	/**
	* ...
	* @author nutsu
	*/
	public class F3DWorld extends Sprite
	{
		//Camera & Projection
		public var camera:F3DCamera;
		
		//3D Object Container
		public var container:F3DGroup;
		
		//Renderer
		private var __gc:GraphicsEx3D;
		
		public function F3DWorld( screenWidth:Number, screenHeight:Number ) 
		{
			__gc       = new GraphicsEx3D( graphics );
			
			container = new F3DGroup();
			camera    = new F3DCamera( screenWidth, screenHeight );
			
			container.x = __gc.centerX = screenWidth * 0.5;
			container.y = __gc.centerY = screenHeight * 0.5;
		}
		
		public function setScreenSize( screenWidth:Number, screenHeight:Number ):void
		{
			camera.setScreenSize( screenWidth, screenHeight );
			container.x = __gc.centerX = screenWidth * 0.5;
			container.y = __gc.centerY = screenHeight * 0.5;
		}
		
		public function draw():void
		{
			var m:FMatrix3D = camera.matrix;
			container.updateTransform( m.m11, m.m12, m.m13, m.m21, m.m22, m.m23, m.m31, m.m32, m.m33, m.m41, m.m42, m.m43 );
			__gc.zNear = camera.zNear;
			__gc.clear();
			__gc.beginDraw( camera.isPerspective );
			container.draw( __gc );
			__gc.endDraw();
		}		
	}
	
}