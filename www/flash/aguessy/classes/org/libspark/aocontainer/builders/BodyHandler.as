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

package org.libspark.aocontainer.builders
{
    /**
     * XML要素のボディを処理し、オブジェクトを生成するためのインターフェイスです。
     *
     * @author yossy
     */
    public interface BodyHandler
    {
        /**
         * ボディを処理し、作成されたオブジェクトを返します。
         * @param context 現在のコンテキスト
         * @param body 対象となるボディ
         * @return 作成されたオブジェクト
         */
        function handleBody(context:ParseContext, body:String):Object;
    }
}