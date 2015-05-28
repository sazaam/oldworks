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
 * オブジェクトのためのユーティリティクラスです
 */
public class ObjectUtil
{
	
    /**
     * オブジェクトに指定された複数個のプロパティがすべて定義されているかどうかを示します。
     * 
     * @param	target 対象オブジェクト
     * @param	...propNames オブジェクトのプロパティ名（型はすべて String です）
     * @return  指定されたプロパティがすべて定義されている場合は true を返します。それ以外の場合は false になります。
     * @author  michi at seyself.com
     */
    public static function hasOwnProperties( target:Object, ...propNames/* of String */ ):Boolean
    {
        var len:uint = propNames.length;
        for ( var i:uint = 0; i < len;i++ ) {
            if ( !target.hasOwnProperty(propNames[i]) ) return false;
        }
        return true;
    }
    
    /**
     * ループ処理で列挙可能なプロパティの総数を調べます
     * 
     * @param	target 対象オブジェクト
     * @return  ループ処理で列挙可能なプロパティの総数
     * @author  michi at seyself.com
     */
    public static function propLength( target:Object ):uint
    {
        var n:uint = 0;
        for (var val:String in target) n++;
        return n;
    }
	
    /**
     * オブジェクトのプロパティを配列にします。
     * 引数にプロパティ名を指定した場合、指定された順に配列を構成します。
     * プロパティ名の指定がない場合は for ループで参照した順に構成します。
     * 
     * @param	target 対象オブジェクト
     * @param	...propNames プロパティ名を文字列で指定します
     * @return  
	 * @author  michi at seyself.com
     */
    public static function toArray(target:Object, propNames:Array=null /* of String */ ):Array
    {
        var a:Array = [];
        if ( propNames ) {
            var len:uint = propNames.length;
            for (var i:uint = 0; i < len; i++ ) {
                a.push( target[propNames[i]] );
            }
            return a;
        } else {
            for (var val:String in target) {
                a.push(target[val]);
            }
            return a;
        }
    }
    
	/**
	 * オブジェクトが持つ列挙可能なプロパティの名前を一覧で取得します。
	 * 
	 * @param	target オブジェクト
	 * @return  プロパティ名の一覧
	 * @author  michi at seyself.com
	 */
	public static function getPropNames(target:Object):Array
	{
		var a:Array = [];
		for (var val:String in target) a.push(val);
		return a;
	}
	
	/**
	 * オブジェクトが持つ列挙可能なプロパティの値を一覧で取得します。
	 * 
	 * @param	target オブジェクト
	 * @return  プロパティ値の一覧
	 * @author  michi at seyself.com
	 */
	public static function getPropValues(target:Object):Array
	{
		var a:Array = [];
		for each(var val:* in target) a.push(val);
		return a;
	}
	
}
}