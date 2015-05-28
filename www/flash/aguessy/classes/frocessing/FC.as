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

package frocessing {
	
	import flash.display.LineScaleMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.InterpolationMethod;
	
	import frocessing.color.ColorMode;
	import frocessing.core.DrawMode;
	import frocessing.core.DrawPosMode;
	import frocessing.core.PathCloseMode;
	
	/**
	* Constants
	* @author nutsu
	* @version 0.1
	*/
	public class FC {
		
		public static const LINE_SCALE_MODE_NONE           :String = LineScaleMode.NONE;
		public static const LINE_SCALE_MODE_NORMAL         :String = LineScaleMode.NORMAL;
		public static const LINE_SCALE_MODE_HORIZONTAL     :String = LineScaleMode.HORIZONTAL;
		public static const LINE_SCALE_MODE_VERTICAL       :String = LineScaleMode.VERTICAL;
		
		public static const CAPS_STYLE_NONE                :String = CapsStyle.NONE;
		public static const CAPS_STYLE_ROUND               :String = CapsStyle.ROUND;
		public static const CAPS_STYLE_SQUARE              :String = CapsStyle.SQUARE;
		
		public static const JOINT_STYLE_BEVEL              :String = JointStyle.BEVEL;
		public static const JOINT_STYLE_MITER              :String = JointStyle.MITER;
		public static const JOINT_STYLE_ROUND              :String = JointStyle.ROUND;
		
		public static const GRADIENT_TYPE_LINEAR           :String = GradientType.LINEAR;
		public static const GRADIENT_TYPE_RADIAL           :String = GradientType.RADIAL;
		
		public static const SPREAD_METHOD_PAD              :String = SpreadMethod.PAD;
		public static const SPREAD_METHOD_REFLECT          :String = SpreadMethod.REFLECT;
		public static const SPREAD_METHOD_REPEAT           :String = SpreadMethod.REPEAT;
		
		public static const INTERPOLATION_METHOD_LINEAR_RGB:String = InterpolationMethod.LINEAR_RGB;
		public static const INTERPOLATION_METHOD_RGB       :String = InterpolationMethod.RGB;
		
		public static const RGB        :String = ColorMode.RGB;
		public static const HSB        :String = ColorMode.HSB;
		public static const HSV        :String = ColorMode.HSV;
		
		public static const CORNER        :int = DrawPosMode.CORNER;
		public static const CORNERS       :int = DrawPosMode.CORNERS;
		public static const RADIUS        :int = DrawPosMode.RADIUS;
		public static const CENTER        :int = DrawPosMode.CENTER;
		
		public static const NONE_SHAPE    :int = DrawMode.NONE_SHAPE;
		public static const POINTS        :int = DrawMode.POINTS;
		public static const LINES         :int = DrawMode.LINES; 
		public static const TRIANGLES     :int = DrawMode.TRIANGLES;
		public static const TRIANGLE_FAN  :int = DrawMode.TRIANGLE_FAN;
		public static const TRIANGLE_STRIP:int = DrawMode.TRIANGLE_STRIP;
		public static const QUADS         :int = DrawMode.QUADS;
		public static const QUAD_STRIP    :int = DrawMode.QUAD_STRIP;
		public static const POLYGON       :int = DrawMode.POLYGON;
		
		public static const OPEN      :Boolean = PathCloseMode.OPEN;
		public static const CLOSE     :Boolean = PathCloseMode.CLOSE;
		
		public static const PI         :Number = Math.PI;
		public static const TWO_PI     :Number = Math.PI*2;
		public static const HALF_PI    :Number = Math.PI/2;
		public static const QUART_PI   :Number = Math.PI/4;
		
	}
	
}