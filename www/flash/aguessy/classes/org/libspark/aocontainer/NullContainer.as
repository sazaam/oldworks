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

package org.libspark.aocontainer
{
    /**
     * @private
     * @author yossy
     */
    public class NullContainer implements AOContainer
    {
        public function get numDefinitions():uint { return 0; }
        public function registerObject(object:Object, name:String = null):void {}
        public function registerClass(objectClass:Class, name:String = null):void {}
        public function registerDefinition(definition:Definition):void {}
        public function hasDefinition(key:Object):Boolean { return false; }
        public function hasDefinitionBy(name:String, type:Class):Boolean { return false; }
        public function hasUniqueDefinition(key:Object, from:Definition = null):Boolean { return false; }
        public function hasUniqueDefinitionBy(name:String, type:Class, from:Definition = null):Boolean { return false; }
        public function getDefinition(key:Object, from:Definition = null):Definition { return null; }
        public function getDefinitionBy(name:String, type:Class, from:Definition = null):Definition { return null; }
        public function getDefinitions(key:Object, from:Definition = null):Array { return []; }
        public function getDefinitionsBy(name:String, type:Class, from:Definition = null):Array { return []; }
        public function getDefinitionAt(index:int):Definition { return null; }
        public function initialize():void {}
        public function finalize():void {}
        public function getObject(key:Object, from:Definition = null):Object { return null; }
        public function getObjectBy(name:String, type:Class, from:Definition = null):Object { return null; }
        public function getObjects(key:Object, from:Definition = null):Array { return []; }
        public function getObjectsBy(name:String, type:Class, from:Definition = null):Array { return []; }
    }
}