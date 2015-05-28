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
    import org.libspark.aocontainer.values.SimpleValue;
    import org.libspark.aocontainer.values.ContainerValue;
    
    /**
     * XML要素のボディを処理し、Valueオブジェクトを生成するクラスです。
     *
     * @author yossy
     */
    public class BasicValueHandler implements BodyHandler
    {
        /**
         * @inheritDoc
         */
        public function handleBody(context:ParseContext, body:String):Object
        {
            body = trim(body);
            
            var type:String = body.toLowerCase();
            
            if (type == 'true') {
                return new SimpleValue(true);
            }
            if (type == 'false') {
                return new SimpleValue(false);
            }
            if (type == 'null') {
                return new SimpleValue(null);
            }
            if (type == 'undefined') {
                return new SimpleValue(undefined);
            }
            if (type.charAt(0) == '"') {
                if (type.charAt(type.length - 1) == '"') {
                    return new SimpleValue(body.substring(1, body.length - 1));
                }
            }
            if (type.charAt(0) == "'") {
                if (type.charAt(type.length - 1) == "'") {
                    return new SimpleValue(body.substring(1, body.length - 1));
                }
            }
            if (type.match(/^0x[0-9a-f]+/)) {
                return new SimpleValue(parseInt(type));
            }
            if (type.match(/^[0-9]+\.[0-9]+/)) {
                return new SimpleValue(parseFloat(type));
            }
            if (type.match(/^[0-9]+/)) {
                return new SimpleValue(parseInt(type));
            }
            
            return new ContainerValue(body, context.getValue('isArray'));
        }
        
        private function trim(string:String):String
        {
            return string.replace(/^\s*(.*?)\s*$/, "$1");
        }
    }
}