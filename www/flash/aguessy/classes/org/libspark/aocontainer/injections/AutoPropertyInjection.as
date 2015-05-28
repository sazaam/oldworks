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
    import org.libspark.aocontainer.AOContainer;
    import org.libspark.aocontainer.injectors.PropertyInjector;
    import org.libspark.aocontainer.injectors.MethodInjector;
    import org.libspark.aocontainer.injectors.CompositeInjector;
    import org.libspark.aocontainer.providers.DefinitionProvider;
    import org.libspark.asreflect.ASReflect;
    import org.libspark.asreflect.Type;
    import org.libspark.asreflect.Property;
    import org.libspark.asreflect.Method;
    
    /**
     * 自動プロパティインジェクションの定義です。
     *
     * @author yossy
     */
    public class AutoPropertyInjection implements Injection
    {
        public function AutoPropertyInjection(overrides:Array = null)
        {
            if (overrides) {
                this.overrides = overrides;
            }
            else {
                this.overrides = [];
            }
        }
        
        /**
         * 手動によるプロパティインジェクションの定義を設定します。
         * ここに追加された<code>PropertyInjection</code>定義は、自動インジェクションよりも優先されます。
         */
        public var overrides:Array;
        
        /**
         * 手動によるプロパティインジェクションの定義を追加します。
         * ここで追加された<code>PropertyInjection</code>定義は、自動インジェクションよりも優先されます。
         * @param injection プロパティインジェクション定義
         */
        public function addOverride(injection:PropertyInjection):void
        {
            overrides.push(injection);
        }
        
        /**
         * @inheritDoc
         */
        public function getInjector(def:Definition):Injector
        {
            var type:Type = ASReflect.getType(def.objectClass);
            var container:AOContainer = def.container;
            
            var injectors:Array = [];
            
            for each (var injection:PropertyInjection in overrides) {
                var injector:Injector = injection.getInjector(def);
                if (injector) {
                    injectors.push(injector);
                }
            }
            
            for each (var property:Property in type.properties) {
                if (!property.isWritable || property.isStatic) {
                    continue;
                }
                var propName:String = property.name;
                var propDef:Definition = getDefinition(container, propName, property.type, def);
                if (propDef) {
                    injectors.push(new PropertyInjector(propName, new DefinitionProvider(propDef)));
                }
            }
            
            var setterReg:RegExp = /^set(.+)/i;
            for each (var method:Method in type.methods) {
                if (method.returnType != null || method.parameters.length != 1 || method.isStatic) {
                    continue;
                }
                var match:Object = setterReg.exec(method.name);
                if (match) {
                    var setterPropName:String = match[1];
                    setterPropName = setterPropName.substr(0, 1).toLowerCase() + setterPropName.substr(1);
                    var setterDef:Definition = getDefinition(container, setterPropName, method.parameters[0].type, def);
                    if (setterDef) {
                        injectors.push(new MethodInjector(method.name, [new DefinitionProvider(setterDef)]));
                    }
                }
            }
            
            if (injectors.length > 1) {
                return new CompositeInjector(injectors);
            }
            else if (injectors.length == 1) {
                return injectors[0];
            }
            
            return null;
        }
        
        private function getDefinition(container:AOContainer, name:String, type:Class, from:Definition):Definition
        {
            for each (var injection:PropertyInjection in overrides) {
                if (name == injection.name) {
                    return null;
                }
            }
            if (container.hasUniqueDefinitionBy(name, type, from)) {
                return container.getDefinitionBy(name, type, from);
            }
            if (container.hasUniqueDefinition(type, from)) {
                return container.getDefinition(type, from);
            }
            return null;
        }
    }
}