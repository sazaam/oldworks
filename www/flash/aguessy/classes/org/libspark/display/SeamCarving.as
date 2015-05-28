/**
* An implementation of seam carving.
* Algorithm by Shai Avidan, Ariel Shamir
* Seam Carving for Content-Aware Image Resizing
* ACM SIGGRAPH 2007
* http://www.faculty.idc.ac.il/arik/
*
* ネタです。
* shrinkWidth に非常に時間がかかります。
* 適当実装なので高速化しようとしたんですが、
* すでにやられてしまったようです。
* http://www.quasimondo.com/archives/000652.php
*
* @author rch850
*/

package org.libspark.display {
	import flash.display.BitmapData;

	public class SeamCarving {
		/**
		* Shrinks the width of bitmap.
		* ビットマップの幅を縮めます。
		* @param	bitmap
		*/
		static public function shrinkWidth(bitmap:BitmapData):void {
			var energy:BitmapData = createEnergy(bitmap);
			var energySum:BitmapData = createEnergySum(energy);
			
			var xo:int;
			var emin:int = int.MAX_VALUE;
			var w:int = energySum.width;
			var h:int = energySum.height;
			
			bitmap.lock();
			
			// Find the x coordinate of bottom of the seam.
			(function():void{
				for (var x:int = 0; x < w; ++x) {
					var e:int = energySum.getPixel(x, h - 1);
					if (e < emin) {
						emin = e;
						xo = x;
					}
				}
			})();
			
			// Shrink bottom line.
			(function():void{
				for (var x:int = xo; x < w - 1; ++x) {
					bitmap.setPixel(x, h - 1, bitmap.getPixel(x + 1, h - 1));
				}
				bitmap.setPixel(w - 1, h - 1, 0);
			})();
			
			var DX:Array = [-1, 0, 1];
			
			// Shrink each lines from bottom to top.
			(function():void{
				var x:int, y:int;
				
				for (y = h - 2; y >= 0; --y) {
					emin = int.MAX_VALUE;
					var xoo:int = xo;
					for (var i:int = 0; i < 3; ++i) {
						x = xoo + DX[i];
						if (x < 0 || w - 1 < x) {
							continue;
						}
						
						var e:int = energySum.getPixel(x, y);
						if (e < emin) {
							emin = e;
							xo = x;
						}
					}
					
					for (x = xo; x < w - 1; ++x) {
						bitmap.setPixel(x, y, bitmap.getPixel(x + 1, y));
					}
					bitmap.setPixel(w - 1, y, 0);
				}
			})();
			
			bitmap.unlock();
		}
		
		/**
		* Returns Bitmap which describes an energy distribution of bitmap.
		* bitmap のエネルギー分布を表す Bitmap を返します。
		* @param	bitmap
		* @return	Bitmap which describes an energy distribution of bitmap.
		*/
		static public function createEnergy(bitmap:BitmapData):BitmapData {
			var width:int = bitmap.width;
			var height:int = bitmap.height;
			var energy:BitmapData = new BitmapData(width, height);
			
			energy.lock();
			for (var y:int = 0; y < height; ++y) {
				for (var x:int = 0; x < width; ++x) {
					energy.setPixel(x, y, getEnergy(bitmap, x, y));
				}
			}
			energy.unlock();
			
			return energy;
		}
		
		/**
		* Returns an energy value at position (x, y) of bitmap.
		* bitmap 上の座標 (x, y) が持つエネルギーを返します。
		* @param	bitmap
		* @param	x
		* @param	y
		* @return
		*/
		static public function getEnergy(bitmap:BitmapData, x:int, y:int):int {
			// Black is a special case.
			if (bitmap.getPixel(x, y) == 0) {
				return 100000;
			}
			
			var DX:Array = [-1,  0,  1,  0];
			var DY:Array = [ 0, -1,  0,  1];
			var w:int = bitmap.width;
			var h:int = bitmap.height;
			var sum:int = 0;
			var num:int = 0;
			var center:int = getBrightness(bitmap.getPixel(x, y));
			
			for (var i:int = 0; i < 4; ++i) {
				var u:int = x + DX[i];
				var v:int = y + DY[i];
				if (u < 0 || w - 1 < u || v < 0 || h - 1 < v) {
					continue;
				}
				var neighbor:int = getBrightness(bitmap.getPixel(u, v));
				sum += int(Math.abs(center - neighbor));
				++num;
			}
			if (num > 0) {
				sum /= num;
			}
			return sum;
		}
		
		/**
		* Returns a brightness value computed from rgb argument.
		* RGB 値から明るさを算出して返します。
		* @param	rgb
		* @return	brightness of rgb value.
		*/
		static public function getBrightness(rgb:int):int {
			var r:int = (rgb >> 16) & 0xFF;
			var g:int = (rgb >> 8) & 0xFF;
			var b:int = rgb & 0xFF;
			return int(0.299 * r + 0.587 * g + 0.114 * b);
		}
		
		/**
		* Returns Bitmap which describes summations of energies.
		* @param	energy
		* @return
		*/
		static public function createEnergySum(energy:BitmapData):BitmapData {
			var w:int = energy.width;
			var h:int = energy.height;
			var sum:BitmapData = new BitmapData(w, h);
			
			sum.lock();
			for (var y:int = 0; y < h; ++y) {
				for (var x:int = 0; x < w; ++x) {
					sum.setPixel(x, y, getEnergySum(sum, energy, x, y));
				}
			}
			sum.unlock();
			
			return sum;
		}
		
		/**
		* Returns summation of energies at (x, y).
		* @param	sum
		* @param	energy
		* @param	x
		* @param	y
		* @return	Summation of energies.
		*/
		static public function getEnergySum(sum:BitmapData, energy:BitmapData, x:int, y:int):int {
			if (y == 0) {
				return energy.getPixel(x, y);
			}
			
			var DX:Array = [-1, 0, 1];
			var w:int = energy.width;
			var emin:int = 1000;
			
			for (var i:int = 0; i < 3; ++i) {
				var u:int = x + DX[i];
				var v:int = y - 1;
				if (u < 0 || w - 1 < u) {
					continue;
				}
				
				var e:int = sum.getPixel(u, v);
				if (e < emin) {
					emin = e;
				}
			}
			
			return emin + energy.getPixel(x, y);
		}
	}
	
}
