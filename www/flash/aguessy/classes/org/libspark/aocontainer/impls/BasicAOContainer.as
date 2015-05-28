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

package org.libspark.aocontainer.impls
{
    import org.libspark.aocontainer.AOContainer;
    import org.libspark.aocontainer.Definition;
    import org.libspark.aocontainer.utils.ArrayUtil;
    import org.libspark.asreflect.ASReflect;
    import org.libspark.asreflect.Type;
    import flash.utils.Dictionary;
    
    /**
     * オブジェクトを管理するコンテナの実装です。
     *
     * @author yossy
     */
    public class BasicAOContainer implements AOContainer
    {
        private static const CONTAINER_NAME:String = 'container';
        
        public function BasicAOContainer()
        {
            putDefinition(new SimpleDefinition(this, AOContainer, CONTAINER_NAME), 0, 0);
        }
        
        private var definitions:Array = [];
        private var defContainerMap:Dictionary = new Dictionary();
        private var defDataMap:Dictionary = new Dictionary();
        
        /**
         * @inheritDoc
         */
        public function get numDefinitions():uint
        {
            return definitions.length;
        }
        
        /**
         * @inheritDoc
         */
        public function registerObject(object:Object, name:String = null):void
        {
            registerDefinition(new SimpleDefinition(object, object.constructor, name));
        }
        
        /**
         * @inheritDoc
         */
        public function registerClass(objectClass:Class, name:String = null):void
        {
            registerDefinition(new BasicDefinition(objectClass, name));
        }
        
        /**
         * @inheritDoc
         */
        public function registerDefinition(definition:Definition):void
        {
            var nodes:Array = [];
            
            // この定義ツリー内の定義を再帰的に登録
            privateRegisterDefinition(definition, null, nodes);
            
            // この定義ツリー内の全頂点対距離を算出
            var numNodes:uint = nodes.length;
            for each (var node:DefNode in nodes) {
                node.defData.distances = new Array(numNodes);
                calcDistances(node.defData.distances, node, null, 0);
            }
            // これにより、definitionA.root == definitionB.rootの場合、
            //  defDataMap[definitionA].distances[defDataMap[definitionB].id]
            // でdefinitionAからdefinitionBまでの距離が求められる。
            //
            // また、definitionA.root != definitionB.rootの場合、
            //  defDataMap[definitionA].depth + defDataMap[definitionB].depth + 1
            // でdefinitionAからdefinitionBまでの距離が求まる。（はず）
            //
            // ちなみに、
            //  DefinitionData.id は Definitionの識別子（ただしrootごと）
            //  DefinitionData.depth は Definitionのrootからの深さ
            //  DefinitionData.distances は このDefinitionから、同じrootに属する他のDefinitionまでの距離
        }
        
        private function privateRegisterDefinition(definition:Definition, parent:DefNode, nodes:Array):void
        {
            var depth:uint = parent ? parent.defData.depth + 1 : 0;
            
            // 自分
            definition.container = this;
            definitions.push(definition);
            var defData:DefinitionData = putDefinition(definition, depth, nodes.length);
            
            var defNode:DefNode = new DefNode();
            defNode.defData = defData;
            defNode.children = [];
            nodes.push(defNode);
            
            if (parent) {
                defNode.children.push(parent);
                parent.children.push(defNode);
            }
            
            // 子
            var n:uint = definition.numChildren;
            for (var i:uint = 0; i < n; ++i) {
                privateRegisterDefinition(definition.getChildAt(i), defNode, nodes);
            }
        }
        
        private function putDefinition(definition:Definition, depth:int, id:uint):DefinitionData
        {
            var defData:DefinitionData = new DefinitionData();
            defData.id = id;
            defData.definition = definition;
            defData.depth = depth;
            defDataMap[definition] = defData;
            
            putDefinitionData(definition.objectName, getAssignableClasses(definition.objectClass), defData);
            
            return defData;
        }
        
        private function putDefinitionData(name:String, classes:Array, defData:DefinitionData):void
        {
			var defContainer:DefinitionContainer
            if (name) {
                defContainer = defContainerMap[name];
                if (!defContainer) {
                    defContainerMap[name] = defContainer = new DefinitionContainer(true);
                }
                defContainer.addDefinition(defData, classes);
            }
            if (classes) {
                for each (var keyClass:Class in classes) {
                    defContainer  = defContainerMap[keyClass];
                    if (!defContainer) {
                        defContainerMap[keyClass] = defContainer = new DefinitionContainer(false);
                    }
                    defContainer.addDefinition(defData);
                }
            }
        }
        
        private function calcDistances(distances:Array, self:DefNode, from:DefNode, distance:uint):void
        {
            distances[self.defData.id] = distance;
            
            ++distance;
            
            for each (var child:DefNode in self.children) {
                if (child != from) {
                    calcDistances(distances, child, self, distance);
                }
            }
        }
        
        private function getAssignableClasses(clazz:Class):Array
        {
            var classes:Array = [clazz];
            
            var classType:Type = ASReflect.getType(clazz);
            
            for each (var superClass:Class in classType.superClasses) {
                classes.push(superClass);
            }
            for each (var impl:Class in classType.interfaces) {
                classes.push(impl);
            }
            
            return classes;
        }
        
        /**
         * @inheritDoc
         */
        public function hasDefinition(key:Object):Boolean
        {
            return defContainerMap[key] != null;
        }
        
        /**
         * @inheritDoc
         */
        public function hasDefinitionBy(name:String, type:Class):Boolean
        {
            var defContainer:DefinitionContainer = defContainerMap[name];
            return defContainer && defContainer.hasDefinitionBy(type);
        }
        
        /**
         * @inheritDoc
         */
        public function hasUniqueDefinition(key:Object, from:Definition = null):Boolean
        {
            var defContainer:DefinitionContainer = defContainerMap[key];
            return defContainer && defContainer.hasUniqueDefinition(from ? defDataMap[from] : null);
        }
        
        /**
         * @inheritDoc
         */
        public function hasUniqueDefinitionBy(name:String, type:Class, from:Definition = null):Boolean
        {
            var defContainer:DefinitionContainer = defContainerMap[name];
            return defContainer && defContainer.hasUniqueDefinitionBy(type, from ? defDataMap[from] : null);
        }
        
        /**
         * @inheritDoc
         */
        public function getDefinition(key:Object, from:Definition = null):Definition
        {
            var defContainer:DefinitionContainer = defContainerMap[key];
            if (!defContainer) {
                return null;
            }
            return defContainer.getDefinition(from ? defDataMap[from] : null);
        }
        
        /**
         * @inheritDoc
         */
        public function getDefinitionBy(name:String, type:Class, from:Definition = null):Definition
        {
            var defContainer:DefinitionContainer = defContainerMap[name];
            if (!defContainer) {
                return null;
            }
            return defContainer.getDefinitionBy(type, from ? defDataMap[from] : null);
        }
        
        /**
         * @inheritDoc
         */
        public function getDefinitions(key:Object, from:Definition = null):Array
        {
            var defContainer:DefinitionContainer = defContainerMap[key];
            if (!defContainer) {
                return [];
            }
            return defContainer.getDefinitions(from ? defDataMap[from] : null);
        }
        
        /**
         * @inheritDoc
         */
        public function getDefinitionsBy(name:String, type:Class, from:Definition = null):Array
        {
            var defContainer:DefinitionContainer = defContainerMap[name];
            if (!defContainer) {
                return [];
            }
            return defContainer.getDefinitionsBy(type, from ? defDataMap[from] : null);
        }
        
        /**
         * @inheritDoc
         */
        public function getDefinitionAt(index:int):Definition
        {
            return ArrayUtil.getElementAt(index, definitions);
        }
        
        /**
         * @inheritDoc
         */
        public function initialize():void
        {
            var defs:Array = definitions;
            var len:uint = defs.length;
            for (var i:uint = 0; i < len; ++i) {
                Definition(defs[i]).initialize();
            }
        }
        
        /**
         * @inheritDoc
         */
        public function finalize():void
        {
            var defs:Array = definitions;
            var i:uint = defs.length;
            while (--i >= 0) {
                Definition(defs[i]).finalize();
            }
        }
        
        /**
         * @inheritDoc
         */
        public function getObject(key:Object, from:Definition = null):Object
        {
            return toObject(getDefinition(key, from));
        }
        
        /**
         * @inheritDoc
         */
        public function getObjectBy(name:String, type:Class, from:Definition = null):Object
        {
            return toObject(getDefinitionBy(name, type, from));
        }
        
        /**
         * @inheritDoc
         */
        public function getObjects(key:Object, from:Definition = null):Array
        {
            return toObjectArray(getDefinitions(key, from));
        }
        
        /**
         * @inheritDoc
         */
        public function getObjectsBy(name:String, type:Class, from:Definition = null):Array
        {
            return toObjectArray(getDefinitionsBy(name, type, from));
        }
        
        private function toObject(definition:Definition):Object
        {
            return definition ? definition.getObject() : null;
        }
        
        private function toObjectArray(definitions:Array):Array
        {
            var len:uint = definitions.length;
            var objects:Array = new Array(len);
            for (var i:uint = 0; i < len; ++i) {
                objects[i] = Definition(definitions[i]).getObject();
            }
            return objects;
        }
    }
}

import org.libspark.aocontainer.Definition;
import org.libspark.aocontainer.errors.DuplicateError;
import flash.utils.Dictionary;

class DefinitionData
{
    public var id:uint;
    public var definition:Definition;
    public var depth:uint;
    public var distances:Array;
}

class DefNode
{
    public var defData:DefinitionData;
    public var children:Array;
}

class DefinitionContainer
{
    public function DefinitionContainer(isNameContainer:Boolean)
    {
        this.isNameContainer = isNameContainer;
        
        if (isNameContainer) {
            definitionMap = new Dictionary();
        }
    }
    
    private var isNameContainer:Boolean;
    private var definitions:Array = [];
    private var definitionMap:Dictionary;
    
    public function addDefinition(defData:DefinitionData, classes:Array = null):void
    {
        definitions.push(defData);
        
        if (isNameContainer && classes) {
            for each (var keyClass:Class in classes) {
                if (!definitionMap[keyClass]) {
                    definitionMap[keyClass] = [];
                }
                definitionMap[keyClass].push(defData);
            }
        }
    }
    
    public function hasDefinitionBy(key:Class):Boolean
    {
        return definitionMap[key] != null;
    }
    
    public function hasUniqueDefinition(from:DefinitionData):Boolean
    {
        return privateHasUniqueDefinition(definitions, from);
    }
    
    public function hasUniqueDefinitionBy(key:Class, from:DefinitionData):Boolean
    {
        var definitions:Array = definitionMap[key];
        if (!definitions) {
            return false;
        }
        return privateHasUniqueDefinition(definitions, from);
    }
    
    private function privateHasUniqueDefinition(defs:Array, from:DefinitionData):Boolean
    {
        if (defs.length == 1) {
            return true;
        }
        
        var distances:Array = null;
        var fromDepth:uint = 0;
        var fromRoot:Definition = null;
        if (from) {
            distances = from.distances;
            fromDepth = from.depth;
            fromRoot = from.definition.root;
        }
        var minDist:int = 2147483647;
        var len:uint = defs.length;
        var isUnique:Boolean = true;
        for (var i:uint = 0; i < len; ++i) {
            var defData:DefinitionData = defs[i];
            var dist:int;
            if (defData.definition.root == fromRoot) {
                dist = distances[defData.id];
            }
            else {
                dist = defData.depth + fromDepth + 1;
            }
            if (minDist < dist) {
                continue;
            }
            else if (minDist > dist) {
                minDist = dist;
                isUnique = true;
            }
            else {
                isUnique = false;
            }
        }
        return isUnique;
    }
    
    public function getDefinitionBy(key:Class, from:DefinitionData):Definition
    {
        var definitions:Array = definitionMap[key];
        if (!definitions) {
            return null;
        }
        return privateGetDefinition(definitions, from);
    }
    
    public function getDefinition(from:DefinitionData):Definition
    {
        return privateGetDefinition(definitions, from);
    }
    
    private function privateGetDefinition(defs:Array, from:DefinitionData):Definition
    {
        if (defs.length == 1) {
            return DefinitionData(defs[0]).definition;
        }
        
        var distances:Array = null;
        var fromDepth:uint = 0;
        var fromRoot:Definition = null;
        if (from) {
            distances = from.distances;
            fromDepth = from.depth;
            fromRoot = from.definition.root;
        }
        var minDist:int = 2147483647;
        var minDef:Definition;
        var isUnique:Boolean = true;
        var len:uint = defs.length;
        for (var i:uint = 0; i < len; ++i) {
            var defData:DefinitionData = defs[i];
            var def:Definition = defData.definition;
            var dist:int;
            if (def.root == fromRoot) {
                dist = distances[defData.id];
            }
            else {
                dist = defData.depth + fromDepth + 1;
            }
            if (minDist < dist) {
                continue;
            }
            else if (minDist > dist) {
                minDist = dist;
                minDef = def;
                isUnique = true;
            }
            else {
                isUnique = false;
            }
        }
        if (!isUnique) {
            throw new DuplicateError();
        }
        
        return minDef;
    }
    
    public function getDefinitions(from:DefinitionData):Array
    {
        return privateGetDefinitions(definitions, from);
    }
    
    public function getDefinitionsBy(key:Class, from:DefinitionData):Array
    {
        var definitions:Array = definitionMap[key];
        if (!definitions) {
            return [];
        }
        return privateGetDefinitions(definitions, from);
    }
    
    private function privateGetDefinitions(defs:Array, from:DefinitionData):Array
    {
        var distances:Array = null;
        var fromDepth:uint = 0;
        var fromRoot:Definition = null;
        if (from) {
            distances = from.distances;
            fromDepth = from.depth;
            fromRoot = from.definition.root;
        }
        var len:uint = defs.length;
        var results:Array = new Array(len);
        var numResults:uint = 0;
        var minDist:int = 2147483647;
        for (var i:uint = 0; i < len; ++i) {
            var defData:DefinitionData = defs[i];
            var def:Definition = defData.definition;
            var dist:int = defData.depth;
            if (def.root == fromRoot) {
                dist = distances[defData.id];
            }
            else {
                dist = defData.depth + fromDepth + 1;
            }
            if (minDist < dist) {
                continue;
            }
            else if (minDist > dist) {
                minDist = dist;
                numResults = 0;
                results[0] = def;
            }
            else {
                results[++numResults] = def;
            }
        }
        results.length = numResults + 1;
        
        return results;
    }
}