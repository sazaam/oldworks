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

package org.libspark.aocontainer.injectors
{
    import org.libspark.aocontainer.Injector;
    import org.libspark.aocontainer.Provider;
    
    /**
     * プロパティインジェクションを行うInjectorです。
     *
     * @author yossy
     */
    public class PropertyInjector implements Injector
    {
        /**
         * 新しいPropertyInjectorクラスのインスタンスを生成します
         * @param name インジェクションするプロパティの名前
         * @param provider プロパティインジェクションの値を提供するProvider
         */
        public function PropertyInjector(name:String = null, provider:Provider = null)
        {
            this.name = name;
            this.provider = provider;
        }
        
        /**
         * インジェクションするプロパティの名前
         */
        public var name:String;
        
        /**
         * プロパティインジェクションの値を提供するProvider
         */
        public var provider:Provider;
        
        /**
         * @inheritDoc
         */
        public function inject(object:Object):void
        {
            object[name] = provider.provide();
        }
    }
}