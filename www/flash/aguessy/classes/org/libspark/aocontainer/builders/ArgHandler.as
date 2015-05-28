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
    import org.libspark.aocontainer.Value;
    
    /**
     * arg要素を処理し、Valueオブジェクトを生成します。
     *
     * @author yossy
     */
    public class ArgHandler implements ElementHandler
    {
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return 'arg';
        }
        
        /**
         * @private
         */
        public function handleStartElement(context:ParseContext, element:XML):void
        {
            context.push(context.getValue('isArray'));
            context.push(context.getValue('value'));
            context.setValue('isArray', element.@isArray == 'true' ? true : false);
            context.setValue('value', null);
        }
        
        /**
         * @private
         */
        public function handleChildCreated(context:ParseContext, object:Object):void
        {
            if (object is Value) {
                context.setValue('value', object);
            }
        }
        
        /**
         * @private
         */
        public function handleEndElement(context:ParseContext):Object
        {
            var value:Object = context.getValue('value');
            
            context.setValue('value', context.pop());
            context.setValue('isArray', context.pop());
            
            return value;
        }
    }
}