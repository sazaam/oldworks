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
    import flash.utils.Dictionary;
    
    /**
     * XMLをパースしてオブジェクトを生成するためのクラスです。
     *
     * @author yossy
     */
    public class XmlParser
    {
        private var handlers:Dictionary = new Dictionary();
        private var bodyHandlers:Dictionary = new Dictionary();
        
        /**
         * 要素ハンドラを追加します。
         * @param handler ハンドラ
         */
        public function addElementHandler(handler:ElementHandler, bodyHandler:BodyHandler = null):void
        {
            handlers[handler.name] = handler;
            
            if (bodyHandler) {
                bodyHandlers[handler.name] = bodyHandler;
            }
        }
        
        /**
         * XMLをパースし、オブジェクトを生成して返します。
         * @param xml パースするXML
         * @param context コンテキスト
         * @return 作成されたオブジェクト
         */
        public function parse(xml:XML, context:ParseContext = null):Object
        {
            xml.normalize();
            return privateParse(xml, context ? context : new ParseContext());
        }
        
        private function privateParse(xml:XML, context:ParseContext):Object
        {
            if (xml.nodeKind() != 'element') {
                return null;
            }
            
            var elementName:String = xml.localName();
            if (elementName == null) {
                return null;
            }
            
            var handler:ElementHandler = handlers[elementName];
            if (!handler) {
                return null;
            }
            
            handler.handleStartElement(context, xml);
            for each (var childXml:XML in xml.children()) {
                var childObject:Object = privateParse(childXml, context);
                if (childObject) {
                    handler.handleChildCreated(context, childObject);
                }
            }
            
            var bodyHandler:BodyHandler = bodyHandlers[elementName];
            if (bodyHandler) {
                var body:String = xml.text().toString();
                if (body) {
                    var bodyObject:Object = bodyHandler.handleBody(context, body);
                    if (bodyObject) {
                        handler.handleChildCreated(context, bodyObject);
                    }
                }
            }
            
            return handler.handleEndElement(context);
        }
    }
}