﻿// --------------------------------------------------------------------------
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

package frocessing.f3d.materials 
{
	import frocessing.f3d.F3DGraphics;
	import frocessing.f3d.F3DModel;
	import flash.display.BitmapData;
	
	/**
	* 3D Material BitmapData Set
	* 
	* @author nutsu
	* @version 0.3
	*/
	public class F3DBmpSetMaterial extends F3DEmptyMaterial
	{
		//BitmapData[]
		public var textures:Array;
		//BitmapData[]
		public var backTextures:Array;
		//Boolean[]
		public var visibles:Array;
		//Boolean[]
		public var backFaces:Array;
		
		/**
		 * 
		 */
		public function F3DBmpSetMaterial( ...textures_ ) 
		{
			super();
			textures     = [];
			backTextures = [];
			visibles     = [];
			backFaces    = [];
			for ( var i:int = 0; i < textures_.length ; i++ )
			{
				setTexture( i, textures_[i] );
			}
		}
		
		/**
		 * 
		 */
		override public function set backFace( value:Boolean ):void
		{
			_backface = value;
			for ( var i:int = 0; i < backFaces.length; i++ )
				backFaces[i] = _backface;
		}
		
		/**
		 * 
		 * @param	index
		 * @param	color
		 * @param	alpha
		 */
		public function setTexture( index:uint, texture_:BitmapData, backTexture_:BitmapData = null, visible_:Boolean = true, backface_:Boolean = false ):void
		{
			textures[index]     = texture_;
			backTextures[index] = backTexture_;
			visibles[index]     = visible_;
			backFaces[index]    = backface_;
		}
		
		/**
		 * draw model
		 * @param	g
		 */
		override public function draw( g:F3DGraphics, model:F3DModel ):void
		{
			if ( _visible )
			{
				var n:uint = model.faceSetNum;
				for ( var i:int = 0; i < n; i++ )
				{
					if ( visibles[i] )
					{
						g.backFaceCulling = !backFaces[i];
						g.beginTexture( textures[i], backTextures[i] );
						g.drawMesh( model.vertices, model.faceSet[i], model.uvSet[i] );
						g.endTexture();
					}
				}
			}
		}
	}
	
}