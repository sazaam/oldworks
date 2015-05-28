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

package org.libspark.aocontainer.values
{
    import org.libspark.aocontainer.Value;
    import org.libspark.aocontainer.Provider;
    import org.libspark.aocontainer.Definition;
    import org.libspark.aocontainer.providers.SimpleProvider;
    
    /**
     * 単純に指定された値を提供する定義です。
     *
     * @author yossy
     */
    public class SimpleValue implements Value
    {
        /**
         * 新しいSimpleValueクラスのインスタンスを生成します。
         * @param value 提供する値
         */
        public function SimpleValue(value:Object = null)
        {
            this.value = value;
        }
        
        /**
         * 提供する値
         */
        public var value:Object;
        
        /**
         * @inheritDoc
         */
        public function getProvider(def:Definition, type:Class):Provider
        {
            return new SimpleProvider(value);
        }
    }
}