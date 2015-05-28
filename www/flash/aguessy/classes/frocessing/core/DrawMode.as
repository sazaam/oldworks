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
	
	/**
	* DrawMode クラスは、F5Graphics クラス beginShape() メソッドの mode パラメータの値を提供します.
	* 
	* @author nutsu
	* @version 0.1.2
	* 
	* @see frocessing.core.F5Graphics#beginShape
	*/
	public class DrawMode {
		
		public static const NONE_SHAPE    :int = 0;
		
		public static const POINTS        :int = 10;
		public static const LINES         :int = 20;
		public static const TRIANGLES     :int = 30;
		public static const TRIANGLE_STRIP:int = 31;
		public static const TRIANGLE_FAN  :int = 32;
		public static const QUADS         :int = 40;
		public static const QUAD_STRIP    :int = 41;
		public static const POLYGON       :int = 99;
	}
	
}