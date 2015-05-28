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
    import org.libspark.aocontainer.Definition;
    
    /**
     * Definition#getObjectを行うProviderです。
     *
     * @author yossy
     */
    public class DefinitionProvider implements Provider
    {
        /**
         * 新しいDefinitionProviderクラスのインスタンスを生成します。
         * @param definition オブジェクト定義
         */
        public function DefinitionProvider(definition:Definition = null)
        {
            this.definition = definition;
        }
        
        /**
         * オブジェクト定義
         */
        public var definition:Definition;
        
        /**
         * @inheritDoc
         */
        public function provide():Object
        {
            return definition.getObject()
        }
    }
}