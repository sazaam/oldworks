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
    import org.libspark.aocontainer.injectors.PropertyInjector;
    import org.libspark.aocontainer.injectors.MethodInjector;
    import org.libspark.asreflect.ASReflect;
    import org.libspark.asreflect.Method;
    import org.libspark.asreflect.Property;
    import org.libspark.asreflect.Parameter;
    
    /**
     * プロパティインジェクションの定義です。
     *
     * @author yossy
     */
    public class PropertyInjection implements Injection
    {
        /**
         * 新しいPropertyInjectionクラスのインスタンスを生成します。
         * @param name インジェクション先のプロパティの名前
         * @param value プロパティインジェクションの値
         */
        public function PropertyInjection(name:String = null, value:Value = null)
        {
            this.name = name;
            this.value = value;
        }
        
        /**
         * インジェクション先のプロパティの名前
         */
        public var name:String;
        
        /**
         * プロパティインジェクションの値
         */
        public var value:Value;
        
        /**
         * @inheritDoc
         */
        public function getInjector(def:Definition):Injector
        {
            return getSetterMethodInjector(def) || getPropertyInjector(def);
        }
        
        private function getSetterMethodInjector(def:Definition):Injector
        {
            var clazz:Class = def.objectClass;
            if (clazz) {
                var reg:RegExp = new RegExp('^set' + name + '$', 'i');
                for each (var method:Method in ASReflect.getType(clazz).methods) {
                    if (method.returnType != null || method.parameters.length != 1) {
                        continue;
                    }
                    var match:Object = reg.exec(method.name);
                    if (match) {
                        var setterName:String = match[0];
                        var propertyType:Class = Parameter(method.parameters[0]).type;
                        var provider:Provider = value.getProvider(def, propertyType);
                        return new MethodInjector(setterName, [provider]);
                    }
                }
            }
            return null;
        }
        
        private function getPropertyInjector(def:Definition):Injector
        {
            var clazz:Class = def.objectClass;
            var property:Property = clazz ? ASReflect.getType(clazz).getProperty(name) : null;
            var propertyType:Class = property ? property.type : null;
            var provider:Provider = value.getProvider(def, propertyType);
            return new PropertyInjector(name, provider);
        }
    }
}