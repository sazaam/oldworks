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

package frocessing.f3d
{
	import frocessing.geom.FMatrix3D;
	
	/**
	* 3D Group
	* 
	* @author nutsu
	* @version 0.3
	* 
	*/
	public class F3DGroup extends F3DObject
	{
		private var _name:String;
		
		protected var childs:Array;
		protected var child_number:uint;
		
		/**
		 * 
		 * @param	defaultMatrix
		 */
		public function F3DGroup( defaultMatrix:FMatrix3D = null ) 
		{
			super(defaultMatrix);
			
			childs       = [];
			child_number = 0;
		}
		
		public function get childrenNum():uint { return child_number; }
		
		/**
		 * 
		 * @param	m
		 */
		public function addChild( f3dobj:F3DObject ):void
		{
			childs[child_number] = f3dobj;
			child_number++;
		}
		
		/**
		 * 
		 * @param	m
		 */
		public function removeChild( f3dobj:F3DObject ):void
		{
			var i:int = childs.indexOf( f3dobj );
			if ( i != -1 )
			{
				childs.splice( i, 1 );
				child_number--;
			}
		}
		
		/**
		 * 
		 */
		public function removeAllChilds():void
		{
			childs       = [];
			child_number = 0;
		}
		
		/**
		 * 
		 * @param	n
		 */
		public function getChildAt( i:uint ):F3DObject
		{
			if ( i < childs.length )
				return childs[i];
			else
				return null;
		}
		
		//--------------------------------------------------------------------------------------------------- Override F3DObject
		
		/**
		 * 
		 * @param	g
		 * @param	fillcolor
		 * @param	fillalpha
		 */
		override public function draw( g:F3DGraphics ):void
		{
			if ( child_number != 0 )
			{
				for ( var n:int=0 ; n < child_number; n++ )
				{
					F3DObject( childs[n] ).draw( g );
				}
			}
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
			
			if ( child_number != 0 )
			{
				for ( var n:int=0 ; n < child_number; n++ )
				{
					F3DObject( childs[n] ).updateTransform( m11, m12, m13, m21, m22, m23, m31, m32, m33, m41, m42, m43 );
				}
			}
		}
	}
	
}