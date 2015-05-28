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
    import org.libspark.aocontainer.Deployer;
    import org.libspark.aocontainer.utils.ArrayUtil;
    import org.libspark.aocontainer.creations.SimpleCreation;
    import org.libspark.aocontainer.deployments.SingletonDeployment;
    
    /**
     * Definitionインタフェースを実装したオブジェクト定義クラスです。
     *
     * @author yossy
     */
    public class BasicDefinition implements Definition
    {
        /**
         * Definition#creationが指定されない（null）場合に使用する生成方法を指定します。
         * デフォルトはSimpleCreationです。
         */
        public static var defaultCreation:Creation = new SimpleCreation();
        
        /**
         * Definition#deploymentが指定されない（null）場合に使用する配備方法を指定します。
         * デフォルトはSingletonDeploymentです。
         */
        public static var defaultDeployment:Deployment = new SingletonDeployment();
        
        /**
         * 新しいBasicDefinitionクラスのインスタンスを生成します。
         *
         * @param objectClass オブジェクトのクラス
         * @param objectName オブジェクトの名前
         */
        public function BasicDefinition(objectClass:Class = null, objectName:String = null)
        {
            _objectClass = objectClass;
            _objectName = objectName;
            _root = this;
        }
        
        private var initialized:Boolean = false;
        private var deployer:Deployer;
        private var children:Array = [];
        
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
            if (!value) {
                value = this;
            }
            
            _root = value;
            
            for each (var child:Definition in children) {
                child.root = value;
            }
        }
        
        private var _creation:Creation;
        
        /**
         * @inheritDoc
         */
        public function get creation():Creation
        {
            return _creation;
        }
        
        /**
         * @private
         */
        public function set creation(value:Creation):void
        {
            _creation = value;
        }
        
        private var _initialInjection:Injection;
        
        /**
         * @inheritDoc
         */
        public function get initialInjection():Injection
        {
            return _initialInjection;
        }
        
        /**
         * @private
         */
        public function set initialInjection(value:Injection):void
        {
            _initialInjection = value;
        }
        
        private var _finalInjection:Injection;
        
        /**
         * @inheritDoc
         */
        public function get finalInjection():Injection
        {
            return _finalInjection;
        }
        
        /**
         * @private
         */
        public function set finalInjection(value:Injection):void
        {
            _finalInjection = value;
        }
        
        private var _deployment:Deployment;
        
        /**
         * @inheritDoc
         */
        public function get deployment():Deployment
        {
            return _deployment;
        }
        
        /**
         * @private
         */
        public function set deployment(value:Deployment):void
        {
            _deployment = value;
        }
        
        
        /**
         * @inheritDoc
         */
        public function get numChildren():uint
        {
            return children.length;
        }
        
        /**
         * @inheritDoc
         */
        public function addChild(child:Definition):Definition
        {
            if (child.parent) {
                throw new ArgumentError();
            }
            
            child.root = _root;
            child.parent = this;
            
            return ArrayUtil.addElement(child, children);
        }
        
        /**
         * @inheritDoc
         */
        public function getChildAt(index:uint):Definition
        {
            return ArrayUtil.getElementAt(index, children);
        }
        
        /**
         * @inheritDoc
         */
        public function getChildIndex(child:Definition):int
        {
            return ArrayUtil.getElementIndex(child, children);
        }
        
        /**
         * @inheritDoc
         */
        public function removeChildAt(index:uint):Definition
        {
            var child:Definition = ArrayUtil.removeElementAt(index, children);
            child.parent = null;
            child.root = child;
            return child;
        }
        
        /**
         * @inheritDoc
         */
        public function removeChild(child:Definition):Definition
        {
            var child:Definition = ArrayUtil.removeElement(child, children);
            child.parent = null;
            child.root = child;
            return child;
        }
        
        /**
         * @inheritDoc
         */
        public function initialize():void
        {
            if (initialized) return;
            
            getDeployer().initialize();
            
            initialized = true;
        }
        
        /**
         * @inheritDoc
         */
        public function finalize():void
        {
            if (!initialized) return;
            
            getDeployer().finalize();
            
            deployer = null;
            initialized = false;
        }
        
        /**
         * @inheritDoc
         */
        public function getObject():Object
        {
            return getDeployer().deploy();
        }
        
        /**
         * @private
         */
        private function getDeployer():Deployer
        {
            if (deployer) {
                return deployer;
            }
            
            // 指定の、指定が無ければデフォルトのDeployerを作成
            var dep:Deployer = getDeploymentOrDefault().getDeployer(this);
            // 指定の、指定が無ければデフォルトのCreatorを設定
            dep.creator = getCreationOrDefault().getCreator(this);
            
            // 指定があれば初期化時のInjectorを設定
            if (_initialInjection) {
                dep.initialInjector = _initialInjection.getInjector(this);
            }
            // 指定があれば解体時のInjectorを設定
            if (_finalInjection) {
                dep.finalInjector = _finalInjection.getInjector(this);
            }
            
            deployer = dep;
            
            return dep;
        }
        
        private function getDeploymentOrDefault():Deployment
        {
            return _deployment || defaultDeployment;
        }
        
        private function getCreationOrDefault():Creation
        {
            return _creation || defaultCreation;
        }
    }
}