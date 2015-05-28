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
     * 常に新しいオブジェクトを配備するDeployerです。
     *
     * @author yossy
     */
    public class PrototypeDeployer implements Deployer
    {
        /**
         * 新しいPrototypeDeployerクラスのインスタンスを生成します。
         * @param creator オブジェクトの生成を行うCreator
         * @param initialInjector オブジェクト初期化時のインジェクションを行うInjector
         */
        public function PrototypeDeployer(creator:Creator = null, initialInjector:Injector = null)
        {
            _creator = creator;
            _initialInjector = initialInjector;
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
        
        /**
         * PrototypeDeployerでは解体時のインジェクションを行うことは出来ないため、この設定は無視されます。
         */
        public function get finalInjector():Injector
        {
            return null;
        }
        
        /**
         * @private
         */
        public function set finalInjector(value:Injector):void
        {
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
        public function deploy():Object
        {
            var object:Object = _creator.create();
            
            if (_initialInjector) {
                _initialInjector.inject(object);
            }
            
            return object;
        }
    }
}