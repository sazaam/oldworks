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
    import org.libspark.aocontainer.Value;
    import org.libspark.aocontainer.Provider;
    import org.libspark.aocontainer.injectors.MethodInjector;
    import org.libspark.asreflect.ASReflect;
    import org.libspark.asreflect.Method;
    import org.libspark.asreflect.Parameter;
    
    /**
     * メソッドインジェクションの定義です。
     *
     * @author yossy
     */
    public class MethodInjection implements Injection
    {
        /**
         * 新しいMethodInjectionクラスのインスタンスを生成します。
         * @param name インジェクション先のメソッドの名前
         * @param values プロパティインジェクションの値の配列（null可）
         */
        public function MethodInjection(name:String = null, values:Array = null)
        {
            this.name = name;
            this.values = values;
        }
        
        /**
         * インジェクション先のプロパティの名前
         */
        public var name:String;
        
        /**
         * プロパティインジェクションの値の配列。
         * nullにすることで引数無しのメソッド呼び出しになります。
         */
        public var values:Array;
        
        /**
         * @inheritDoc
         */
        public function getInjector(def:Definition):Injector
        {
            if (!values) {
                return new MethodInjector(name);
            }
            var clazz:Class = def.objectClass;
            var method:Method = clazz ? ASReflect.getType(clazz).getMethod(name) : null;
            var parameters:Array = method ? method.parameters : null;
            var v:Array = values;
            var l:uint = v.length;
            var providers:Array = new Array(l);
            for (var i:uint = 0; i < l; ++i) {
                var parameter:Parameter = parameters ? Parameter(parameters[i]) : null;
                var parameterType:Class = parameter ? parameter.type : null;
                providers[i] = v[i].getProvider(def, parameterType);
            }
            return new MethodInjector(name, providers);
        }
    }
}