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

package org.libspark.aocontainer.builders
{
    import org.libspark.aocontainer.Definition;
    import org.libspark.aocontainer.Injection;
    import org.libspark.aocontainer.Deployment;
    import org.libspark.aocontainer.Value;
    import org.libspark.aocontainer.impls.BasicDefinition;
    import org.libspark.aocontainer.injections.AutoPropertyInjection;
    import org.libspark.aocontainer.injections.CompositeInjection;
    import org.libspark.aocontainer.injections.PropertyInjection;
    import org.libspark.aocontainer.deployments.SingletonDeployment;
    import org.libspark.aocontainer.deployments.PrototypeDeployment;
    import org.libspark.aocontainer.deployments.SemiPrototypeDeployment;
    import org.libspark.aocontainer.creations.SimpleCreation;
    import org.libspark.aocontainer.creations.ConstructorInjectingCreation;
    import flash.utils.getDefinitionByName;
    
    /**
     * object要素を処理し、Definitionオブジェクトを生成します。
     *
     * @author yossy
     */
    public class ObjectHandler implements ElementHandler
    {
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return 'object';
        }
        
        /**
         * @private
         */
        public function handleStartElement(context:ParseContext, element:XML):void
        {
            context.push(context.getValue('initialInjection'));
            context.push(context.getValue('autoProperty'));
            context.push(context.getValue('finalInjection'));
            context.push(context.getValue('args'));
            
            if (isAutoInjection(element.@injection)) {
                var autoPropertyInjection:Injection = new AutoPropertyInjection();
                context.setValue('autoProperty', autoPropertyInjection);
                context.setValue('initialInjection', autoPropertyInjection);
            }
            else {
                context.setValue('autoProperty', null);
                context.setValue('initialInjection', null);
            }
            
            context.setValue('finalInjection', null);
            context.setValue('args', []);
            
            var def:Definition = new BasicDefinition();
            def.objectClass = getClass(element.attribute('class').toString());
            def.objectName = element.@name;
            def.deployment = getDeployment(element.@deployment);
            
            context.push(def);
        }
        
        protected function getClass(className:String):Class
        {
            return className ? Class(getDefinitionByName(className)) : null;
        }
        
        protected function isAutoInjection(value:String):Boolean
        {
            if (value == 'manual') return false;
            if (value == 'auto') return true;
            return defaultAutoInjection;
        }
        
        protected function get defaultAutoInjection():Boolean
        {
            return true;
        }
        
        protected function getDeployment(value:String):Deployment
        {
            if (value == 'singleton') return new SingletonDeployment();
            if (value == 'prototype') return new PrototypeDeployment();
            if (value == 'semiPrototype') return new SemiPrototypeDeployment();
            return getDeployment(defaultDeployment);
        }
        
        protected function get defaultDeployment():String
        {
            return 'singleton';
        }
        
        /**
         * @private
         */
        public function handleChildCreated(context:ParseContext, object:Object):void
        {
            var def:Definition = Definition(context.peek());
            if (object is PropertyInjection && context.getValue('autoProperty')) {
                AutoPropertyInjection(context.getValue('autoProperty')).addOverride(PropertyInjection(object));
                return;
            }
            if (object is Injection) {
                var initialInjection:Injection = Injection(context.getValue('initialInjection'));
                initialInjection = addInjection(initialInjection, Injection(object));
                context.setValue('initialInjection', initialInjection);
            }
            if (object is Value) {
                context.getValue('args').push(object);
                return;
            }
            if (object is Finalize) {
                var finalInjection:Injection = Injection(context.getValue('finalInjection'));
                for each (var injection:Injection in Finalize(object).injections) {
                    finalInjection = addInjection(finalInjection, injection);
                }
                context.setValue('finalInjection', finalInjection);
                return;
            }
            if (object is Definition) {
                def.addChild(Definition(object));
                return;
            }
        }
        
        protected function addInjection(injection:Injection, newInjection:Injection):Injection
        {
            if (!injection) {
                return newInjection;
            }
            if (injection is CompositeInjection) {
                CompositeInjection(injection).addChild(newInjection);
                return injection;
            }
            return new CompositeInjection([injection, newInjection]);
        }
        
        /**
         * @private
         */
        public function handleEndElement(context:ParseContext):Object
        {
            var def:Definition = Definition(context.pop());
            
            var args:Array = context.getValue('args') as Array;
            if (args.length > 0) {
                def.creation = new ConstructorInjectingCreation(args);
            }
            else {
                def.creation = new SimpleCreation();
            }
            
            def.initialInjection = Injection(context.getValue('initialInjection'));
            def.finalInjection = Injection(context.getValue('finalInjection'));
            
            context.setValue('args', context.pop());
            context.setValue('finalInjection', context.pop());
            context.setValue('autoProperty', context.pop());
            context.setValue('initialInjection', context.pop());
            
            return def;
        }
    }
}