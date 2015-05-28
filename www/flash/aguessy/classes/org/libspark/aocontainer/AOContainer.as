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

package org.libspark.aocontainer
{
    /**
     * オブジェクトを管理するコンテナを表すインターフェイスです。
     *
     * @author yossy
     */
    public interface AOContainer
    {
        /**
         * このコンテナが保持するオブジェクト定義の数を返します。
         */
        function get numDefinitions():uint;
        
        /**
         * このコンテナにオブジェクトを登録します。
         * @param object 登録するオブジェクト
         * @param name オブジェクトの名前（省略可）
         */
        function registerObject(object:Object, name:String = null):void;
        
        /**
         * クラスをオブジェクト定義としてこのコンテナに登録します。
         * @param objectClass 登録するクラス
         * @param name オブジェクトの名前（省略可）
         */
        function registerClass(objectClass:Class, name:String = null):void;
        
        /**
         * このコンテナにオブジェクト定義を登録します。
         * @param definition 登録する定義
         */
        function registerDefinition(definition:Definition):void;
        
        /**
         * 指定された名前又はクラスに対応するオブジェクト定義がこのコンテナに1つ以上存在するかどうかを返します。
         * @param key キーとなる<code>String</code>又は<code>Class</code>
         * @return 対応するオブジェクト定義が1つ以上存在すれば<code>true</code>そうでなければ<code>false</code>
         */
        function hasDefinition(key:Object):Boolean;
        
        /**
         * 指定された名前とクラスの両方に対応するオブジェクト定義がこのコンテナに1つ以上存在するかどうかを返します。
         * @param name キーとなる名前
         * @param type キーとなるクラス
         * @return 対応するオブジェクト定義が1つ以上存在すれば<code>true</code>そうでなければ<code>false</code>
         */
        function hasDefinitionBy(name:String, type:Class):Boolean;
        
        /**
         * 指定された名前又はクラスに対応するオブジェクト定義がこのコンテナに存在し、かつそれが1つに定まるかどうかを返します。
         * <code>from</code>が<code>null</code>ではない場合、そのオブジェクト定義を基点とする親子関係の中で、最も近いオブジェクト定義について判定します。
         * @param key キーとなる<code>String</code>又は<code>Class</code>
         * @return 対応するオブジェクト定義が1つだけ存在すれば<code>true</code>そうでなければ<code>false</code>
         */
        function hasUniqueDefinition(key:Object, from:Definition = null):Boolean;
        
        /**
         * 指定された名前とクラスの両方に対応するオブジェクト定義がこのコンテナに存在し、かつそれが1つに定まるかどうかを返します。
         * <code>from</code>が<code>null</code>ではない場合、そのオブジェクト定義を基点とする親子関係の中で、最も近いオブジェクト定義について判定します。
         * @param name キーとなる名前
         * @param type キーとなるクラス
         * @return 対応するオブジェクト定義が1つだけ存在すれば<code>true</code>そうでなければ<code>false</code>
         */
        function hasUniqueDefinitionBy(name:String, type:Class, from:Definition = null):Boolean;
        
        /**
         * 指定された名前又はクラスに対応するオブジェクト定義を返します。
         * <code>from</code>が<code>null</code>ではない場合、そのオブジェクト定義を基点とする親子関係の中で、最も近いオブジェクト定義を返します。
         * @param key キーとなる<code>String</code>又は<code>Class</code>
         * @param from どのオブジェクト定義を基準に検索するかを指定する<code>Definition</code>
         * @return 対応するオブジェクト定義。存在しない場合は<code>null</code>
         * @throws DuplicateError 対応するオブジェクト定義が複数存在し、一意に定まらない場合。
         */
        function getDefinition(key:Object, from:Definition = null):Definition;
        
        /**
         * 指定された名前とクラスの両方に対応するオブジェクト定義を返します。
         * <code>from</code>が<code>null</code>ではない場合、そのオブジェクト定義を基点とする親子関係の中で、最も近いオブジェクト定義を返します。
         * @param name キーとなる名前
         * @param type キーとなるクラス
         * @param from どのオブジェクト定義を基準に検索するかを指定する<code>Definition</code>
         * @return 対応するオブジェクト定義。存在しない場合は<code>null</code>
         * @throws DuplicateError 対応するオブジェクト定義が複数存在し、一意に定まらない場合。
         */
        function getDefinitionBy(name:String, type:Class, from:Definition = null):Definition;
        
        /**
         * 指定された名前又はクラスに対応するオブジェクト定義を全て返します。
         * <code>from</code>が<code>null</code>ではない場合、そのオブジェクト定義を基点とする親子関係の中で、最も近いオブジェクト定義を全て返します。
         * @param key キーとなる<code>String</code>又は<code>Class</code>
         * @param from どのオブジェクト定義を基準に検索するかを指定する<code>Definition</code>
         * @return 対応するオブジェクト定義の配列。存在しない場合は空の配列。
         */
        function getDefinitions(key:Object, from:Definition = null):Array;
        
        /**
         * 指定された名前とクラスの両方に対応するオブジェクト定義を全て返します。
         * <code>from</code>が<code>null</code>ではない場合、そのオブジェクト定義を基点とする親子関係の中で、最も近いオブジェクト定義を全て返します。
         * @param name キーとなる名前
         * @param type キーとなるクラス
         * @param from どのオブジェクト定義を基準に検索するかを指定する<code>Definition</code>
         * @return 対応するオブジェクト定義の配列。存在しない場合は空の配列。
         */
        function getDefinitionsBy(name:String, type:Class, from:Definition = null):Array;
        
        /**
         * 指定されたインデックスに対応するオブジェクト定義を返します。
         * @param index インデックス
         * @return 対応するオブジェクト定義
         * @throws RangeError インデックスが範囲外の場合
         */
        function getDefinitionAt(index:int):Definition;
        
        /**
         * コンテナの初期化処理を行います。
         * 子コンテナが存在する場合、このコンテナより先に子コンテナの初期化処理を行います。
         */
        function initialize():void;
        
        /**
         * コンテナの解体処理を行います。
         * 子コンテナが存在する場合、このコンテナの後に子コンテナの解体処理を行います。
         */
        function finalize():void;
        
        /**
         * 指定された名前又はクラスに対応するオブジェクトを返します。
         * <code>from</code>が<code>null</code>ではない場合、そのオブジェクト定義を基点とする親子関係の中で、最も近いオブジェクト定義のオブジェクトを返します。
         * @param key キーとなる<code>String</code>又は<code>Class</code>
         * @param from どのオブジェクト定義を基準に検索するかを指定する<code>Definition</code>
         * @return 対応するオブジェクト。存在しない場合は<code>null</code>
         * @throws DuplicateError 対応するオブジェクト定義が複数存在し、一意に定まらない場合。
         */
        function getObject(key:Object, from:Definition = null):Object;
        
        /**
         * 指定された名前とクラスの両方に対応するオブジェクトを返します。
         * <code>from</code>が<code>null</code>ではない場合、そのオブジェクト定義を基点とする親子関係の中で、最も近いオブジェクト定義のオブジェクトを返します。
         * @param name キーとなる名前
         * @param type キーとなるクラス
         * @param from どのオブジェクト定義を基準に検索するかを指定する<code>Definition</code>
         * @return 対応するオブジェクト。存在しない場合は<code>null</code>
         * @throws DuplicateError 対応するオブジェクト定義が複数存在し、一意に定まらない場合。
         */
        function getObjectBy(name:String, type:Class, from:Definition = null):Object;
        
        /**
         * 指定された名前又はクラスに対応するオブジェクトを全て返します。
         * <code>from</code>が<code>null</code>ではない場合、そのオブジェクト定義を基点とする親子関係の中で、最も近いオブジェクト定義のオブジェクトを全て返します。
         * @param key キーとなる<code>String</code>又は<code>Class</code>
         * @param from どのオブジェクト定義を基準に検索するかを指定する<code>Definition</code>
         * @return 対応するオブジェクトの配列。存在しない場合は空の配列
         * @throws DuplicateError 対応するオブジェクト定義が複数存在し、一意に定まらない場合。
         */
        function getObjects(key:Object, from:Definition = null):Array;
        
        /**
         * 指定された名前とクラスの両方に対応するオブジェクトを全て返します。
         * <code>from</code>が<code>null</code>ではない場合、そのオブジェクト定義を基点とする親子関係の中で、最も近いオブジェクト定義のオブジェクトを全て返します。
         * @param name キーとなる名前
         * @param type キーとなるクラス
         * @param from どのオブジェクト定義を基準に検索するかを指定する<code>Definition</code>
         * @return 対応するオブジェクトの配列。存在しない場合は空の配列
         * @throws DuplicateError 対応するオブジェクト定義が複数存在し、一意に定まらない場合。
         */
        function getObjectsBy(name:String, type:Class, from:Definition = null):Array;
    }
}