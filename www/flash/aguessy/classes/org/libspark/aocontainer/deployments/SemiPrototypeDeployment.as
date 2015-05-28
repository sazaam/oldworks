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

package org.libspark.aocontainer.deployments
{
    import org.libspark.aocontainer.Deployment;
    import org.libspark.aocontainer.Deployer;
    import org.libspark.aocontainer.Definition;
    import org.libspark.aocontainer.deployers.SemiPrototypeDeployer;
    
    /**
     * 常に新しいオブジェクトを配備しますが、配備のタイミングが同じ間は同じオブジェクトを返す定義です。
     *
     * @author yossy
     */
    public class SemiPrototypeDeployment implements Deployment
    {
        private var deployer:Deployer;
        
        /**
         * @inheritDoc
         */
        public function getDeployer(def:Definition):Deployer
        {
            return deployer || createDeployer(def);
        }
        
        private function createDeployer(def:Definition):Deployer
        {
            var deployer:SemiPrototypeDeployer = new SemiPrototypeDeployer();
            
            var parentDef:Definition = def;
            while (parentDef = parentDef.parent) {
                if (parentDef.deployment is SemiPrototypeDeployment) {
                    SemiPrototypeDeployer(SemiPrototypeDeployment(parentDef.deployment).getDeployer(parentDef)).addChild(deployer);
                    break;
                }
            }
            
            this.deployer = deployer;
            
            return deployer;
        }
    }
}