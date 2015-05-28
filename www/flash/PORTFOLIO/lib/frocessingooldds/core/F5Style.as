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
	import frocessing.text.IFont;
	
	/**
	 * F5Graphics Styles
	 * 
	 * @author nutsu
	 * @version 0.5.8
	 */
	public class F5Style 
	{
		// Color Mode
		public var colorMode:String;
		public var colorModeX:Number;
		public var colorModeY:Number;
		public var colorModeZ:Number;
		public var colorModeA:Number;
		
		// Fill
		public var fillDo:Boolean;
		public var fillColor:uint;
		public var fillAlpha:Number;
		
		// Stroke
		public var strokeDo:Boolean;
		public var strokeColor:uint;
		public var strokeAlpha:Number;
		public var thickness:Number;
		public var pixelHinting:Boolean;
		public var scaleMode:String;
		public var caps:String;
		public var joints:String;
		public var miterLimit:Number;
		
		// Shape parameter mode
		public var rectMode:int;
		public var ellipseMode:int;
		public var imageMode:int;
		public var shapeMode:int;
		
		// Tint
		public var tintDo:Boolean;
		public var tintColor:uint;
		
		// Text
		public var textFont:IFont;
		public var textAlign:int;
		public var textAlignY:int;
		public var textSize:Number;
		public var textLeading:Number;
		
		/*
			included in the style:
			fill(), stroke(), tint(), strokeWeight(), strokeCap(), strokeJoin(),
			imageMode(), rectMode(), ellipseMode(), shapeMode(), colorMode(),
			textAlign(), textMode(), textSize(), textLeading(), 
			emissive(), specular(), shininess(), ambient()
		*/
		
		public function F5Style()
		{
			;
		}
		
	}
	
}