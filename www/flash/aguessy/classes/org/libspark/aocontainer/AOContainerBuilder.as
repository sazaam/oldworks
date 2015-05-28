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
     * <code>AOContainer</code>を生成するビルダのインターフェイスです。
     *
     * @author yossy
     */
    public interface AOContainerBuilder
    {
        /**
         * 指定された設定に従って<code>AOContainer</code>を生成して返します。
         * @param configuration <code>AOContainer</code>の設定を記述したxml
         * @return <code>configuration</code>で指定した設定に従って生成された</code>AOContainer</code>
         */
        function build(configuration:XML):AOContainer;
    }
}