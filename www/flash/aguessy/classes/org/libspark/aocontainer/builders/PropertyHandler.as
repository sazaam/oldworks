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
    import org.libspark.aocontainer.injections.PropertyInjection;
    import org.libspark.aocontainer.Value;
    
    /**
     * proeprty要素を処理し、PropertyInjectionオブジェクトを生成します。
     *
     * @author yossy
     */
    public class PropertyHandler implements ElementHandler
    {
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return 'property';
        }
        
        /**
         * @private
         */
        public function handleStartElement(context:ParseContext, element:XML):void
        {
            context.push(context.getValue('isArray'));
            context.push(new PropertyInjection(element.@name));
            context.setValue('isArray', element.@isArray == 'true' ? true : false);
        }
        
        /**
         * @private
         */
        public function handleChildCreated(context:ParseContext, object:Object):void
        {
            if (object is Value) {
                PropertyInjection(context.peek()).value = Value(object);
            }
        }
        
        /**
         * @private
         */
        public function handleEndElement(context:ParseContext):Object
        {
            var injection:Object = context.pop();
            context.setValue('isArray', context.pop());
            return injection;
        }
    }
}