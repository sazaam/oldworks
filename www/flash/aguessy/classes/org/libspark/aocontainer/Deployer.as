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
     * オブジェクトの配備を行うためのインターフェイスです。
     * <code>Creator</code>などを用いて、どのタイミングでオブジェクトを生成したり保持したりするかは、全て実装クラスに委ねられます。
     *
     * @author yossy
     */
    public interface Deployer
    {
        /**
         * オブジェクトを生成する<code>Creator</code>を設定します。
         */
        function get creator():Creator;
        
        /**
         * @private
         */
        function set creator(value:Creator):void;
        
        /**
         * 初期化時のDIを行う<code>Injector</code>を設定します。
         */
        function get initialInjector():Injector;
        
        /**
         * @private
         */
        function set initialInjector(value:Injector):void;
        
        /**
         * 解体時のDIを行う<code>Injector</code>を設定します。
         */
        function get finalInjector():Injector;
        
        /**
         * @private
         */
        function set finalInjector(value:Injector):void;
        
        /**
         * 初期化を行います。
         */
        function initialize():void;
        
        /**
         * 解体処理を行います。
         */
        function finalize():void;
        
        /**
         * オブジェクトを配備します。
         * @return 配備されたオブジェクト
         */
        function deploy():Object;
    }
}