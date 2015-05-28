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
	
	/**
	 * Number オブジェクトのためのユーティリティクラスです
	 */
	public class NumberUtil {
		
		/*======================================================================*//**
		* @private
		*//*=======================================================================*/
		public function NumberUtil() {
			throw new IllegalOperationError( "NumberUtil クラスはインスタンスを生成できません。" );
		}
		
		
		
		
		
		/*======================================================================*//**
		* 数値を 1000 桁ごとにカンマをつけて返します。
		* @author	taka:nium
		* @param	number	変換したい数値です。
		* @return			変換後の数値です。
		*//*=======================================================================*/
		static public function format( number:Number ):String {
			var words:Array = String( number ).split( "" ).reverse();
			var results:Array = new Array();
			var l:int = words.length;
			for ( var i:int = 0; i < l; i++ ) {
				results.push( words[i] );
				if ( i % 3 == 2 ) {
					results.push( "," );
				}
			}
			return results.reverse().join( "" );
		}
		
		/*======================================================================*//**
		* 数値の桁数を 0 で揃えて返します。
		* @author	taka:nium
		* @param	number	変換したい数値です。
		* @param	figure	揃えたい桁数です。
		* @return			変換後の数値です。
		*//*=======================================================================*/
		static public function digit( number:Number, figure:int ):String {
			var str:String = String( number );
			for ( var i:int = 0; i < figure; i++ ) {
				str = "0" + str;
			}
			return str.substr( str.length - figure, str.length );
		}
	}
}





