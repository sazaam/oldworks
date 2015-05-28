/*======================================================================*//**
* 
* Utils for ActionScript 3.0
* 
* @author	Copyright (c) 2007 Spark project.
* @version	1.0.0
* 
* @see		http://utils.libspark.org/
* @see		http://www.libspark.org/
* 
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
* 
* http://www.apache.org/licenses/LICENSE-2.0
* 
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
* either express or implied. See the License for the specific language
* governing permissions and limitations under the License.
* 
*//*=======================================================================*/
package org.libspark.utils {
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	
	/**
	 * 基本的な計算を補うためのユーティリティクラスです
	 */
	public class MathUtil {
		
		/*======================================================================*//**
		* @private
		*//*=======================================================================*/
		public function MathUtil() {
			throw new IllegalOperationError( "MathUtil クラスはインスタンスを生成できません。" );
		}
		
		
		
		
		
		/*======================================================================*//**
		* 数値を指定された周期内に収めて返します。
		* @author	taka:nium
		* @param	number	周期内に収めたい数値です。
		* @param	cycle	周期となる数値です。
		* @return			変換後の数値です。
		*//*=======================================================================*/
		static public function cycle( number:Number, cycle:Number ):Number {
			return ( number % cycle + cycle ) % cycle;
		}
		
		/*======================================================================*//**
		* 範囲内に適合する値を返します。
		* @author	taka:nium
		* @param	number	範囲内に適合させたい数値です。
		* @param	min		範囲の最小値となる数値です。
		* @param	max		範囲の最大値となる数値です。
		* @return			変換後の数値です。
		*//*=======================================================================*/
		static public function range( number:Number, min:Number, max:Number ):Number {
			// min の方が max よりも大きい場合に入れ替える
			if ( min > max ) {
				var temp:Number = min;
				min = max;
				max = temp;
			}
			return Math.max( min, Math.min( number, max ) );
		}
		
		/*======================================================================*//**
		* 分母が 0 の場合に 0 となるパーセント値を返します。
		* @author	taka:nium
		* @param	numerator		分母となる数値です。
		* @param	denominator		分子となる数値です。
		* @return					変換後の数値です。
		*//*=======================================================================*/
		static public function percent( numerator:Number, denominator:Number ):Number {
			if ( denominator == 0 ) { return 0; }
			return numerator / denominator * 100;
		}
		
		/*======================================================================*//**
		* 縦列と横列からテーブル状の座標を格納した Point オブジェクト配列を作成します。
		* @author	taka:nium
		* @param	rows	作成する格子の縦区切り数です。
		* @param	cols	作成する格子の横区切り数です。
		* @return			作成した格子データ配列です。
		*//*=======================================================================*/
		static public function getTable( rows:uint, cols:uint ):Array {
			var table:Array = new Array();
			for ( var i:int = 0; i < rows; i++ ) {
				for ( var ii:int = 0; ii < cols; ii++ ) {
					table.push( new Point( ii, i ) );
				}
			}
			return table;
		}
		
		/*======================================================================*//**
		* ランダムで +1 もしくは -1 を返します。
		* @author	taka:nium
		* @return	+1 もしくは -1 の数値です。
		*//*=======================================================================*/
		static public function getCoin():int {
			return ( Math.random() < 0.5 ) ? 1 : -1; 
		}
        
        
        /**
        * 引数の値が正数の場合のみ、その数値を返し、負数の場合は0を返します.
        * 
        * @param n	数値
        * @return	正数（0以上の数値）
        * @author   michi at seyself.com
        */
        public static function positive( n:Number ):Number
        {
            if(n>0) return n;
            return 0;
        }
        
        /**
        * 引数の値が負数の場合のみ数値を返し、正数の場合は0を返します.
        * 
        * @param n	数値
        * @return	負数（0以下の数値）
        * @author   michi at seyself.com
        */
        public static function negative( n:Number ):Number
        {
            if(n<0) return n;
            return 0;
        }
        
        /**
        * 引数が正数の場合は+1を、負数の場合は-1、その他の場合は0を返します.
        * 
        * @param n	数値
        * @return	1 もしくは -1 、0
        * @author   michi at seyself.com
        */
        public static function judgment( n:Number ):Number
        {
            if(n>0) return 1;
            if(n<0) return -1;
            return 0;
        }
        
        /**
        * 引数から約数を求めて配列で返します.
        * 
        * @param n	数値
        * @return	約数の配列
        * @author   michi at seyself.com
        */
        public static function measure( param:Number ):Array
        {
            var m:Number = param;
            var res:Array = [1,param];
            var maxcount:Number = Math.floor(Math.sqrt(m)+1);
            for(var i:uint=2;i<maxcount ;i++){
                if(param%i==0){
                    var s:Number = 0;
                    var e:Number = 0;
                    for(var k:uint=0;k<res.length;k++){
                        if( res[k] ==i ) s++;
                        if( res[k] ==param/i ) e++;
                    }
                    if(s==0) res.push(i);
                    if(param/i!=i && e==0) res.push(param/i);
                }
            }
            return res.sort( Array.NUMERIC );
        }
        
        /**
        * 小数点以下 指定桁で四捨五入します.
        * 
        * @param param	数値
        * @param len	小数点以下の桁数
        * @return	小数点以下 指定桁で四捨五入した値
        * @author   michi at seyself.com
        */
        public static function round( param:Number , len:uint ):Number
        {
            var _mgn:uint = 1;
            for(var i:uint=0;i<len;i++) _mgn*=10;
            return Math.round(param*_mgn)/_mgn;
        }
        
        /**
        * 小数点以下 指定桁数で切り捨てた値を返します.
        * 
        * @param param	数値
        * @param len	小数点以下の桁数
        * @return	数点以下 指定桁数で切り捨てた値
        * @author   michi at seyself.com
        */
        public static function floor( param:Number , len:uint ):Number
        {
            var _mgn:uint = 1;
            for(var i:uint=0;i<len;i++) _mgn*=10;
            return Math.floor(param*_mgn)/_mgn;
        }
        
        /**
        * 指定された数値の立方根を計算して返します。
        * @param	x	立方根を求めたい数値
        * @return	x の立方根
        * @author   michi at seyself.com
        */
        public static function cuberoot( x:Number ):Number
        {
            var s:Number, t:Number, prev:Number;
            var posi:int;
            if(x==0) return 0;
            if(x>0) posi=1; else { posi=0; x= -x; }
            if(x>1) s=x; else s=1;
            do{
                prev=s; t=s*s; s+=(x-t*s)/(2*t+x/s);
            } while(s<prev);
            if( posi ) return prev;
            else return -prev;
        }
        
        /**
        * 渡された正数の値から正と負の値を交互に変換した値を返します.
        * 
        * @param n	正数の値
        * @return	引数が奇数なら負数、偶数なら正数が返ります
        * @author   michi at seyself.com
        */
        public static function xcount( i:uint ):Number
        {
            var a:Number = Math.floor(i/2);
            if(i%2>0) a = -(a+1);
            a *= -1;
            return a;
        }
        
        /**
        * 渡された引数の合計値を返します.
        * 配列を使用する場合はapplyを使用してください.
        * 
        * @param ...numbers	数値
        * @return	引数の合計値
        * @author   michi at seyself.com
        */
        public static function sum( ...numbers ):Number
        {
            var a:Number = 0;
            var leng:uint = numbers.length;
            for(var i:uint=0;i<leng;i++) a+=numbers[i];
            return a;
        }
        
        /**
        * 渡された引数の平均値を返します.
        * 配列を使用する場合はapplyを使用してください.
        * 
        * @param ...numbers 数値
        * @return	引数の平均値
        * @author   michi at seyself.com
        */
        public static function average( ...numbers ):Number
        {
            return sum.apply(null,numbers)/numbers.length;
        }
        
        /**
         * -1.0 から 1.0 の間の乱数を生成します.
         * 
         * @return  乱数
         * @author  michi at seyself.com
         */
        public static function random():Number
        {
            return Math.random() * 2 - 1;
        }
        
        /**
         * -1.0 から 1.0 の間の偏向乱数を生成します.
         * 
         * @param	interation  数値が多いほど乱数値は0に近づきます
         * @return  乱数
         * @author  michi at seyself.com
         */
        public static function biasedRandom(interation:uint = 2):Number
        {
            var n:Number = 0;
            for (var i:int = 0; i < interation; i++ ) n += random();
            return n / interation;
        }
        
        /**
         * 0.0 から 1.0 の間の疑似乱数を生成します.Perlin ノイズとはまったく関係ないです。
         * （注： あまり極端な値を設定すると正しく動作しないかもしれません。）
         * 
         * @param	i インデックス値
         * @param	seed 乱数の定義値
         * @return  数値
         * @author  michi at seyself.com
         */
        public static function noise( i:uint, seed:Number=0.0 ):Number
        {
            seed %= 0xFFF;
            i %= 0x7FF;
            var P:Number  = 3.14159265358979 * ( seed + 0.5 );
            var t:Number  = 173*i*i*i+13577 % 3568927;
            var r:Number  = (i*2.71828182845905+t)*P%1;
            return r;
        }
        
        /**
        * 渡されたラジアン値を角度に変換します.
        * 
        * @param angle	ラジアン
        * @return	角度
        * @author   michi at seyself.com
        */
        public static function degrees(angle:Number):Number
        {
            return angle / Math.PI * 180;
        }
        
        /**
        * 渡された角度をラジアン値に変換します.
        * 
        * @param angle	角度
        * @return	ラジアン
        * @author   michi at seyself.com
        */
        public static function radians(angle:Number):Number
        {
            return angle / 180 * Math.PI;
        }
        
        /**
         * 2つの角（ angle1 から angle2 ）の内角の値を調べます
         * 
         * @param	angle1 角度 (ラジアン単位) 
         * @param	angle2 角度 (ラジアン単位) 
         * @return  2つの角度の内角距離
         * @author  michi at seyself.com
         */
        public static function interiorAngle(angle1:Number, angle2:Number):Number
        {
            var a:Number = angle2 - angle1;
            return Math.atan2(Math.sin(a), Math.cos(a));
        }
        
        /**
         * 2乗した数値を返します
         * @param	value 数値
         * @return  2乗した数値
         * @author  michi at seyself.com
         */
        public static function sq(value:Number):Number
        {
            return value * value;
        }
        
		
		public static function magnitude(x:Number, y:Number, z:Number=0):Number
        {
            return Math.sqrt(x * x + y * y + z * z);
        }
        
		
		
        /**
         * (x1,y1)と(x2,y2)の距離を求めます
         * @param	x1
         * @param	y1
         * @param	x2
         * @param	y2
         * @return
         * @author  michi at seyself.com
         */
        public static function dist(x1:Number, y1:Number, x2:Number, y2:Number):Number
        {
            var nx:Number = x2 - x1;
            var ny:Number = y2 - y1;
            return Math.sqrt(nx * nx + ny * ny);
        }
        
        /**
         * (x1,y1,z1)と(x2,y2,z2)の距離を求めます
         * @param	x1
         * @param	y1
         * @param	z1
         * @param	x2
         * @param	y2
         * @param	z2
         * @return
         * @author  michi at seyself.com
         */
        public static function dist3(x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number):Number
        {
            var nx:Number = x2 - x1;
            var ny:Number = y2 - y1;
            var nz:Number = z2 - z1;
            return Math.sqrt(nx * nx + ny * ny + nz * nz);
        }
        
        /**
         * 標準値を求めます
         * @param	value
         * @param	low
         * @param	high
         * @return
         * @author  michi at seyself.com
         */
        public static function norm(value:Number, low:Number, high:Number):Number
        {
            return (value - low) / (high - low);
        }
        
        /**
         * 2つの数値 (value1,value2) の間 (amt) の数値を求めます
         * @param	value1
         * @param	value2
         * @param	amt
         * @return
         * @author  michi at seyself.com
         */
        public static function lerp(value1:Number, value2:Number, amt:Number):Number
        {
            return value1 + (value2-value1) * amt;
        }
        
        /**
         * 
         * @param	value
         * @param	low1
         * @param	high1
         * @param	low2
         * @param	high2
         * @return
         * @author  michi at seyself.com
         */
        public static function map(value:Number, low1:Number, high1:Number, low2:Number, high2:Number):Number
        {
            return (value - low1) / (high1 - low1) * (high2 - low2) + low2;
        }
        
        
        
        
		/*======================================================================*//**
		* 回転砲台のアルゴリズム
		* 現在角度から目標角度に到達するために必要となる最短の回転角を返します
		* 角度は時計回りを正の方向とします
		* @author	alumican
		* @param	current	現在の角度, 単位[rad]
		* @param	target	目標の角度, 単位[rad]
		* @return			目標へ到達するための差分角度, 単位[rad], 範囲(-2π,2π)
		*//*=======================================================================*/
		public static function earliestRotation(current:Number, target:Number):Number {
			var pi2:Number = 2 * Math.PI;
			var d:Number = target  % pi2 - current % pi2;
			if(d < 0)       { d += pi2; }
			if(d > Math.PI) { d -= pi2; }
			return d;
			
			/* --- sticky -------------------------------------------------------------------------- *
			 * :dが[-π,0)のときに無駄な計算をしている気がする - alumican
			 * :これでも大丈夫ぽいけど，剰余計算が重そう - alumican
			 *  return( ((target  % pi2) - (current % pi2) + 3 * Math.PI) % (2 * Math.PI) - Math.PI;
			 * ------------------------------------------------------------------------------------- */
		}
	
	}
}