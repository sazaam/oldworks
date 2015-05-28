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
     * 常に新しいオブジェクトを配備しますが、配備のタイミングが同じ間は同じオブジェクトを返すDeployerです。
     *
     * @author yossy
     */
    public class SemiPrototypeDeployer implements Deployer
    {
        /**
         * 新しいPrototypeDeployerクラスのインスタンスを生成します。
         * @param creator オブジェクトの生成を行うCreator
         * @param initialInjector オブジェクト初期化時のインジェクションを行うInjector
         */
        public function SemiPrototypeDeployer(creator:Creator = null, initialInjector:Injector = null)
        {
            _creator = creator;
            _initialInjector = initialInjector;
        }
        
        /**
         * 子
         */
        public var children:Array = [];
        
        private var lockDepth:uint = 0;
        private var isDeploying:Boolean = false;
        private var object:Object;
        
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
         * SemiPrototypeDeployerでは解体時のインジェクションを行うことは出来ないため、この設定は無視されます。
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
         * 
         * @param child 
         * @return 
         */
        public function addChild(child:SemiPrototypeDeployer):SemiPrototypeDeployer
        {
            children.push(child);
            
            return child;
        }
        
        /**
         * 
         */
        public function lock():void
        {
            if (++lockDepth == 1) {
                lockChildren();
                createObject();
            }
        }
        
        private function lockChildren():void
        {
            for each (var child:SemiPrototypeDeployer in children) {
                child.lock();
            }
        }
        
        /**
         * 
         */
        public function unlock():void
        {
            if (--lockDepth == 0) {
                object = null;
                unlockChildren();
            }
        }
        
        private function unlockChildren():void
        {
            for each (var child:SemiPrototypeDeployer in children) {
                child.unlock();
            }
        }
        
        /**
         * @inheritDoc
         */
        public function deploy():Object
        {
            return object || deployObject();
        }
        
        private function deployObject():Object
        {
            if (isDeploying) {
                return createObject();
            }
            isDeploying = true;
            lockChildren();
            var obj:Object = createObject();
            unlockChildren();
            isDeploying = false;
            object = null;
            return obj;
        }
        
        private function createObject():Object
        {
            if (object) {
                return object;
            }
            
            object = _creator.create();
            
            if (_initialInjector) {
                _initialInjector.inject(object);
            }
            
            return object;
        }
    }
}