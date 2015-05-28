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
     * AOContainer#getObjectsByを行うProviderです。
     *
     * @author yossy
     */
    public class GetObjectsByProvider implements Provider
    {
        /**
         * 新しいGetObjectsByProviderクラスのインスタンスを生成します。
         * @param container 検索先コンテナ
         * @param name 検索キーとなる名前
         * @param type 検索キーとなるクラス
         * @param from 検索基準となるオブジェクト定義
         */
        public function GetObjectsByProvider(container:AOContainer = null, name:String = null, type:Class = null, from:Definition = null)
        {
            this.container = container;
            this.name = name;
            this.type = type;
            this.from = from;
        }
        
        /**
         * 検索キーとなる名前
         */
        public var name:String;
        
        /**
         * 検索キーとなるクラス
         */
        public var type:Class;
        
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
            return container.getObjectsBy(name, type, from);
        }
    }
}