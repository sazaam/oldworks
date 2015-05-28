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
    public class DefinitionsProvider implements Provider
    {
        /**
         * 新しいDefinitionsProviderクラスのインスタンスを生成します。
         * @param definitions オブジェクト定義の配列
         */
        public function DefinitionsProvider(definitions:Array = null)
        {
            this.definitions = definitions;
        }
        
        /**
         * オブジェクト定義の配列
         */
        public var definitions:Array;
        
        /**
         * @inheritDoc
         */
        public function provide():Object
        {
            var defs:Array = definitions;
            var len:uint = defs.length;
            var objects:Array = new Array(len);
            for (var i:uint = 0; i < len; ++i) {
                objects[i] = Definition(defs[i]).getObject();
            }
            return objects;
        }
    }
}