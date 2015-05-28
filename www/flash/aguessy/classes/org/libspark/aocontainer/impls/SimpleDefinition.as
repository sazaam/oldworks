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
    import org.libspark.aocontainer.Definition;
    import org.libspark.aocontainer.Creation;
    import org.libspark.aocontainer.Injection;
    import org.libspark.aocontainer.Deployment;
    import org.libspark.aocontainer.AOContainer;
    import org.libspark.aocontainer.errors.AOContainerError;
    
    /**
     * 単純に指定されたオブジェクトを返すのみのオブジェクト定義クラスです。
     *
     * <p><code>creation</code>, <code>destruction</code>, 
     * <code>deployment</code>の設定は無視します。</p>
     *
     * @author yossy
     */
    public class SimpleDefinition implements Definition
    {
        /**
         * 新しいSimpleDefinitionクラスのインスタンスを生成します。
         * <p><code>objectClass</code>を省略した場合は<code>Object.constructor</code>を
         * 設定します。</p>
         *
         * @param object #getObject()で返されるオブジェクト
         * @param objectClass オブジェクトのクラス
         * @param objectName オブジェクトの名前
         */
        public function SimpleDefinition(object:Object, objectClass:Class = null, objectName:String = null)
        {
            _object = object;
            
            if (!objectClass && object) {
                _objectClass = object.constructor;
            }
            else {
                _objectClass = objectClass;
            }
            
            _objectName = objectName;
            
            _root = this;
        }
        
        private var _object:Object;
        
        /**
         * このオブジェクト定義が表すオブジェクトを設定します。
         */
        public function get object():Object
        {
            return _object;
        }
        
        /**
         * @private
         */
        public function set object(value:Object):void
        {
            _object = value;
        }
        
        private var _objectName:String;
        
        /**
         * @inheritDoc
         */
        public function get objectName():String
        {
            return _objectName;
        }
        
        /**
         * @private
         */
        public function set objectName(value:String):void
        {
            _objectName = value;
        }
        
        private var _objectClass:Class;
        
        /**
         * @inheritDoc
         */
        public function get objectClass():Class
        {
            return _objectClass;
        }
        
        /**
         * @private
         */
        public function set objectClass(value:Class):void
        {
            _objectClass = value;
        }
        
        private var _container:AOContainer;
        
        /**
         * @inheritDoc
         */
        public function get container():AOContainer
        {
            return _container;
        }
        
        /**
         * @private
         */
        public function set container(value:AOContainer):void
        {
            _container = value;
        }
        
        private var _parent:Definition;
        
        /**
         * @inheritDoc
         */
        public function get parent():Definition
        {
            return _parent;
        }
        
        /**
         * @private
         */
        public function set parent(value:Definition):void
        {
            _parent = value;
        }
        
        private var _root:Definition;
        
        /**
         * @inheritDoc
         */
        public function get root():Definition
        {
            return _root;
        }
        
        /**
         * @private
         */
        public function set root(value:Definition):void
        {
            _root = value;
        }
        
        /**
         * この設定は無視されます。
         */
        public function get creation():Creation
        {
            return null;
        }
        
        /**
         * @private
         */
        public function set creation(value:Creation):void
        {
        }
        
        /**
         * この設定は無視されます。
         */
        public function get initialInjection():Injection
        {
            return null;
        }
        
        /**
         * @private
         */
        public function set initialInjection(value:Injection):void
        {
        }
        
        /**
         * この設定は無視されます。
         */
        public function get finalInjection():Injection
        {
            return null;
        }
        
        /**
         * @private
         */
        public function set finalInjection(value:Injection):void
        {
        }
        
        /**
         * この設定は無視されます。
         */
        public function get deployment():Deployment
        {
            return null;
        }
        
        /**
         * @private
         */
        public function set deployment(value:Deployment):void
        {
        }
        
        /**
         * @inheritDoc
         */
        public function get numChildren():uint
        {
            return 0;
        }
        
        /**
         * <code>SimpleDefinition</code>では子を追加する事は出来ません。
         */
        public function addChild(child:Definition):Definition
        {
            throw new AOContainerError();
        }
        
        /**
         * @inheritDoc
         */
        public function getChildAt(index:uint):Definition
        {
            return null;
        }
        
        /**
         * @inheritDoc
         */
        public function getChildIndex(child:Definition):int
        {
            throw new ArgumentError();
        }
        
        /**
         * @inheritDoc
         */
        public function removeChildAt(index:uint):Definition
        {
            throw new RangeError();
        }
        
        /**
         * @inheritDoc
         */
        public function removeChild(child:Definition):Definition
        {
            throw new ArgumentError();
        }
        
        /**
         * @inheritDoc
         */
        public function initialize():void
        {
        }
        
        /**
         * @inheritDoc
         */
        public function finalize():void
        {
        }
        
        /**
         * @inheritDoc
         */
        public function getObject():Object
        {
            return _object;
        }
    }
}