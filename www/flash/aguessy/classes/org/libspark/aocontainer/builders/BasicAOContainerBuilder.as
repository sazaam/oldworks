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
    import org.libspark.aocontainer.AOContainer;
    import org.libspark.aocontainer.AOContainerBuilder;
    
    /**
     * <code>AOContainer</code>を生成するビルダクラスです。
     *
     * @author yossy
     */
    public class BasicAOContainerBuilder implements AOContainerBuilder
    {
        public function BasicAOContainerBuilder()
        {
            var valueHandler:BodyHandler = new BasicValueHandler();
            
            parser = new XmlParser();
            parser.addElementHandler(new ArgHandler(), valueHandler);
            parser.addElementHandler(new PropertyHandler(), valueHandler);
            parser.addElementHandler(new MethodHandler());
            parser.addElementHandler(new FinalizeHandler());
            parser.addElementHandler(new ObjectHandler());
            parser.addElementHandler(new ObjectsHandler());
        }
        
        private var parser:XmlParser;
        
        /**
         * @inheritDoc
         */
        public function build(configuration:XML):AOContainer
        {
            return AOContainer(parser.parse(configuration));
        }
    }
}