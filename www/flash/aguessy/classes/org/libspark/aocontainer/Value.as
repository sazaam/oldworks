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
     * DIされる値を表します。
     *
     * @author yossy
     */
    public interface Value
    {
        /**
         * 指定されたオブジェクト定義のオブジェクトに対してDIを行う際にDIされる値を提供する<code>Provider</code>を返します。
         * DIされる値の型を指定することも出来ます。
         * @param def オブジェクト定義
         * @param type 期待されるDIされる値の型
         * @return <code>def</code>で指定されたオブジェクト定義のオブジェクトに対してDIを行う際にDIされる値を提供する<code>Provider</code>
         */
        function getProvider(def:Definition, type:Class):Provider;
    }
}