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
     * コンテナによって管理されるオブジェクトの定義を表すインターフェイスです。
     *
     * @author yossy
     */
    public interface Definition
    {
        /**
         * このオブジェクトの名前を設定します。
         */
        function get objectName():String;
        
        /**
         * @private
         */
        function set objectName(value:String):void;
        
        /**
         * このオブジェクトのクラスを設定します。
         */
        function get objectClass():Class;
        
        /**
         * @private
         */
        function set objectClass(value:Class):void;
        
        /**
         * このオブジェクト定義を含むコンテナを返します。
         */
        function get container():AOContainer;
        
        /**
         * @private
         */
        function set container(value:AOContainer):void;
        
        /**
         * このオブジェクト定義の親を返します。
         */
        function get parent():Definition;
        
        /**
         * @private
         */
        function set parent(value:Definition):void;
        
        /**
         * このオブジェクト定義の親子関係の根を返します。
         */
        function get root():Definition;
        
        /**
         * @private
         */
        function set root(value:Definition):void;
        
        /**
         * このオブジェクトの生成方法を定義します。
         */
        function get creation():Creation;
        
        /**
         * @private
         */
        function set creation(value:Creation):void;
        
        /**
         * 
         */
        function get initialInjection():Injection;
        
        /**
         * @private
         */
        function set initialInjection(value:Injection):void;
        
        /**
         * 
         */
        function get finalInjection():Injection;
        
        /**
         * @private
         */
        function set finalInjection(value:Injection):void;
        
        /**
         * このオブジェクトの配備方法を定義します。
         */
        function get deployment():Deployment;
        
        /**
         * @private
         */
        function set deployment(value:Deployment):void;
        
        /**
         * 
         */
        function get numChildren():uint;
        
        /**
         * 
         * @param child 
         * @return 
         * @throws ArgumentError 指定された子定義が既に他の定義の子の場合
         */
        function addChild(child:Definition):Definition;
        
        /**
         * 
         * @param index 
         * @return 
         * @throws RangeError 指定されたインデックスが範囲外の場合
         */
        function getChildAt(index:uint):Definition;
        
        /**
         * 
         * @param child 
         * @return 
         * @throws ArgumentError 指定された子定義がこのオブジェクト定義の子ではない場合
         */
        function getChildIndex(child:Definition):int;
        
        /**
         * 
         * @param index 
         * @return 
         * @throws RangeError 指定されたインデックスが範囲外の場合
         */
        function removeChildAt(index:uint):Definition;
        
        /**
         * 
         * @param child 
         * @return 
         * @throws ArgumentError 指定された子定義がこのオブジェクト定義の子では無い場合
         */
        function removeChild(child:Definition):Definition;
        
        /**
         * 定義に従ってオブジェクトの初期化処理を行います。
         */
        function initialize():void;
        
        /**
         * 定義に従ってオブジェクトの解体処理を行います。
         */
        function finalize():void;
        
        /**
         * このオブジェクト定義が表すオブジェクトを返します。
         * @return このオブジェクト定義が表すオブジェクト
         */
        function getObject():Object;
    }
}