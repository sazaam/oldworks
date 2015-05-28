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
    import org.libspark.aocontainer.builders.BasicAOContainerBuilder;
    
    /**
     * <code>AOContainer</code>を生成するためのファクトリクラスです。
     *
     * @author yossy
     */
    public class AOContainerFactory
    {
        private static var _builder:AOContainerBuilder = new BasicAOContainerBuilder();
        
        /**
         * <code>AOContainer</code>を生成するビルダを設定します。
         */
        public static function get builder():AOContainerBuilder
        {
            return _builder;
        }
        
        /**
         * @private
         */
        public static function set builder(value:AOContainerBuilder):void
        {
            _builder = value;
        }
        
        /**
         * 指定された設定に従って<code>AOContainer</code>を生成して返します。
         * @param configuration <code>AOContainer</code>の設定を記述したxml
         * @param initializing <code>true</code>であればコンテナの初期化（AOContainer.initialize)を行います
         * @return <code>configuration</code>で指定した設定に従って生成された</code>AOContainer</code>
         */
        public static function create(configuration:XML, initializing:Boolean = true):AOContainer
        {
            var container:AOContainer = _builder.build(configuration);
            if (initializing) {
                container.initialize();
            }
            return container;
        }
    }
}