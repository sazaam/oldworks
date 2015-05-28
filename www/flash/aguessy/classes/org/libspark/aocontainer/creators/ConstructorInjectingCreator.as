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

package org.libspark.aocontainer.creators
{
    import org.libspark.aocontainer.Creator;
    
    /**
     * 指定されたクラスのインスタンスを生成する際にコンストラクタインジェクションを行うCreatorです。
     *
     * @author yossy
     */
    public class ConstructorInjectingCreator implements Creator
    {
        /**
         * 新しいConstructorInjectingCreatorクラスのインスタンスを生成します。
         *
         * @param objectClass このCreatorが生成するインスタンスのクラス
         * @param providers コンストラクタインジェクションの値を提供するProviderの配列
         */
        public function ConstructorInjectingCreator(objectClass:Class = null, providers:Array = null)
        {
            this.objectClass = objectClass;
            this.providers = providers;
        }
        
        /**
         * このCreatorが生成するインスタンスのクラス
         */
        public var objectClass:Class;
        
        /**
         * コンストラクタインジェクションの値を提供するProviderの配列
         */
        public var providers:Array;
        
        /**
         * @inheritDoc
         */
        public function create():Object
        {
            if (providers) {
                var p:Array = providers;
                switch (p.length) {
                    case 1:
                        return new objectClass(p[0].provide());
                    case 2:
                        return new objectClass(p[0].provide(), p[1].provide());
                    case 3:
                        return new objectClass(p[0].provide(), p[1].provide(), p[2].provide());
                    case 4:
                        return new objectClass(p[0].provide(), p[1].provide(), p[2].provide(), p[3].provide());
                    case 5:
                        return new objectClass(p[0].provide(), p[1].provide(), p[2].provide(), p[3].provide(), 
                                               p[4].provide());
                    case 6:
                        return new objectClass(p[0].provide(), p[1].provide(), p[2].provide(), p[3].provide(), 
                                               p[4].provide(), p[5].provide());
                    case 7:
                        return new objectClass(p[0].provide(), p[1].provide(), p[2].provide(), p[3].provide(), 
                                               p[4].provide(), p[5].provide(), p[6].provide());
                    case 8:
                        return new objectClass(p[0].provide(), p[1].provide(), p[2].provide(), p[3].provide(), 
                                               p[4].provide(), p[5].provide(), p[6].provide(), p[7].provide());
                    case 9:
                        return new objectClass(p[0].provide(), p[1].provide(), p[2].provide(), p[3].provide(), 
                                               p[4].provide(), p[5].provide(), p[6].provide(), p[7].provide(), 
                                               p[8].provide());
                    case 10:
                        return new objectClass(p[0].provide(), p[1].provide(), p[2].provide(), p[3].provide(), 
                                               p[4].provide(), p[5].provide(), p[6].provide(), p[7].provide(), 
                                               p[8].provide(), p[9].provide());
                    case 11:
                        return new objectClass(p[0].provide(), p[1].provide(), p[2].provide(), p[3].provide(), 
                                               p[4].provide(), p[5].provide(), p[6].provide(), p[7].provide(), 
                                               p[8].provide(), p[9].provide(), p[10].provide());
                    case 12:
                        return new objectClass(p[0].provide(), p[1].provide(), p[2].provide(), p[3].provide(), 
                                               p[4].provide(), p[5].provide(), p[6].provide(), p[7].provide(), 
                                               p[8].provide(), p[9].provide(), p[10].provide(), p[11].provide());
                }
            }
            return new objectClass();
        }
    }
}