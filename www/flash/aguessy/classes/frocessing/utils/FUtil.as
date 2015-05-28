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

package frocessing.utils {
	
	/**
	* ユーティリティ.
	* 
	* @author nutsu
	* @version 0.1
	*/
	public class FUtil {
		
		//---------------------------------------------------------------------------------------------------
		
		/**
		 * Number を 2進数 の文字列に変換します.
		 * @param	value
		 * @param	digits	文字列の桁数
		 */
		public static function binary( value:Number, digits:int=0 ):String
		{
			return num2str( value, digits, 2 );
		}
		
		/**
		 * 2進数の文字列を uint に変換します.
		 */
		public static function unbinary( binstr:String ):uint
		{
			return parseInt( binstr, 2 );
		}
		
		/**
		 * Number を 16進数 の文字列に変換します.
		 * @param	value
		 * @param	digits	文字列の桁数
		 */
		public static function hex( value:Number, digits:int=0 ):String
		{
			return num2str( value, digits, 16 );
		}
		
		/**
		 * 16進数の文字列を uint に変換します.
		 */
		public static function unhex( hexstr:String ):uint
		{
			return parseInt( hexstr, 16 );
		}
		
		/**
		 * Number を文字列に変換します.
		 * @param	value
		 * @param	digits	文字列の桁数
		 * @param	radix	数値からストリングへの変換に使用する基数 (2 ～ 36) .
		 */
		public static function num2str( value:Number, digits:int=0, radix:int=10 ):String
		{
			var s:String = value.toString(radix);
			if ( digits > 0 )
			{
				var len:int = s.length;
				if ( digits < len )
					return s.substr( len - digits, digits );
				else if ( digits > len )
					return Math.pow( 2, digits-len ).toString(2).substring(1) + s;
				else
					return s;
			}
			else
			{
				return s;
			}
		}
		
		//--------------------------------------------------------------------------------------------------- DATE
		
		/**
		 * 年 (2000 などの 4 桁の数字) をローカル時間で返します.
		 * @see Date#getFullYear
		 */
		public static function year():Number {
			return new Date().getFullYear();
		}
		
		/**
		 * 月 (1 月は 1、2 月は 2 など) をローカル時間で返します.
		 * @see Date#getMonth
		 */
		public static function month():Number {
			return new Date().getMonth()+1;
		}
		
		/**
		 * 日付 (1 ～ 31) をローカル時間で返します.
		 * @see Date#getDate
		 */
		public static function day():Number	{
			return new Date().getDate();
		}
		
		/**
		 * 曜日 (日曜日は 0、月曜日は 1 など) をローカル時間で返します.
		 * @see Date#getDay
		 */
		public static function weekday():Number {
			return new Date().getDay();
		}
		
		/**
		 * 時 (0 ～ 23) をローカル時間で返します.
		 * @see Date#getHours
		 */
		public static function hour():Number {
			return new Date().getHours();
		}
		
		/**
		 * 分 (0 ～ 59) をローカル時間で返します.
		 * @see Date#getMinutes
		 */
		public static function minute():Number {
			return new Date().getMinutes();
		}
		
		/**
		 * 秒 (0 ～ 59) をローカル時間で返します.
		 * @see Date#getSeconds
		 */
		public static function second():Number {
			return new Date().getSeconds();
		}
		
		/**
		 * ミリ秒 (0 ～ 999) をローカル時間で返します.
		 * @see Date#getMilliseconds
		 */
		public static function millis():Number {
			return new Date().getMilliseconds();
		}
		
	}
	
}