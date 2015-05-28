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

package org.libspark.aocontainer.injections
{
    import org.libspark.aocontainer.Injection;
    import org.libspark.aocontainer.Injector;
    import org.libspark.aocontainer.Definition;
    import org.libspark.aocontainer.injectors.CompositeInjector;
    
    /**
     * 複数のインジェクションを実行するための定義です。
     *
     * @author yossy
     */
    public class CompositeInjection implements Injection
    {
        /**
         * 新しいCompositeInjectionクラスのインスタンスを生成します。
         * @param children 子Injectionの配列
         */
        public function CompositeInjection(children:Array = null)
        {
            if (children) {
                this.children = children;
            }
        }
        
        /**
         * 子Injectionの配列
         */
        public var children:Array = [];
        
        /**
         * 子Injectionを追加します。
         * @param child 追加する子Injection
         */
        public function addChild(child:Injection):void
        {
            children.push(child);
        }
        
        /**
         * @inheritDoc
         */
        public function getInjector(def:Definition):Injector
        {
            if (children && children.length > 0) {
                var c:Array = children;
                var l:uint = c.length;
                var n:uint = 0;
                var injectors:Array = new Array(l);
                for (var i:uint = 0; i < l; ++i) {
                    var injector:Injector = c[i].getInjector(def);
                    if (injector) {
                        injectors[n++] = injector;
                    }
                }
                if (n > 0) {
                    injectors.length = n;
                    return new CompositeInjector(injectors);
                }
            }
            return null;
        }
    }
}