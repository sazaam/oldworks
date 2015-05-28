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

package org.libspark.aocontainer.deployers
{
    import org.libspark.aocontainer.Deployer;
    import org.libspark.aocontainer.Creator;
    import org.libspark.aocontainer.Injector;
    
    /**
     * 常に同じオブジェクトを配備するDeployerです。
     *
     * @author yossy
     */
    public class SingletonDeployer implements Deployer
    {
        /**
         * 新しいSingletonDeployerクラスのインスタンスを生成します。
         * @param creator オブジェクトの生成を行うCreator
         * @param initialInjector オブジェクト初期化時のインジェクションを行うInjector
         * @param finalInjector オブジェクト解体時のインジェクションを行うInjector
         */
        public function SingletonDeployer(creator:Creator = null, initialInjector:Injector = null, finalInjector:Injector = null)
        {
            _creator = creator;
            _initialInjector = initialInjector;
            _finalInjector = finalInjector;
        }
        
        private var _creator:Creator;
        
        /**
         * @inheritDoc
         */
        public function get creator():Creator
        {
            return _creator;
        }
        
        /**
         * @private
         */
        public function set creator(value:Creator):void
        {
            _creator = value;
        }
        
        private var _initialInjector:Injector;
        
        /**
         * @inheritDoc
         */
        public function get initialInjector():Injector
        {
            return _initialInjector;
        }
        
        /**
         * @private
         */
        public function set initialInjector(value:Injector):void
        {
            _initialInjector = value;
        }
        
        private var _finalInjector:Injector;
        
        /**
         * @inheritDoc
         */
        public function get finalInjector():Injector
        {
            return _finalInjector;
        }
        
        /**
         * @private
         */
        public function set finalInjector(value:Injector):void
        {
            _finalInjector = value;
        }
        
        /**
         * @inheritDoc
         */
        public function initialize():void
        {
            if (!object) {
                createObject();
            }
        }
        
        /**
         * @inheritDoc
         */
        public function finalize():void
        {
            destroyObject();
        }
        
        /**
         * @inheritDoc
         */
        public function deploy():Object
        {
            return object || createObject();
        }
        
        
        private var object:Object;
        
        private function createObject():Object
        {
            // Creation
            object = _creator.create();
            // Dependency injection
            if (_initialInjector) {
                _initialInjector.inject(object);
            }
            
            return object;
        }
        
        private function destroyObject():void
        {
            // Dependency injection
            if (_finalInjector) {
                _finalInjector.inject(object);
            }
            // Destruction
            object = null;
        }
    }
}