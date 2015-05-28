/*
 * Utils for ActionScript 3.0
 * 
 * Licensed under the MIT License
 *
 * Copyright (c) 2008 Spark project  (www.libspark.org)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */
package org.libspark.utils
{
	import flash.utils.Dictionary;
	
	/**
	* 基数変換を行うクラスです。
	*/
	public class BaseUtil
	{
		/**
		 * 文字列を数値に変換します。
		 * numberが"7F"で、dictionaryが"0123456789ABCDEF"(デフォルト)の場合、127を返します。
		 * @author	Kenichi Ueno
		 * @param	number: 数値に変換したい文字列(正の数のみ)
		 * @param	dictionary: 辞書になる文字列("."は小数点として扱うので使えません)
		 * @return	numberのあらわす数をNumber型で返します。
		 * 
		 */
		static public function StringToNumber(number:String, dictionary:String = "0123456789ABCDEF"):Number
		{
			var _dictionary:Dictionary = new Dictionary(); // 連想配列
			var _base:Number = dictionary.length;
			var _numSize:int;
			var _i:int;
			var _ret:Number = 0;
			var _point:int = number.indexOf(".");
			number = number.replace(".", "");
			_numSize = number.length;
			for ( _i = 0; _i < _base; _i++ )
			{
				_dictionary[dictionary.charCodeAt(_i)] = _i;
			}
			for ( _i = 0; _i < _numSize; _i++ )
			{
				_ret *= _base;
				_ret += _dictionary[number.charCodeAt(_i)];
			}
			if ( _point > 0 )
			{
				_ret /= Math.pow( _base, _numSize - _point );
			}
			return _ret;
		}
		/**
		 * 数値を文字列に変換します。
		 * numberが127で、dictionaryが"0123456789ABCDEF"(デフォルト)の場合、"7F"を返します。
		 * @author	Kenichi Ueno
		 * @param	number: 数値に変換したい文字列
		 * @param	dictionary: 辞書になる文字列("."は小数点として扱うので使えません)
		 * @param	maxDisplayDigitNumber: 小数点以下の最大桁数
		 * @return	numberをdictionaryを基底として表した文字列を返します。
		 */
		static public function NumberToString(number:Number, dictionary:String = "0123456789ABCDEF", maxDisplayUnderPoint:int = 10):String
		{
			var _base:Number = dictionary.length;
			var _divideNum:Number;
			var _dictionary:Array = new Array(_base);
			var _i:int;
			var _ret:String = "";
			var _digitNumber:Number;
			var _tempNum:Number;
			var _digitCount:int = maxDisplayUnderPoint;
			for ( _i = 0; _i < _base; _i++ )
			{
				_dictionary[_i] = dictionary.charCodeAt(_i);
			}
			if ( number == 0 )
			{
				return String.fromCharCode(_dictionary[0]);
			} else {
				_digitNumber = Math.floor( Math.log(number) / Math.log(_base) ); // 最大桁数
			}
			_divideNum = Math.pow( _base, _digitNumber );
			if ( _digitNumber < 0 )
			{
				_ret += String.fromCharCode(_dictionary[0]);
			}
			while ( (number > 0) && (maxDisplayUnderPoint != (++_digitCount) ) )
			{
				if ( _digitNumber-- == -1 )
				{
					_ret += ".";
					_digitCount = 0;
				}
				_tempNum = Math.floor(number / _divideNum);
				_ret += String.fromCharCode(_dictionary[_tempNum]);
				number %= _divideNum;
				number *= _base;
			}
			while ( _digitNumber-- >= 0 )
			{
				_ret += String.fromCharCode(_dictionary[0]);
			}
			return _ret;
		}
	}
	
}