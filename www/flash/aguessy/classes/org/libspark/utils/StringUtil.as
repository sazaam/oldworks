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
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	/**
	 * 文字列のためのユーティリティクラスです
	 */
	public class StringUtil {
		
		/*======================================================================*//**
		* @private
		*//*=======================================================================*/
		public function StringUtil() {
			throw new IllegalOperationError( "StringUtil クラスはインスタンスを生成できません。" );
		}
		
		
		
		
		
		/*======================================================================*//**
		* String の最初の文字を大文字にし、以降の文字を小文字に変換して返します。
		* @author	taka:nium
		* @param	str		変換したい String です。
		* @return			変換後の String です。
		*//*=======================================================================*/
		static public function toUpperCaseFirstLetter( str:String ):String {
			return str.charAt( 0 ).toUpperCase() + str.slice( 1 ).toLowerCase();
		}
		
		/*======================================================================*//**
		* 半角スペースを削除し、次の文字を大文字に変換します。
		* @author	taka:nium
		*           michi at seyself.com
		* @param	str		変換したい String です。
		* @return			変換後の String です。
		* @example 以下のコードでは action script 3.0 language reference という文字列を変換し出力ます。
		* <listing>
		* var str:String = "action script 3.0 language reference";
		* 
		* trace(StringUtil.camelize(str));
		* // output : ActionScript3.0LanguageReference
		* 
		* trace(StringUtil.decamelize(StringUtil.camelize(str)));
		* // output : action script 3.0 language reference
		* </listing>
		*//*=======================================================================*/
		static public function camelize( str:String ):String {
			return str.replace(/(\s|^)(\w)/g, 
				function(...$):String { return $[2].toUpperCase(); });
		}
		
		/*======================================================================*//**
		* 大文字の String を、区切り文字と小文字化した String に変換します。
		* @author	taka:nium
		*           michi at seyself.com
		* @param	str			変換したい String です。
		* @param	separater	区切り文字として使用したい String です。
		* @return				変換後の String です。
		* @example 以下のコードでは action script 3.0 language reference という文字列を変換し出力ます。
		* <listing>
		* var str:String = "action script 3.0 language reference";
		* 
		* trace("output : " + StringUtil.camelize(str));
		* // output : ActionScript3.0LanguageReference
		* 
		* trace("output : " + StringUtil.decamelize(StringUtil.camelize(str)));
		* // output : action script 3.0 language reference
		* </listing>
		*//*=======================================================================*/
		static public function decamelize( str:String, separater:String = " " ):String {
			return str.replace( /(([^.\d])(\d)|[A-Z])/g, 
				function(...$):String {
					if($[2]) return $[2] + separater + $[3].toLowerCase();
					if($[4]==0) return $[0].toLowerCase();
					return separater + $[0].toLowerCase();
				});
			//return str.replace( new RegExp( "[a-z][A-Z]", "g" ), function():String {
				//return String( arguments[0] ).toLowerCase().split( "" ).join( separater );
				//} );
		}
		
        /**
         * 改行コードをすべて\r（CR）に変換します。
         * 
         * @param	str 変換対象の文字列
         * @return  変換後の文字列を返します
         * @author  michi at seyself.com
         */
        public static function replaceLineFeed( str:String ):String
        {
            str = str.split("\r\n").join("\r");
            return str.split("\n").join("\r");
        }
        
        /**
         * 同じ文字列を複数連結した文字列を返します。
         * 
         * @param	value 文字列
         * @param	len 連結数
         * @return  新しい文字列を返します
         * @author  michi at seyself.com
         */
        public static function strpow( value:String , len:uint ):String
        {
            var tmp:String = "";
            for(var i:int=0;i<len;i++) tmp += value;
            return tmp;
        }
        
        /**
         * テキストフィールドの横幅を維持するためにtextプロパティに指定されている文字列の末尾を削ります。
         * テキストフィールドが単一行の設定でなければ効果はありません。
         * 
         * @param	textField 対象となるテキストフィールド
         * @param	width 制限する横幅
         * @param	param 末尾を3点リーダ等に置き換える場合に指定する文字列
         * @author  michi at seyself.com
         */
        public static function fitTextField( textField:TextField , width:Number , param:String="" ):void
        {
            if ( param == null ) param = ""; 
            var n:uint = param.length + 1;
            var textFormat:TextFormat = textField.getTextFormat(); // 初期状態のTextFormatを記憶 by nagase at ngsdev.org
            while( textField.textWidth > width ){
                if (textField.textWidth > width * 2) {
                    textField.text = textField.text.substr(0, textField.text.length*0.66>>0) + param;
                }
                textField.text = textField.text.substr(0, textField.text.length - n) + param;
                textField.setTextFormat(textFormat); // TextFormatを復元
            }
        }
        
		
	}
}





