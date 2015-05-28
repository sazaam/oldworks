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

package org.libspark.aocontainer.providers
{
    import org.libspark.aocontainer.Provider;
    
    /**
     * 単純に値を返すProviderです。
     *
     * @author yossy
     */
    public class SimpleProvider implements Provider
    {
        /**
         * 新しいSimpleProviderクラスのインスタンスを生成します。
         * @param value 提供する値
         */
        public function SimpleProvider(value:Object = null)
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
        public function provide():Object
        {
            return value;
        }
    }
}