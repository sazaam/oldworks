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

package frocessing.shape 
{
	import flash.display.Graphics;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.InterpolationMethod;
	import flash.geom.Matrix;
	import frocessing.geom.FGradientMatrix;
	import frocessing.graphics.FGradientFill;
	import frocessing.core.F5Graphics;
	
	/**
	* Shape Gradient Object
	* 
	* @author nutsu
	* @version 0.5.3
	*/
	public class FShapeGradient extends FGradientFill
	{
		public var name:String = "";
		public var isNormal:Boolean = false;
		
		public function FShapeGradient(type:String="linear", colors:Array=null, alphas:Array=null, ratios:Array=null,
								       matrix:FGradientMatrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb",
								       focalPointRatio:Number=0.0) 
		{
			if ( colors == null ) colors = [0, 0xffffff];
			if ( alphas == null ) alphas = [1,1];
			if ( ratios == null ) ratios = [0,0xff];
			if ( matrix == null ) matrix = new FGradientMatrix();
			super( type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio );
		}
		
		/**
		 * return matrix, depending on gradientUnits.
		 * @private
		 */
		protected function _gradientMatrix( target:IFShape ):Matrix
		{
			if ( !isNormal || target==null || matrix==null )
			{
				//gradientUnits:userSpaceOnUse
				return matrix;
			}
			else
			{
				//gradientUnits:objectBoundingBox
				return matrix.map( target.left, target.top, target.width, target.height );
			}
		}
		
		/**
		 * @private
		 */
		internal function applyFill( fg:F5Graphics, targetObject:IFShape = null ):void
		{
			fg.beginGradientFill( gradType, colors, alphas, ratios, _gradientMatrix(targetObject),
								  spreadMethod, interpolationMethod, focalPointRatio );
		}
		
		/**
		 * @private
		 */
		internal function applyStroke( fg:F5Graphics, targetObject:IFShape = null ):void
		{
			fg.lineGradientStyle( gradType, colors, alphas, ratios, _gradientMatrix(targetObject),
								  spreadMethod, interpolationMethod, focalPointRatio );
		}
		
		/**
		 * @private
		 */
		internal function applyFillToGraphics( gc:Graphics, targetObject:IFShape = null ):void
		{
			gc.beginGradientFill( gradType, colors, alphas, ratios, _gradientMatrix(targetObject),
								  spreadMethod, interpolationMethod, focalPointRatio );
		}
		
		/**
		 * @private
		 */
		internal function applyStrokeToGraphics( gc:Graphics, targetObject:IFShape = null ):void
		{
			gc.lineGradientStyle( gradType, colors, alphas, ratios, _gradientMatrix(targetObject),
								  spreadMethod, interpolationMethod, focalPointRatio );
		}
	}
	
}