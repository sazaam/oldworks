/*
 * Copyright(c) 2006-2007 the Spark project.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 * either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */

package org.libspark.utils
{
    /**
     * Arrayのためのユーティリティクラスです
     */
    public class ArrayUtil
    {
        /**
         * 配列の末尾に指定された要素を追加します。
         *
         * @param element 追加する要素
         * @param source 操作対象の配列
         * @return 追加された要素
         * @author yossy
         */
        public static function addElement(element:*, source:Array):*
        {
            source.push(element);
            return element;
        }
        
        /**
         * 配列の指定された位置に指定された要素を追加します。
         *
         * @param element 追加する要素
         * @param index 要素を追加する位置。負の値の場合、末尾からの位置になります
         * @param source 操作対象の配列
         * @return 追加された要素
         * @throws RangeError indexが範囲外の場合
         * @author yossy
         */
        public static function addElementAt(element:*, index:int, source:Array):*
        {
            if (index < 0) {
                index += source.length;
            }
            
            if (index < 0 || source.length < index) {
                throw new RangeError('index');
            }
            
            source.splice(index, 0, element);
            
            return element;
        }
        
        /**
         * 配列の指定された位置に存在する要素を取得します。
         *
         * @param index 取得する位置。負の値の場合、末尾からの位置になります
         * @param source 操作対象の配列
         * @return 指定された位置に存在する要素
         * @throws RangeError indexが範囲外の場合
         * @author yossy
         */
        public static function getElementAt(index:int, source:Array):*
        {
            if (index < 0) {
                index += source.length;
            }
            
            if (index < 0 || source.length <= index) {
                throw new RangeError('index');
            }
            
            return source[index];
        }
        
        /**
         * 指定された要素の配列内での位置を取得します。
         *
         * @param element 位置を取得する要素
         * @param source 操作対象の配列
         * @return 指定された要素の位置。配列無いに存在しない場合は-1
         * @author yossy
         */
        public static function getElementIndex(element:*, source:Array):int
        {
            return source.indexOf(element);
        }
        
        /**
         * 指定された要素を配列内から削除します。
         *
         * @param element 削除する要素
         * @param source 操作対象の配列
         * @return 削除された要素
         * @throws ArgumentError 配列内に要素が存在しない場合
         * @atuhor yossy
         */
        public static function removeElement(element:*, source:Array):*
        {
            var index:int = source.indexOf(element);
            if (index < 0) {
                throw new ArgumentError('element');
            }
            
            source.splice(index, 1);
            
            return element;
        }
        
        /**
         * 配列内の指定された位置に存在する要素を削除します。
         *
         * @param index 削除する要素の位置。負の値の場合、末尾からの位置になります
         * @param source 操作対象の配列
         * @return 削除された要素
         * @throws RangeError indexが範囲外の場合
         * @author yossy
         */
        public static function removeElementAt(index:int, source:Array):*
        {
            if (index < 0) {
                index += source.length;
            }
            
            if (index < 0 || source.length <= index) {
                throw new RangeError('index');
            }
            
            return source.splice(index, 1)[0];
        }
        
        /**
         * 配列内の指定された要素を指定された位置に移動します。
         *
         * @param element 移動する要素
         * @param index 移動先の位置。負の値の場合、末尾からの位置になります
         * @param source 操作対象の配列
         * @throws ArgumentError 配列内に要素が存在しない場合
         * @throws RangeError indexが範囲外の場合
         * @author yossy
         */
        public static function setElementIndex(element:*, index:int, source:Array):void
        {
            if (index < 0) {
                index += source.length;
            }
            
            if (index < 0 || source.length <= index) {
                throw new RangeError('index');
            }
            
            var oldIndex:int = source.indexOf(element);
            if (oldIndex < 0) {
                throw new ArgumentError('element');
            }
            
            source.splice(oldIndex, 1);
            source.splice(index, 0, element);
        }
        
        /**
         * 配列内の指定された二つの要素の位置を入れ替えます。
         *
         * @param element1 入れ替える要素
         * @param element2 入れ替える要素
         * @param source 操作対象の配列
         * @throws ArgumentError 配列内に要素が存在しない場合
         * @author yossy
         */
        public static function swapElements(element1:*, element2:*, source:Array):void
        {
            var index1:int = source.indexOf(element1);
            if (index1 < 0) {
                throw new ArgumentError('element1');
            }
            
            var index2:int = source.indexOf(element2);
            if (index2 < 0) {
                throw new ArgumentError('element2');
            }
            
            source[index1] = element2;
            source[index2] = element1;
        }
        
        /**
         * 配列内の指定された二つの位置に存在する要素を入れ替えます。
         *
         * @param index1 入れ替える要素の位置。負の値の場合、末尾からの位置になります
         * @param index2 入れ替える要素の位置。負の値の場合、末尾からの位置になります
         * @param source 操作対象の配列
         * @throws RangeError indexが範囲外の場合
         * @author yossy
         */
        public static function swapElementsAt(index1:int, index2:int, source:Array):void
        {
            if (index1 < 0) {
                index1 += source.length;
            }
            if (index1 < 0 || source.length <= index1) {
                throw new RangeError('index1');
            }
            
            if (index2 < 0) {
                index2 += source.length;
            }
            if (index2 < 0 || source.length <= index2) {
                throw new RangeError('index2');
            }
            
            var temp:* = source[index1];
            source[index1] = source[index2];
            source[index2] = temp;
        }
        
        
        /**
         * 同じデータで構成された配列を作成します
         * 
         * @param   param 配列にセットする値
         * @param   len 配列の数
         * @return  新しい配列を返します
         * @author  michi at seyself.com
         */
        public static function identicalArray( param:* , len:uint ):Array
        {
            var a:Array = [];
            for(var i:uint=0;i<len;i++) a.push(param);
            return a;
        }
        
        /**
         * 連続する数値で構成された配列を作成します
         * 
         * @param	len 作成する配列の要素数
         * @param	firstValue 配列の最初の要素に含まれる数値
         * @param	step 1要素ごとに加算（減算）されていく数値
         * @return  新たしい配列を返します
         * @author  michi at seyself.com
         */
        public static function numericArray(len:int, firstValue:Number=0, step:Number=1.0 ):Array
        {
            var a:Array = new Array(len);
            return a.map(function(v:Number, i:int, a:Array):Number { return firstValue+i*step; });
        }
        
        /**
         * 配列内の要素がすべて同じクラスのインスタンスであるかを確認します
         * 
         * @param	array 配列
         * @param	theClass 判定対象となるクラス。指定がない場合は配列の1つ目の要素のコンストラクタから判定します。
         * @return  異なるクラスのインスタンスが含まれている場合はfalseが返されます
         * @author  michi at seyself.com
         */
        public static function instanceOfEquals( array:Array, theClass:Class=null ):Boolean
        {
            var n:uint = array.length;
            
            if (n == 0) throw new ArgumentError("空の配列をチェックすることはできません。");
            
            theClass = theClass || array[0].constructor;
            
            for (var i:int = 0; i < n; i++ )
                if ( !(array[i] is theClass) ) return false;
            return true;
        }
        
        /**
         * 数値のみで構成される配列内の要素すべてに加算します
         * 
         * @param	numericArray 数値のみで構成された配列
         * @param	value 加算する数値
         * @return 新たしい配列を返します
         * @author  michi at seyself.com
         */
        public static function addNumber( numericArray:Array, value:Number ):Array
        {
            return numericArray.map(function(v:Number, i:int, a:Array):Number { return v + value; } );
        }
        
        /**
         * 数値のみで構成される配列内の要素すべてから減算します
         * 
         * @param	numericArray 数値のみで構成された配列
         * @param	value 減算する数値
         * @return 新たしい配列を返します
         * @author  michi at seyself.com
         */
        public static function subtractNumber( numericArray:Array, value:Number ):Array
        {
            return numericArray.map(function(v:Number, i:int, a:Array):Number { return v - value; } );
        }
        
        /**
         * 数値のみで構成される配列内の要素すべてに乗算します
         * 
         * @param	numericArray 数値のみで構成された配列
         * @param	value 乗算する数値
         * @return  新たしい配列を返します
         * @author  michi at seyself.com
         */
        public static function multipleNumber( numericArray:Array, value:Number ):Array
        {
            return numericArray.map(function(v:Number, i:int, a:Array):Number { return v * value; } );
        }
        
        /**
         * 数値のみで構成される配列内の要素すべてに除算します
         * 
         * @param	numericArray 数値のみで構成された配列
         * @param	value 除算する数値
         * @return  新たしい配列を返します
         * @author  michi at seyself.com
         */
        public static function divideNumber( numericArray:Array, value:Number ):Array
        {
            return numericArray.map(function(v:Number, i:int, a:Array):Number { return v / value; } );
        }
        
        /**
         * 配列をランダムに並び替えます
         * 
         * @param   array 並び替えを行う配列
         * @return  新しい配列を返します
         * @author  michi at seyself.com
         */
        public static function shuffle( array:Array ):Array
        {
            var c:Array = array.concat();
            var n:int, i:int = c.length - 1, t:*;
            for( ; i; --i ){
                n = Math.random() * i >> 0;
                t = c[i];
                c[i] = c[n];
                c[n] = t;
            }
            return c;
        }
        
        /**
         * 指定配列の中から比較対象の配列内に同じ値が含まれているものだけを抜き出した新しい配列を作ります
         * 
         * @param	array 比較元となる配列
         * @param	compareTarget 比較対象の配列
         * @return  新たしい配列を返します
         * @author  michi at seyself.com
         */
        public static function matches(array:Array, compareTarget:Array):Array
        {
            var len1:uint = array.length;
            var len2:uint = compareTarget.length;
            var res:Array = [];
            for (var i:int = 0; i < len1; i++ ) {
                for (var j:int = 0; j < len2; j++ ) {
                    if( array[i] == compareTarget[j] ) {
                        res.push( array[i] );
                        break;
                    }
                }
            }
            return res;
        }
        
        
    }
}