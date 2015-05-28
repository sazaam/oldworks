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
    import org.libspark.aocontainer.AOContainer;
    import org.libspark.aocontainer.Definition;
    import org.libspark.aocontainer.creators.SimpleCreator;
    import org.libspark.aocontainer.creators.ConstructorInjectingCreator;
    import org.libspark.aocontainer.providers.DefinitionProvider;
    import org.libspark.aocontainer.providers.SimpleProvider;
    import org.libspark.asreflect.ASReflect;
    import org.libspark.asreflect.Type;
    import org.libspark.asreflect.Parameter;
    
    /**
     * 自動でコンストラクタインジェクションを行ってクラスのインスタンスを生成する定義です。
     * 今の所、<code>flash.utils.describeType</code>の挙動がおかしいため、使用できません。
     *
     * @private
     * @author yossy
     */
    public class AutoConstructorInjectingCreation implements Creation
    {
        /**
         * @inheritDoc
         */
        public function getCreator(def:Definition):Creator
        {
            var type:Type = ASReflect.getType(def.objectClass);
            var params:Array = type.parameters;
            var numParams:uint = params.length;
            
            if (numParams == 0) {
                return new SimpleCreator(def.objectClass);
            }
            
            var container:AOContainer = def.container;
            var providers:Array = new Array(numParams);
            var i:uint = 0;
            for (; i < numParams; ++i) {
                var param:Parameter = params[i];
                var pDef:Definition = container.getDefinition(param.type, def);
                if (pDef) {
                    providers[i] = new DefinitionProvider(pDef);
                }
                else {
                    if (param.isOptional) {
                        break;
                    }
                    else {
                        providers[i] = new SimpleProvider(null);
                    }
                }
            }
            providers.length = i;
            
            return new ConstructorInjectingCreator(def.objectClass, providers);
        }
    }
}