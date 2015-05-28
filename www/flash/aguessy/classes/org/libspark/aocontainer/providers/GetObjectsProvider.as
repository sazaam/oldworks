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
    import org.libspark.aocontainer.AOContainer;
    import org.libspark.aocontainer.Definition;
    
    /**
     * AOContainer#getObjectsを行うProviderです。
     *
     * @author yossy
     */
    public class GetObjectsProvider implements Provider
    {
        /**
         * 新しいGetObjectsProviderクラスのインスタンスを生成します。
         * @param container 検索先コンテナ
         * @param key 検索キー
         * @param from 検索基準となるオブジェクト定義
         */
        public function GetObjectsProvider(container:AOContainer = null, key:Object = null, from:Definition = null)
        {
            this.container = container;
            this.key = key;
            this.from = from;
        }
        
        /**
         * 検索キー
         */
        public var key:Object;
        
        /**
         * 検索先コンテナ
         */
        public var container:AOContainer;
        
        /**
         * 検索基準となるオブジェクト定義
         */
        public var from:Definition;
        
        /**
         * @inheritDoc
         */
        public function provide():Object
        {
            return container.getObjects(key, from);
        }
    }
}