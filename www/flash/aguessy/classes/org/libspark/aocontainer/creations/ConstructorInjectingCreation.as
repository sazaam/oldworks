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

package org.libspark.aocontainer.creations
{
    import org.libspark.aocontainer.Creation;
    import org.libspark.aocontainer.Creator;
    import org.libspark.aocontainer.Definition;
    import org.libspark.aocontainer.creators.SimpleCreator;
    import org.libspark.aocontainer.creators.ConstructorInjectingCreator;
    import org.libspark.asreflect.ASReflect;
    import org.libspark.asreflect.Parameter;
    
    /**
     * コンストラクタインジェクションを行いながらインスタンスを生成する定義です。
     *
     * @author yossy
     */
    public class ConstructorInjectingCreation implements Creation
    {
        /**
         * 新しいConstructorInjectingCreationクラスのインスタンスを生成します。
         * @param values コンストラクタインジェクションで使用するValueの配列
         */
        public function ConstructorInjectingCreation(values:Array = null)
        {
            this.values = values;
        }
        
        /**
         * コンストラクタインジェクションで使用するValueの配列
         */
        public var values:Array;
        
        /**
         * @inheritDoc
         */
        public function getCreator(def:Definition):Creator
        {
            if (values && values.length > 0) {
                // コメントアウトしてある部分は flash.utils.describeType に存在するバグで機能しない
                // var clazz:Class = def.objectClass;
                // var parameters:Array = clazz ? ASReflect.getType(clazz).parameters : null;
                var v:Array = values;
                var l:uint = v.length;
                var providers:Array = new Array(l);
                for (var i:uint = 0; i < l; ++i) {
                    // var parameter:Parameter = parameters ? parameters[i] : null;
                    // var parameterType:Class = parameter ? parameter.type : null;
                    providers[i] = v[i].getProvider(def, /* parameterType */ null);
                }
                return new ConstructorInjectingCreator(def.objectClass, providers);
            }
            return new SimpleCreator(def.objectClass);
        }
    }
}