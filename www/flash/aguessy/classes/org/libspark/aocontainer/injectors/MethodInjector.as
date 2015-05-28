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
     * メソッドインジェクションを行うInjectorです。
     *
     * @author yossy
     */
    public class MethodInjector implements Injector
    {
        /**
         * 新しいMethodInjectorクラスのインスタンスを生成します
         * @param name インジェクションするメソッドの名前
         * @param providers メソッドインジェクションの値を提供するProviderの配列（null可）
         */
        public function MethodInjector(name:String = null, providers:Array = null)
        {
            this.name = name;
            this.providers = providers;
        }
        
        /**
         * インジェクションするメソッドの名前
         */
        public var name:String;
        
        /**
         * メソッドインジェクションの値を提供するProviderの配列。
         * nullにすることで引数無しのメソッド呼び出しになります。
         */
        public var providers:Array;
        
        /**
         * @inheritDoc
         */
        public function inject(object:Object):void
        {
            if (providers) {
                // Providerを元に引数の作成
                var p:Array = providers;
                var l:uint = p.length;
                var values:Array = new Array(l);
                for (var i:uint = 0; i < l; ++i) {
                    values[i] = p[i].provide();
                }
                // 呼び出し
                object[name].apply(object, values)
            }
            else {
                // 単純呼び出し
                object[name]();
            }
        }
    }
}