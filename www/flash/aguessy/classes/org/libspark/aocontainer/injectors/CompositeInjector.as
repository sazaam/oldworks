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
    
    /**
     * 複数のInjectorを実行させるためのInjectorです。
     *
     * @author yossy
     */
    public class CompositeInjector implements Injector
    {
        /**
         * 新しいCompositeInjectorクラスのインスタンスを生成します。
         * @param children 子Injectorの配列
         */
        public function CompositeInjector(children:Array = null)
        {
            if (children) {
                this.children = children;
            }
            else {
                this.children = [];
            }
        }
        
        /**
         * 子Injectorの配列
         */
        public var children:Array;
        
        /**
         * 子Injectorを追加します。
         * @param child 追加する子Injector
         */
        public function addChild(child:Injector):void
        {
            children.push(child);
        }
        
        /**
         * @inheritDoc
         */
        public function inject(object:Object):void
        {
            for each (var child:Injector in children) {
                child.inject(object);
            }
        }
    }
}