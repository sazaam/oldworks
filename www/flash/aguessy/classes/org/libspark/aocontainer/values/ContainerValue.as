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

package org.libspark.aocontainer.values
{
    import org.libspark.aocontainer.Value;
    import org.libspark.aocontainer.Provider;
    import org.libspark.aocontainer.Definition;
    import org.libspark.aocontainer.AOContainer;
    import org.libspark.aocontainer.providers.GetObjectProvider;
    import org.libspark.aocontainer.providers.GetObjectByProvider;
    import org.libspark.aocontainer.providers.GetObjectsProvider;
    import org.libspark.aocontainer.providers.GetObjectsByProvider;
    import org.libspark.aocontainer.providers.DefinitionProvider;
    import org.libspark.aocontainer.providers.DefinitionsProvider;
    
    /**
     * コンテナ上の値を提供する定義です。
     *
     * @author yossy
     */
    public class ContainerValue implements Value
    {
        /**
         * 新しいContainerValueクラスのインスタンスを生成します。
         * @param objectName 検索キーとなるオブジェクトの名前
         * @param isArray getObjects/getObjectsByを使用するかどうか
         */
        public function ContainerValue(objectName:String = null, isArray:Boolean = false)
        {
            this.objectName = objectName;
            this.isArray = isArray;
        }
        
        /**
         * 検索キーとなるオブジェクトの名前
         */
        public var objectName:String;
        
        /**
         * getObjects/getObjectsByを使用するかどうか
         */
        public var isArray:Boolean;
        
        /**
         * @inheritDoc
         */
        public function getProvider(def:Definition, objectClass:Class):Provider
        {
            var container:AOContainer = def.container;
             var key:Object
            if (isArray) {
                if (objectName && objectClass) {
                    if (container.hasDefinitionBy(objectName, objectClass)) {
                        return new DefinitionsProvider(container.getDefinitionsBy(objectName, objectClass, def));
                    }
                    else {
                        return new GetObjectsByProvider(container, objectName, objectClass, def);
                    }
                }
                else {
                    key = objectName ? objectName : objectClass;
                    if (key) {
                        if (container.hasDefinition(key)) {
                            return new DefinitionsProvider(container.getDefinitions(key, def));
                        }
                        else {
                            return new GetObjectsProvider(container, key, def);
                        }
                    }
                }
            }
            else {
                if (objectName && objectClass) {
                    if (container.hasUniqueDefinitionBy(objectName, objectClass, def)) {
                        return new DefinitionProvider(container.getDefinitionBy(objectName, objectClass, def));
                    }
                    else {
                        return new GetObjectByProvider(container, objectName, objectClass, def);
                    }
                }
                else {
                   key = objectName ? objectName : objectClass;
                    if (key) {
                        if (container.hasUniqueDefinition(key, def)) {
                            return new DefinitionProvider(container.getDefinition(key, def));
                        }
                        else {
                            return new GetObjectProvider(container, key, def);
                        }
                    }
                }
            }
            
            return null;
        }
    }
}