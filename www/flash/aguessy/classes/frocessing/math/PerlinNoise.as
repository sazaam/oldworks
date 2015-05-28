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

package frocessing.math {
	
	/**
	* Perlin Noise を生成するメソッドを提供します.
	* 
	* @author nutsu
	* @version 0.1
	*/
	public class PerlinNoise {
		
		private static const PERLIN_YWRAPB :int = 4;
		private static const PERLIN_YWRAP  :int = 1<<PERLIN_YWRAPB;
		private static const PERLIN_ZWRAPB :int = 8;
		private static const PERLIN_ZWRAP  :int = 1<<PERLIN_ZWRAPB;
		private static const PERLIN_SIZE   :int = 4095;
		
		private var perlin_octaves :int = 4; // default to medium smooth
		private var perlin_amp_falloff:Number = 0.5; // 50% reduction/octave
		
		private var perlin:Array;	//Number[]
		
		//private Random perlinRandom;
		
		public function PerlinNoise() {
			random_init();
		}
		
		private function random_init():void
		{
			/*
			if (perlinRandom == null) {
				perlinRandom = new Random();
			}
			*/
			
			perlin = new Array(PERLIN_SIZE + 1);
			for ( var i:int=0; i < PERLIN_SIZE + 1; i++)
			{
				//perlin[i] = perlinRandom.nextFloat(); //(float)Math.random();
				perlin[i] = Math.random();
			}
		}
		
		/**
		 * Computes the Perlin noise function
		 */
		public function noise( x:Number, y:Number=0.0, z:Number=0.0 ):Number
		{
			if (x < 0) x = -x;
			if (y < 0) y = -y;
			if (z < 0) z = -z;
			
			var xi:int = int(x);
			var yi:int = int(y);
			var zi:int = int(z);
			var xf:Number = x-xi;
			var yf:Number = y-yi;
			var zf:Number = z-zi;
			var rxf:Number;
			var ryf:Number;
			
			var r:Number = 0.0;
			var ampl:Number = 0.5;
			
			var n1:Number;
			var n2:Number;
			var n3:Number;
			
			for ( var i:int=0; i < perlin_octaves; i++) 
			{
				var of:int = xi+(yi<<PERLIN_YWRAPB)+(zi<<PERLIN_ZWRAPB);
				
				rxf = 0.5 * (1.0 - Math.cos( xf * Math.PI ));
				ryf = 0.5 * (1.0 - Math.cos( yf * Math.PI ));
				
				n1  = perlin[of&PERLIN_SIZE];
				n1 += rxf*(perlin[(of+1)&PERLIN_SIZE]-n1);
				n2  = perlin[(of+PERLIN_YWRAP)&PERLIN_SIZE];
				n2 += rxf*(perlin[(of+PERLIN_YWRAP+1)&PERLIN_SIZE]-n2);
				n1 += ryf*(n2-n1);
				
				of += PERLIN_ZWRAP;
				n2  = perlin[of&PERLIN_SIZE];
				n2 += rxf*(perlin[(of+1)&PERLIN_SIZE]-n2);
				n3  = perlin[(of+PERLIN_YWRAP)&PERLIN_SIZE];
				n3 += rxf*(perlin[(of+PERLIN_YWRAP+1)&PERLIN_SIZE]-n3);
				n2 += ryf*(n3-n2);
				
				n1 += 0.5 * (1.0 - Math.cos( zf * Math.PI ))*(n2-n1);
				
				r += n1*ampl;
				ampl *= perlin_amp_falloff;
				xi<<=1; xf*=2;
				yi<<=1; yf*=2;
				zi<<=1; zf*=2;
				
				if (xf>=1.0 ) { xi++; xf--; }
				if (yf>=1.0 ) { yi++; yf--; }
				if (zf>=1.0 ) { zi++; zf--; }
			}
			return r;
		}
		
		public function noiseDetail( lod:int, falloff:Number=0):void
		{
			if (lod>0) perlin_octaves=lod;
			if (falloff>0) perlin_amp_falloff = falloff;
		}
		
		/*
		public noiseSeed( what:int ):void
		{
			if (perlinRandom == null) perlinRandom = new Random();
			perlinRandom.setSeed(what);
			// force table reset after changing the random number seed [0122]
			random_init();
		}
		*/
	}
	
}