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
    import org.libspark.aocontainer.injections.MethodInjection;
    import org.libspark.aocontainer.Value;
    
    /**
     * method要素を処理し、MethodInjectionオブジェクトを生成します。
     *
     * @author yossy
     */
    public class MethodHandler implements ElementHandler
    {
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return 'method';
        }
        
        /**
         * @private
         */
        public function handleStartElement(context:ParseContext, element:XML):void
        {
            context.push(new MethodInjection(element.@name, []));
        }
        
        /**
         * @private
         */
        public function handleChildCreated(context:ParseContext, object:Object):void
        {
            if (object is Value) {
                MethodInjection(context.peek()).values.push(object);
            }
        }
        
        /**
         * @private
         */
        public function handleEndElement(context:ParseContext):Object
        {
            return context.pop();
        }
    }
}